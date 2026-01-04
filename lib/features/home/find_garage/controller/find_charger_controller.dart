// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/endpoint/endpoint.dart';
import '../../../service/service_booking/model/garage_detail_model.dart';

class FindChargerController extends GetxController {
  final searchController = TextEditingController();

  var selectedItem = ''.obs;
  var isDropdownVisible = false.obs;
  final List<String> items = ['Garage Services', 'Towing Service'];

  // Garages loaded from /garages?emirate=...&serviceName=...
  var garages = <GarageDetailModel>[].obs;

  // Default images shown when no garages available or garage has no image
  final List<String> _defaultImages = [
    "https://innovativeconcretecoatings.com/wp-content/uploads/2022/04/garage-interior-modern-1024x555.jpg",
    "https://innovativeconcretecoatings.com/wp-content/uploads/2022/04/garage-interior-modern-1024x555.jpg",
    "https://innovativeconcretecoatings.com/wp-content/uploads/2022/04/garage-interior-modern-1024x555.jpg",
  ];

  /// Image list used by the slider widget. If garages are loaded, prefer their
  /// coverPhoto/profileImage; otherwise return the default images.
  List<String> get images {
    if (garages.isNotEmpty) {
      return garages
          .map((g) {
            if (g.coverPhoto.isNotEmpty) return g.coverPhoto;
            if (g.profileImage.isNotEmpty) return g.profileImage;
            return _defaultImages.first;
          })
          .toList(growable: false);
    }
    return _defaultImages;
  }

  // Page controller for horizontal list (optional)
  final PageController pageController = PageController(viewportFraction: 0.6);
  var currentPage = 0.0.obs;

  // User current location for map centering
  final currentLat = Rxn<double>();
  final currentLng = Rxn<double>();
  var isLoadingLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentPage.value = pageController.page ?? 0.0;
    });

    // If arguments passed via Get.arguments, fetch garages
    final args = Get.arguments as Map<String, dynamic>?;
    final emirate = args != null ? args['emirate'] as String? : null;
    final serviceName = args != null ? args['serviceName'] as String? : null;
    fetchGarages(emirate: emirate, serviceName: serviceName);

    // load user's current location for map
    loadCurrentLocation();
  }

  @override
  void onClose() {
    pageController.dispose();
    searchController.dispose();
    super.onClose();
  }

  /// Loads the user's current GPS location and stores it in
  /// `currentLat` / `currentLng`. Public so widgets can trigger
  /// a refresh each time the screen appears.
  Future<void> loadCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied) {
          isLoadingLocation.value = false;
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        isLoadingLocation.value = false;
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      currentLat.value = pos.latitude;
      currentLng.value = pos.longitude;
    } catch (e) {
      print('Failed to get current location: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Fetch garages filtered by emirate and serviceName
  Future<void> fetchGarages({String? emirate, String? serviceName}) async {
    try {
      String url = Endpoint.findGarage;
      final params = <String, String>{};
      if (emirate != null && emirate.isNotEmpty) params['emirate'] = emirate;
      if (serviceName != null && serviceName.isNotEmpty) {
        params['serviceName'] = serviceName;
      }
      if (params.isNotEmpty) {
        final query = params.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        url = '$url?$query';
      }

      final res = await ApiClient.to.get(url);
      if (res.statusCode == 200 && res.body != null) {
        final body = res.body as Map<String, dynamic>;
        final data = body['data'];
        List<dynamic> list = [];
        if (data is Map && data['data'] is List) {
          list = List<dynamic>.from(data['data']);
        } else if (body['data'] is List) {
          list = List<dynamic>.from(body['data']);
        } else if (body['garages'] is List) {
          list = List<dynamic>.from(body['garages']);
        }

        garages.value = list
            .where((e) => e != null && e is Map<String, dynamic>)
            .map(
              (e) => GarageDetailModel.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList(growable: false);
      } else {
        EasyLoading.showError('Failed to load garages');
        garages.clear();
      }
    } catch (e, st) {
      print('Error fetching garages: $e');
      print(st);
      EasyLoading.showError('Failed to load garages');
      garages.clear();
    }
  }
}
