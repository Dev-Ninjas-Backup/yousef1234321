import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/features/home/home_page/model/garage_model.dart';
import 'package:yousef1234321/features/profile/language/controller/language_controller.dart';
import 'package:yousef1234321/features/home/garage_list/service/garage_list_service.dart';

class GarageListController extends GetxController {
  final GarageListService _garageListService;

  GarageListController(this._garageListService);

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  var garages = <GarageModel>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  // Filters
  var selectedCity = RxnString();
  var selectedEmirate = RxnString();
  var selectedService = RxnString();
  var selectedStatus = 'approved'.obs;

  final cities = [
    'abu_dhabi',
    'al_ain',
    'dubai',
    'sharjah',
    'ajman',
    'umm_al_quwain',
    'ras_al_khaimah',
    'fujairah',
  ];
  final emirates = [
    'abu_dhabi',
    'dubai',
    'sharjah',
    'ajman',
    'umm_al_quwain',
    'ras_al_khaimah',
    'fujairah',
  ];
  final serviceTypes = <String>[].obs;

  // Map keys back to API values
  final Map<String, String> _apiValues = {
    'all': 'All',
    'approved': 'APPROVED',
    'pending': 'PENDING',
    'rejected': 'REJECTED',
    'abu_dhabi': 'Abu Dhabi',
    'al_ain': 'Al Ain',
    'dubai': 'Dubai',
    'sharjah': 'Sharjah',
    'ajman': 'Ajman',
    'umm_al_quwain': 'Umm Al Quwain',
    'ras_al_khaimah': 'Ras Al Khaimah',
    'fujairah': 'Fujairah',
  };

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
      final statusVal =
          selectedStatus.value.isNotEmpty && selectedStatus.value != 'all'
          ? (_apiValues[selectedStatus.value] ?? selectedStatus.value)
          : null;

      final cityVal = selectedCity.value != null
          ? (_apiValues[selectedCity.value!] ?? selectedCity.value!)
          : null;

      final emirateVal = selectedEmirate.value != null
          ? (_apiValues[selectedEmirate.value!] ?? selectedEmirate.value!)
          : null;

      final response = await _garageListService.fetchGarages(
        page: page,
        limit: limit,
        searchTerm: searchController.text,
        status: statusVal,
        city: cityVal,
        emirate: emirateVal,
        serviceName: selectedService.value,
      );

      final List<GarageModel> parsedGarages = response['garages'];
      hasMore = response['hasMore'];

      if (refresh) {
        garages.assignAll(parsedGarages);
      } else {
        garages.addAll(parsedGarages);
      }
    } catch (e) {
      print('[GarageListController] fetchGarages error: $e');
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
    selectedStatus.value = 'approved';
    fetchGarages(refresh: true);
  }

  Future<void> fetchServices() async {
    try {
      final fetchedServices = await _garageListService.fetchServices();
      serviceTypes.assignAll(fetchedServices);
    } catch (e) {
      print('[GarageListController] fetchServices error: $e');
    }
  }
}
