// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/endpoint/endpoint.dart';
import '../model/garage_model.dart';

class ServiceController extends GetxController {
  final radiusController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  var serviceItemList = [].obs;

  var selectedOption = RxString('');
  var garages = <GarageModel>[].obs;
  var isLoadingNearby = false.obs;

  /// Loading state for fetching current location
  var isLoadingLocation = false.obs;

  /// The current location latitude/lng fetched by tapping the location icon
  final currentLat = Rxn<double>();
  final currentLng = Rxn<double>();
  var hasCurrentLocation = false.obs;

  // Pagination & Mode fields
  var isNearbyMode = false.obs;
  var page = 1.obs;
  var totalPages = 1.obs;
  var limit = 10.obs;
  var total = 0.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;

  final List<String> options = ["Garage Services ", "Towing Service "];

  void changeOption(String value) {
    selectedOption.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    serviceItem();
    scrollController.addListener(_onScroll);
    fetchApprovedGarages(refresh: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    radiusController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && hasMore.value && !isNearbyMode.value && !isLoadingNearby.value) {
        loadMoreApprovedGarages();
      }
    }
  }

  void serviceItem() {
    serviceItemList.addAll([]);
  }

  /// Fetch approved garages from /garages?status=APPROVED with pagination.
  Future<void> fetchApprovedGarages({bool refresh = true}) async {
    if (refresh) {
      page.value = 1;
      hasMore.value = true;
      isLoadingNearby.value = true;
    }

    try {
      final url = '${Endpoint.allApprovedGarage}&page=${page.value}&limit=${limit.value}';
      final res = await ApiClient.to.get(url);

      if (res.statusCode == 200 && res.body != null) {
        final body = res.body;
        List<dynamic> list = [];
        Map? pagination;

        if (body is Map) {
          if (body['data'] is Map) {
            final dataMap = body['data'];
            if (dataMap['data'] is List) {
              list = List<dynamic>.from(dataMap['data']);
            }
            if (dataMap['pagination'] is Map) {
              pagination = Map<String, dynamic>.from(dataMap['pagination']);
            }
          } else if (body['data'] is List) {
            list = List<dynamic>.from(body['data']);
          }

          if (body['pagination'] is Map) {
            pagination = Map<String, dynamic>.from(body['pagination']);
          }
        }

        final models = list
            .where((e) => e != null && e is Map<String, dynamic>)
            .map((e) => GarageModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        if (refresh) {
          garages.assignAll(models);
        } else {
          garages.addAll(models);
        }

        if (pagination != null) {
          page.value = (pagination['page'] is int) ? pagination['page'] : page.value;
          limit.value = (pagination['limit'] is int) ? pagination['limit'] : limit.value;
          total.value = (pagination['total'] is int) ? pagination['total'] : total.value;
          final totalPagesVal = (pagination['totalPages'] is int) ? pagination['totalPages'] : 1;
          totalPages.value = totalPagesVal;
          if (page.value >= totalPagesVal) {
            hasMore.value = false;
          }
        } else {
          if (models.length < limit.value) {
            hasMore.value = false;
          }
        }
      } else {
        if (refresh) {
          garages.clear();
        }
        EasyLoading.showError('Failed to load approved garages');
      }
    } catch (e, st) {
      print('Error fetching approved garages: $e');
      print(st);
      if (refresh) {
        garages.clear();
      }
      EasyLoading.showError('Failed to fetch approved garages');
    } finally {
      isLoadingNearby.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreApprovedGarages() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    page.value++;
    await fetchApprovedGarages(refresh: false);
  }

  void resetToApprovedGarages() {
    isNearbyMode.value = false;
    fetchApprovedGarages(refresh: true);
  }

  Future<void> findGaragesNearby() async {
    try {
      // Precondition: must have current location loaded
      if (!hasCurrentLocation.value ||
          currentLat.value == null ||
          currentLng.value == null) {
        EasyLoading.showError('Please load your location first');
        return;
      }

      isLoadingNearby.value = true;
      isNearbyMode.value = true;

      // Get radius from input (default to 10 if empty)
      final radiusText = radiusController.text.trim();
      final radius = double.tryParse(radiusText) ?? 10.0;

      final lat = currentLat.value!;
      final lng = currentLng.value!;
      final url = '${Endpoint.garageNearby}?lat=$lat&lng=$lng&radius=$radius';

      final res = await ApiClient.to.get(url);
      if (res.statusCode == 200 && res.body != null) {
        final body = res.body;
        List<dynamic> list = [];

        // Accept multiple response shapes: {garages: [...]}, {data: [...]}, etc.
        if (body is Map) {
          if (body['garages'] is List) {
            list = List<dynamic>.from(body['garages']);
          } else if (body['data'] is List) {
            list = List<dynamic>.from(body['data']);
          } else if (body['data'] is Map && body['data']['data'] is List) {
            list = List<dynamic>.from(body['data']['data']);
          } else if (body.values.any((v) => v is List)) {
            final lists = body.values.whereType<List>().toList();
            if (lists.isNotEmpty) list = List<dynamic>.from(lists.first);
          }
        } else if (body is List) {
          list = List<dynamic>.from(body);
        }

        if (list.isEmpty) {
          EasyLoading.showError('No garages found');
          garages.clear();
          return;
        }

        // Map to typed models
        final models = list
            .where((e) => e != null && e is Map<String, dynamic>)
            .map((e) => GarageModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        garages.assignAll(models);
      } else {
        EasyLoading.showError('Failed to load nearby garages');
        garages.clear();
      }
    } catch (e, st) {
      print('Error fetching nearby garages: $e');
      print(st);
      EasyLoading.showError('Failed to fetch nearby garages');
    } finally {
      isLoadingNearby.value = false;
    }
  }

  /// Fetches the user's current location via GPS and stores it locally.
  /// This method does NOT call the nearby garages API.
  Future<void> loadCurrentLocation() async {
    try {
      isLoadingLocation.value = true;
      EasyLoading.show(status: 'Loading location...');

      // Import geolocator if not already done
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied) {
          EasyLoading.showError('Location permission denied');
          hasCurrentLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        EasyLoading.showError(
          'Location permission permanently denied. Enable in settings.',
        );
        await Geolocator.openAppSettings();
        hasCurrentLocation.value = false;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat.value = position.latitude;
      currentLng.value = position.longitude;
      hasCurrentLocation.value = true;
      EasyLoading.showSuccess('Location loaded');
    } catch (e, st) {
      print('Error loading current location: $e');
      print(st);
      EasyLoading.showError('Failed to load location');
      hasCurrentLocation.value = false;
    } finally {
      isLoadingLocation.value = false;
    }
  }
}
