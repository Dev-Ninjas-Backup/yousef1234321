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

  /// Fetch products from /products endpoint with pagination.
  /// Only page & limit are sent as query params.
  Future<void> fetchProducts({int page = 1, int limit = 10}) async {
    try {
      isLoading.value = true;

      final url = '${Endpoint.products}?page=$page&limit=$limit';
      final response = await ApiClient.to.get(url);

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

        products.assignAll(items);
      } else {
        products.clear();
      }
    } catch (e) {
      products.clear();
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
      final url = '${Endpoint.products}?page=$nextPage&limit=${limit.value}';
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
