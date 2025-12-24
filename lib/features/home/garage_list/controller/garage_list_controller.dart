import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/home/home_page/model/garage_model.dart';

class GarageListController extends GetxController {
  final searchController = TextEditingController();
  final garages = <GarageModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  // Filter observables
  final selectedCity = RxnString();
  final selectedEmirate = RxnString();
  final selectedService = RxnString();
  final selectedStatus = 'ALL'.obs; // Default to ALL

  // Pagination
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final limit = 10;

  final ScrollController scrollController = ScrollController();

  final cities = [
    "Abu Dhabi",
    "Dubai",
    "Sharjah",
    "Ajman",
    "Fujairah",
    "Ras Al Khaimah",
    "Umm Al Quwain",
  ];

  final emirates = [
    "Abu Dhabi",
    "Dubai",
    "Sharjah",
    "Ajman",
    "Fujairah",
    "Ras Al Khaimah",
    "Umm Al Quwain",
  ];

  final serviceTypes = <String>[].obs;

  final statuses = ['APPROVED', 'PENDING', 'REJECTED'];

  @override
  void onInit() {
    super.onInit();
    fetchGarages();
    fetchServices();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (currentPage.value < totalPages.value && !isLoadingMore.value) {
        loadMore();
      }
    }
  }

  Future<void> fetchServices() async {
    try {
      final response = await ApiClient.to.get(Endpoint.getService);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null && body['serviceCategories'] != null) {
          final List<dynamic> categories = body['serviceCategories'];
          serviceTypes.value = categories.map((e) => e.toString()).toList();
        }
      }
    } catch (e) {
      print('Failed to fetch services: $e');
    }
  }

  Future<void> fetchGarages({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage.value = 1;
      }

      isLoading.value = true;

      // Build query parameters
      final queryParams = <String, dynamic>{
        'page': currentPage.value,
        'limit': limit,
      };

      // Only add status if not "ALL"
      if (selectedStatus.value != 'ALL') {
        queryParams['status'] = selectedStatus.value;
      }

      if (searchController.text.isNotEmpty) {
        queryParams['search'] = searchController.text.trim();
      }
      if (selectedCity.value != null) {
        queryParams['city'] = selectedCity.value;
      }
      if (selectedEmirate.value != null) {
        queryParams['emirate'] = selectedEmirate.value;
      }
      if (selectedService.value != null) {
        queryParams['serviceName'] = selectedService.value;
      }

      // Convert to query string
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');

      final url = '${Endpoint.findGarage}?$queryString';
      final response = await ApiClient.to.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null &&
            body['success'] == true &&
            body['data'] != null &&
            body['data']['data'] != null) {
          final List<dynamic> garagesJson = body['data']['data'];
          final newGarages = garagesJson
              .map((json) => GarageModel.fromJson(json))
              .toList();

          if (isRefresh) {
            garages.value = newGarages;
          } else {
            garages.value = newGarages;
          }

          // Update pagination info
          final pagination = body['data']['pagination'];
          totalPages.value = pagination['totalPages'] ?? 1;
        }
      }
    } catch (e) {
      print('Failed to fetch garages: $e');
      Get.snackbar(
        'Error',
        'Failed to load garages',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || currentPage.value >= totalPages.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      // Build query parameters
      final queryParams = <String, dynamic>{
        'page': currentPage.value,
        'limit': limit,
      };

      // Only add status if not "ALL"

      if (searchController.text.isNotEmpty) {
        queryParams['search'] = searchController.text.trim();
      }
      if (selectedCity.value != null) {
        queryParams['city'] = selectedCity.value;
      }
      if (selectedEmirate.value != null) {
        queryParams['emirate'] = selectedEmirate.value;
      }
      if (selectedService.value != null) {
        queryParams['serviceName'] = selectedService.value;
      }

      // Convert to query string
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');

      final url = '${Endpoint.findGarage}?$queryString';
      final response = await ApiClient.to.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null &&
            body['success'] == true &&
            body['data'] != null &&
            body['data']['data'] != null) {
          final List<dynamic> garagesJson = body['data']['data'];
          final newGarages = garagesJson
              .map((json) => GarageModel.fromJson(json))
              .toList();

          garages.addAll(newGarages);
        }
      }
    } catch (e) {
      print('Failed to load more garages: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void applyFilters() {
    currentPage.value = 1;
    fetchGarages(isRefresh: true);
  }

  void clearFilters() {
    searchController.clear();
    selectedCity.value = null;
    selectedEmirate.value = null;
    selectedService.value = null;
    selectedStatus.value = 'ALL';
    applyFilters();
  }

  void onSearch(String value) {
    // Debounce search
    Future.delayed(const Duration(milliseconds: 500), () {
      if (searchController.text == value) {
        applyFilters();
      }
    });
  }
}
