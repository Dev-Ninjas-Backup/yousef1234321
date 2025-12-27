import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class ProductsController extends GetxController {
  final products = <dynamic>[].obs;
  final isLoading = false.obs;

  // Pagination fields based on the API reference
  final page = 1.obs;
  final limit = 10.obs;
  final total = 0.obs;
  final totalPages = 1.obs;
  final RxnString currentCategoryId = RxnString();
  final RxnString currentSearch = RxnString();

  // New: error message to show on UI when network/server fails
  final RxnString error = RxnString();

  /// Fetch products from /products endpoint with pagination.
  /// Only page & limit are sent as query params.
  Future<void> fetchProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? search,
  }) async {
    try {
      isLoading.value = true;

      // clear previous error
      error.value = null;

      // remember current category for loadMore
      currentCategoryId.value = categoryId;
      // remember current search term
      currentSearch.value = search;

      var url = '${Endpoint.products}?page=$page&limit=$limit';
      if (categoryId != null && categoryId.isNotEmpty)
        url = '$url&categoryId=$categoryId';
      if (search != null && search.isNotEmpty)
        url = '$url&search=${Uri.encodeQueryComponent(search)}';

      // Debug log to help diagnose API issues
      try {
        print('[ProductsController] GET $url');
      } catch (_) {}

      Response response = await ApiClient.to.get(url);

      // If server responds with non-200 or empty body, retry with absolute URL (some places expect full URL)
      if (!(response.statusCode == 200 || response.statusCode == 201) ||
          response.body == null) {
        final altUrl =
            '${Endpoint.baseUrl}${Endpoint.products}?page=$page&limit=$limit'
            '${categoryId != null && categoryId.isNotEmpty ? '&categoryId=$categoryId' : ''}'
            '${search != null && search.isNotEmpty ? '&search=${Uri.encodeQueryComponent(search)}' : ''}';
        try {
          print('[ProductsController] retry GET $altUrl');
          final retryResp = await ApiClient.to.get(altUrl);
          // replace response with retry if it looks better
          if (retryResp.statusCode == 200 || retryResp.statusCode == 201) {
            response = retryResp;
          } else {
            // keep original response for error handling
            print(
              '[ProductsController] retry non-200 ${retryResp.statusCode} ${retryResp.bodyString}',
            );
          }
        } catch (e) {
          print('[ProductsController] retry error: $e');
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        List<dynamic> items = [];

        // Primary expected shape (based on your sample): { data: [ ... ], pagination: { ... } }
        if (body is Map) {
          // Extract list from body['data'] when it's a list
          if (body['data'] is List) {
            items = List<dynamic>.from(body['data']);
          }
          // Or nested: body['data']['data']
          else if (body['data'] is Map && body['data']['data'] is List) {
            items = List<dynamic>.from(body['data']['data']);
          }
          // Also accept body['products'] or body['items']
          else if (body['products'] is List) {
            items = List<dynamic>.from(body['products']);
          } else if (body['items'] is List) {
            items = List<dynamic>.from(body['items']);
          } else if (body.values.any((v) => v is List)) {
            // Fallback: pick the first list value
            final lists = body.values.whereType<List>().toList();
            if (lists.isNotEmpty) {
              items = List<dynamic>.from(lists.first);
            }
          }

          // Parse pagination if present (either top-level or under data)
          Map? pagination;
          if (body['pagination'] is Map) {
            pagination = Map<String, dynamic>.from(body['pagination']);
          } else if (body['data'] is Map && body['data']['pagination'] is Map) {
            pagination = Map<String, dynamic>.from(body['data']['pagination']);
          }

          if (pagination != null) {
            this.page.value = (pagination['page'] is int)
                ? pagination['page']
                : this.page.value;
            this.limit.value = (pagination['limit'] is int)
                ? pagination['limit']
                : this.limit.value;
            total.value = (pagination['total'] is int)
                ? pagination['total']
                : total.value;
            totalPages.value = (pagination['totalPages'] is int)
                ? pagination['totalPages']
                : totalPages.value;
          }
        }
        // If the body is directly a list
        else if (body is List) {
          items = List<dynamic>.from(body);
        }

        // clear any previous error on success
        error.value = null;
        products.assignAll(items);
      } else {
        // log and show user-facing message for debugging
        final bodyStr = response.bodyString ?? '<empty body>';
        print('[ProductsController] non-200 ${response.statusCode} $bodyStr');
        Get.snackbar(
          'Products load failed',
          'Status: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );

        // Set error message so UI can display it
        error.value = 'Server error: ${response.statusCode}';

        // If server returned JSON with 'success' and data but non-200, try to parse items anyway
        if (response.body is Map) {
          final tentative = <dynamic>[];
          final b = response.body as Map;
          if (b['data'] is List)
            tentative.addAll(List<dynamic>.from(b['data']));
          else if (b['data'] is Map && b['data']['data'] is List)
            tentative.addAll(List<dynamic>.from(b['data']['data']));
          if (tentative.isNotEmpty) {
            products.assignAll(tentative);
            return;
          }
        }
        products.clear();
      }
    } catch (e) {
      // network or parsing error
      print('[ProductsController] fetch error: $e');
      products.clear();
      error.value = 'No internet or server unreachable';
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper to load next page when using pagination
  Future<void> loadMore() async {
    if (isLoading.value) return;
    if (page.value >= totalPages.value) return;

    final nextPage = page.value + 1;
    try {
      isLoading.value = true;
      var url = '${Endpoint.products}?page=$nextPage&limit=${limit.value}';
      final cid = currentCategoryId.value;
      final cs = currentSearch.value;
      if (cid != null && cid.isNotEmpty) url = '$url&categoryId=$cid';
      if (cs != null && cs.isNotEmpty)
        url = '$url&search=${Uri.encodeQueryComponent(cs)}';
      final response = await ApiClient.to.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        List<dynamic> items = [];

        if (body is Map) {
          if (body['data'] is List) {
            items = List<dynamic>.from(body['data']);
          } else if (body['data'] is Map && body['data']['data'] is List) {
            items = List<dynamic>.from(body['data']['data']);
          } else if (body['products'] is List) {
            items = List<dynamic>.from(body['products']);
          }
        } else if (body is List) {
          items = List<dynamic>.from(body);
        }

        if (items.isNotEmpty) products.addAll(items);

        // update pagination similar to fetchProducts
        Map? pagination;
        if (body is Map && body['pagination'] is Map) {
          pagination = Map<String, dynamic>.from(body['pagination']);
        } else if (body is Map &&
            body['data'] is Map &&
            body['data']['pagination'] is Map) {
          pagination = Map<String, dynamic>.from(body['data']['pagination']);
        }

        if (pagination != null) {
          page.value = (pagination['page'] is int)
              ? pagination['page']
              : page.value;
          limit.value = (pagination['limit'] is int)
              ? pagination['limit']
              : limit.value;
          total.value = (pagination['total'] is int)
              ? pagination['total']
              : total.value;
          totalPages.value = (pagination['totalPages'] is int)
              ? pagination['totalPages']
              : totalPages.value;
        }
      }
    } catch (_) {
      // ignore
    } finally {
      isLoading.value = false;
    }
  }
}
