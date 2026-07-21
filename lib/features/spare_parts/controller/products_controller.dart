// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class ProductsController extends GetxController {
  final products = <dynamic>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  // Pagination fields based on the API reference
  final page = 1.obs;
  final limit = 10.obs;
  final total = 0.obs;
  final totalPages = 1.obs;
  final RxnString currentCategoryId = RxnString();
  final RxnString currentSearch = RxnString();
  final RxnString currentStatus = RxnString('APPROVED');

  // New: error message to show on UI when network/server fails
  final RxnString error = RxnString();

  /// Whether there are more pages available to load
  bool get hasMore => page.value < totalPages.value;

  /// Fetch products from /products endpoint with pagination.
  /// Resets to page 1 and clears existing products list.
  Future<void> fetchProducts({
    int page = 1,
    int limit = 10,
    String? categoryId,
    String? category,
    String? search,
    String? status = 'APPROVED',
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      this.page.value = page;
      this.limit.value = limit;

      // remember current category, search & status for loadMore
      currentCategoryId.value = categoryId ?? category;
      currentSearch.value = search;
      currentStatus.value = status;

      var url = '${Endpoint.products}?page=$page&limit=$limit';
      if (status != null && status.isNotEmpty) {
        url = '$url&status=${Uri.encodeQueryComponent(status)}';
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        url = '$url&categoryId=$categoryId';
      }
      if (category != null && category.isNotEmpty) {
        url = '$url&category=${Uri.encodeQueryComponent(category)}';
      }
      if (search != null && search.isNotEmpty) {
        url = '$url&search=${Uri.encodeQueryComponent(search)}';
      }

      try {
        print('[ProductsController] GET $url');
      } catch (_) {}

      Response response = await ApiClient.to.get(url);

      if (!(response.statusCode == 200 || response.statusCode == 201) ||
          response.body == null) {
        final altUrl =
            '${Endpoint.baseUrl}${Endpoint.products}?page=$page&limit=$limit'
            '${status != null && status.isNotEmpty ? '&status=${Uri.encodeQueryComponent(status)}' : ''}'
            '${categoryId != null && categoryId.isNotEmpty ? '&categoryId=$categoryId' : ''}'
            '${category != null && category.isNotEmpty ? '&category=${Uri.encodeQueryComponent(category)}' : ''}'
            '${search != null && search.isNotEmpty ? '&search=${Uri.encodeQueryComponent(search)}' : ''}';
        try {
          print('[ProductsController] retry GET $altUrl');
          final retryResp = await ApiClient.to.get(altUrl);
          if (retryResp.statusCode == 200 || retryResp.statusCode == 201) {
            response = retryResp;
          }
        } catch (e) {
          print('[ProductsController] retry error: $e');
        }
      }

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
          } else if (body['items'] is List) {
            items = List<dynamic>.from(body['items']);
          } else if (body.values.any((v) => v is List)) {
            final lists = body.values.whereType<List>().toList();
            if (lists.isNotEmpty) {
              items = List<dynamic>.from(lists.first);
            }
          }

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
        } else if (body is List) {
          items = List<dynamic>.from(body);
        }

        error.value = null;
        products.assignAll(items);
      } else {
        error.value = '${'server_error'.tr}: ${response.statusCode}';
        products.clear();
      }
    } catch (e) {
      print('[ProductsController] fetch error: $e');
      products.clear();
      error.value = 'no_internet'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper to load next page using pagination without resetting existing products list
  Future<void> loadMore() async {
    if (isLoading.value || isLoadingMore.value) return;
    if (!hasMore) return;

    final nextPage = page.value + 1;
    try {
      isLoadingMore.value = true;
      var url = '${Endpoint.products}?page=$nextPage&limit=${limit.value}';
      final st = currentStatus.value;
      final cid = currentCategoryId.value;
      final cs = currentSearch.value;
      if (st != null && st.isNotEmpty) {
        url = '$url&status=${Uri.encodeQueryComponent(st)}';
      }
      if (cid != null && cid.isNotEmpty) url = '$url&categoryId=$cid';
      if (cs != null && cs.isNotEmpty) {
        url = '$url&search=${Uri.encodeQueryComponent(cs)}';
      }

      print('[ProductsController] loadMore GET $url');
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
          } else if (body['items'] is List) {
            items = List<dynamic>.from(body['items']);
          }
        } else if (body is List) {
          items = List<dynamic>.from(body);
        }

        if (items.isNotEmpty) {
          products.addAll(items);
        }

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
              : nextPage;
          limit.value = (pagination['limit'] is int)
              ? pagination['limit']
              : limit.value;
          total.value = (pagination['total'] is int)
              ? pagination['total']
              : total.value;
          totalPages.value = (pagination['totalPages'] is int)
              ? pagination['totalPages']
              : totalPages.value;
        } else {
          page.value = nextPage;
        }
      }
    } catch (e) {
      print('[ProductsController] loadMore error: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }
}
