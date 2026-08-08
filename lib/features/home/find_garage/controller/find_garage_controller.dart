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

  // Page Controller for slider carousel
  final PageController pageController = PageController(viewportFraction: 0.75);
  final RxDouble currentPage = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentPage.value = pageController.page ?? 0.0;
    });
    _initAndFetch();
  }

  @override
  void onClose() {
    pageController.dispose();
    searchController.dispose();
    super.onClose();
  }

  String? _currentEmirate;

  Future<void> _initAndFetch() async {
    String? emirate;
    String? serviceName;

    if (Get.arguments != null && Get.arguments is Map) {
      final Map args = Get.arguments;
      emirate = args['emirate']?.toString();
      serviceName = args['serviceName']?.toString();
      _currentEmirate = emirate;
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
    // 1. Try to fetch default location set in user profile (/user/me/profile)
    try {
      final profileRes = await ApiClient.to.get(Endpoint.profile);
      if (profileRes.statusCode == 200 && profileRes.body != null) {
        final data = profileRes.body is Map ? profileRes.body['data'] : null;
        if (data is Map) {
          final uLatRaw = data['userLat'];
          final uLngRaw = data['userLng'];
          if (uLatRaw != null && uLngRaw != null) {
            final double? pLat = double.tryParse(uLatRaw.toString());
            final double? pLng = double.tryParse(uLngRaw.toString());
            if (pLat != null && pLng != null && pLat != 0 && pLng != 0) {
              currentLat.value = pLat;
              currentLng.value = pLng;
              return; // Successfully set from user profile setting
            }
          }
        }
      }
    } catch (_) {}

    // 2. If profile location is null/empty, fall back to device GPS location
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

      final Map<String, Map<String, dynamic>> garageMap = {};

      // 1. Fetch nearby garages API if coordinates exist
      if (currentLat.value != null && currentLng.value != null) {
        final lat = currentLat.value!;
        final lng = currentLng.value!;
        final url = '${Endpoint.garageNearby}?lat=$lat&lng=$lng';
        final res = await ApiClient.to.get(url);
        if (res.statusCode == 200 && res.body != null) {
          final body = res.body;
          List<dynamic> nearbyList = [];
          if (body is Map) {
            if (body['garages'] is List) {
              nearbyList = List<dynamic>.from(body['garages']);
            } else if (body['data'] is List) {
              nearbyList = List<dynamic>.from(body['data']);
            } else if (body['data'] is Map && body['data']['data'] is List) {
              nearbyList = List<dynamic>.from(body['data']['data']);
            }
          } else if (body is List) {
            nearbyList = List<dynamic>.from(body);
          }
          for (var item in nearbyList) {
            if (item is Map && item['id'] != null) {
              garageMap[item['id'].toString()] = Map<String, dynamic>.from(item);
            }
          }
        }
      }

      // 2. Fetch all approved garages endpoint
      String url = '${Endpoint.allApprovedGarage}&limit=100';
      if (emirate != null && emirate.isNotEmpty) {
        url += '&emirate=${Uri.encodeComponent(emirate)}';
      }
      if (serviceName != null && serviceName.isNotEmpty && serviceName != 'All') {
        url += '&serviceName=${Uri.encodeComponent(serviceName)}';
      }
      if (currentLat.value != null && currentLng.value != null) {
        url += '&userLat=${currentLat.value}&userLng=${currentLng.value}';
      }
      final res = await ApiClient.to.get(url);
      if (res.statusCode == 200 && res.body != null) {
        final body = res.body;
        List<dynamic> approvedList = [];
        if (body is Map) {
          if (body['data'] is Map && body['data']['data'] is List) {
            approvedList = List<dynamic>.from(body['data']['data']);
          } else if (body['data'] is List) {
            approvedList = List<dynamic>.from(body['data']);
          } else if (body['garages'] is List) {
            approvedList = List<dynamic>.from(body['garages']);
          }
        } else if (body is List) {
          approvedList = List<dynamic>.from(body);
        }
        for (var item in approvedList) {
          if (item is Map && item['id'] != null) {
            garageMap[item['id'].toString()] = Map<String, dynamic>.from(item);
          }
        }
      }

      final models = garageMap.values
          .map((e) => GarageModel.fromJson(e))
          .toList();

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
    fetchGarages(emirate: _currentEmirate, serviceName: filterName);
  }
}
