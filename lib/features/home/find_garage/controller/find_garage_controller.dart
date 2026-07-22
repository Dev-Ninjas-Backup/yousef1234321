import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../service/service page/model/garage_model.dart';
import 'package:yousef1234321/features/home/find_garage/service/find_garage_service.dart';

class FindGarageController extends GetxController {
  final FindGarageService _findGarageService;

  FindGarageController(this._findGarageService);

  // Observables for location
  final Rxn<double> currentLat = Rxn<double>();
  final Rxn<double> currentLng = Rxn<double>();

  // Filter dropdown logic
  final RxBool isDropdownVisible = false.obs;
  final RxList<String> items = <String>['All'].obs;
  final RxString selectedItem = 'All'.obs;

  // Search
  final TextEditingController searchController = TextEditingController();

  // Garage Data
  final RxList<GarageModel> garages = <GarageModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initAndFetch();
  }

  Future<void> _initAndFetch() async {
    String? emirate;
    String? serviceName;

    if (Get.arguments != null && Get.arguments is Map) {
      final Map args = Get.arguments;
      emirate = args['emirate']?.toString();
      serviceName = args['serviceName']?.toString();
      if (args['currentLat'] != null) {
        currentLat.value = (args['currentLat'] as num).toDouble();
      }
      if (args['currentLng'] != null) {
        currentLng.value = (args['currentLng'] as num).toDouble();
      }
    }

    if (serviceName != null && serviceName.isNotEmpty) {
      selectedItem.value = serviceName;
    }

    await fetchServiceCategories();

    if (currentLat.value == null || currentLng.value == null) {
      await loadCurrentLocation();
    }

    await fetchGarages(emirate: emirate, serviceName: serviceName);
  }

  Future<void> fetchServiceCategories() async {
    try {
      final fetchedCategories = await _findGarageService
          .fetchServiceCategories();
      if (fetchedCategories.isNotEmpty) {
        items.assignAll(['All', ...fetchedCategories]);
      }
    } catch (_) {}
  }

  Future<void> loadCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        currentLat.value = pos.latitude;
        currentLng.value = pos.longitude;
      }
    } catch (e) {
      // Location unavailable or permission denied; leave values null
    }
  }

  Future<void> fetchGarages({String? emirate, String? serviceName}) async {
    try {
      isLoading.value = true;
      EasyLoading.show(status: 'loading'.tr);

      final models = await _findGarageService.fetchGarages(
        emirate: emirate,
        serviceName: serviceName,
        currentLat: currentLat.value,
        currentLng: currentLng.value,
      );

      garages.assignAll(models);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching garages: $e');
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }

  void selectCategory(String category) {
    selectedItem.value = category;
    isDropdownVisible.value = false;
    final filterName = category == 'All' ? null : category;
    fetchGarages(serviceName: filterName);
  }
}
