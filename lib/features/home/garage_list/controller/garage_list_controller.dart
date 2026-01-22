import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/home/home_page/model/garage_model.dart';
import 'package:yousef1234321/features/profile/language/controller/language_controller.dart';

class GarageListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var garages = <GarageModel>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  // Filters
  var selectedCity = RxnString();
  var selectedEmirate = RxnString();
  var selectedService = RxnString();
  var selectedStatus = 'APPROVED'.obs;

  final statuses = ['APPROVED', 'PENDING', 'REJECTED'];
  final cities = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ajman',
    'Umm Al Quwain',
    'Ras Al Khaimah',
    'Fujairah',
  ];
  final emirates = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ajman',
    'Umm Al Quwain',
    'Ras Al Khaimah',
    'Fujairah',
  ];
  final serviceTypes = <String>[].obs;

  int page = 1;
  final int limit = 10;
  bool hasMore = true;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchGarages();
    fetchServices();
    scrollController.addListener(_onScroll);

    // Refresh data automatically when language changes
    if (Get.isRegistered<LanguageController>()) {
      ever(Get.find<LanguageController>().selectedLanguage, (_) {
        fetchGarages(refresh: true);
      });
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && hasMore) {
        loadMore();
      }
    }
  }

  Future<void> fetchGarages({bool refresh = true}) async {
    if (refresh) {
      isLoading.value = true;
      page = 1;
      hasMore = true;
      garages.clear();
    }

    try {
      String url = '${Endpoint.findGarage}?page=$page&limit=$limit';

      if (searchController.text.isNotEmpty) {
        url += '&searchTerm=${Uri.encodeQueryComponent(searchController.text)}';
      }

      if (selectedStatus.value.isNotEmpty && selectedStatus.value != 'All') {
        url += '&status=${selectedStatus.value}';
      }

      if (selectedCity.value != null)
        url += '&city=${Uri.encodeQueryComponent(selectedCity.value!)}';
      if (selectedEmirate.value != null)
        url += '&emirate=${Uri.encodeQueryComponent(selectedEmirate.value!)}';
      if (selectedService.value != null)
        url += '&service=${Uri.encodeQueryComponent(selectedService.value!)}';

      final response = await ApiClient.to.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body['success'] == true && body['data'] != null) {
          final data = body['data'];
          List<dynamic> list = [];

          if (data is Map && data['data'] is List) {
            list = data['data'];
            if (data['pagination'] != null) {
              final totalPages = data['pagination']['totalPages'] ?? 1;
              if (page >= totalPages) hasMore = false;
            }
          } else if (data is List) {
            list = data;
            if (list.length < limit) hasMore = false;
          }

          final newGarages = list.map((e) => GarageModel.fromJson(e)).toList();

          if (refresh) {
            garages.assignAll(newGarages);
          } else {
            garages.addAll(newGarages);
          }
        }
      }
    } catch (e) {
      print('Error fetching garages: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) return;
    isLoadingMore.value = true;
    page++;
    await fetchGarages(refresh: false);
  }

  void onSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchGarages(refresh: true);
    });
  }

  void applyFilters() {
    fetchGarages(refresh: true);
  }

  void clearFilters() {
    searchController.clear();
    selectedCity.value = null;
    selectedEmirate.value = null;
    selectedService.value = null;
    selectedStatus.value = 'APPROVED';
    fetchGarages(refresh: true);
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
      print(e);
    }
  }
}
