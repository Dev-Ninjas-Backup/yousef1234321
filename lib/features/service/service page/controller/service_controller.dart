import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/endpoint/endpoint.dart';
import '../model/garage_model.dart';

class ServiceController extends GetxController {
  final searchController = TextEditingController();
  var serviceItemList = [].obs;

  var selectedOption = RxString('');
  var garages = <GarageModel>[].obs;
  var isLoadingNearby = false.obs;

  /// Loading state for fetching the saved profile location only
  var isLoadingLocation = false.obs;

  /// The saved profile latitude/lng loaded by tapping the location icon
  final profileLat = Rxn<double>();
  final profileLng = Rxn<double>();
  var hasProfileLocation = false.obs;

  final List<String> options = ["Garage Services ", "Towing Service "];

  void changeOption(String value) {
    selectedOption.value = value;
  }

  @override
  void onInit() {
    serviceItem();
    super.onInit();
  }

  void serviceItem() {
    serviceItemList.addAll([]);
  }

  /// Find garages using the user's saved profile location (radius fixed to 10 km).
  /// If a name query is provided in [searchController], the results are filtered by name.
  Future<void> findGaragesNearbyFromProfile() async {
    try {
      isLoadingNearby.value = true;
      // Preconditions: either a loaded profile location exists or user typed a name
      final query = searchController.text.trim();
      if (!hasProfileLocation.value && query.isEmpty) {
        EasyLoading.showError(
          'Please load location first or enter a garage name',
        );
        return;
      }

      // Build URL depending on whether we have profile coords or only a name query
      String url;
      if (hasProfileLocation.value &&
          profileLat.value != null &&
          profileLng.value != null) {
        final lat = profileLat.value!;
        final lng = profileLng.value!;
        url = '${Endpoint.garageNearby}?lat=$lat&lng=$lng&radius=10';
        // If user also typed a query, include it for server-side filtering if supported
        if (query.isNotEmpty) {
          url += '&name=${Uri.encodeQueryComponent(query)}';
        }
      } else {
        // No profile location but user typed a name — attempt server-side name search
        // NOTE: this assumes the /garages/nearby endpoint supports a 'name' query parameter
        url =
            '${Endpoint.garageNearby}?name=${Uri.encodeQueryComponent(query)}';
      }

      final res = await ApiClient.to.get(url);
      if (res.statusCode == 200 && res.body != null) {
        final body = res.body;
        List<dynamic> list = [];

        // Accept multiple response shapes: {garages: [...]}, {data: [...]}, {data: {data: [...]}}
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

        // Map to typed models and filter invalid entries
        final models = list
            .where((e) => e != null && e is Map<String, dynamic>)
            .map((e) => GarageModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(growable: false);

        // If user entered a search query, filter by garage name
        final queryLower = searchController.text.trim().toLowerCase();
        final filtered = queryLower.isNotEmpty
            ? models
                  .where((m) => m.name.toLowerCase().contains(queryLower))
                  .toList()
            : models;

        garages.value = filtered;
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

  /// Fetches the saved profile location (userLat/userLng) and stores it locally.
  /// This method only loads the location and does NOT call the nearby garages API.
  Future<void> loadProfileLocation() async {
    try {
      isLoadingLocation.value = true;
      final profileRes = await ApiClient.to.get(Endpoint.profile);
      if (profileRes.statusCode != 200 || profileRes.body == null) {
        EasyLoading.showError('Unable to load profile');
        hasProfileLocation.value = false;
        return;
      }

      final data = profileRes.body['data'] as Map<String, dynamic>?;
      if (data == null) {
        EasyLoading.showError('Profile data not found');
        hasProfileLocation.value = false;
        return;
      }

      final latRaw = data['userLat'];
      final lngRaw = data['userLng'];
      final lat = (latRaw is num)
          ? latRaw.toDouble()
          : double.tryParse(latRaw?.toString() ?? '');
      final lng = (lngRaw is num)
          ? lngRaw.toDouble()
          : double.tryParse(lngRaw?.toString() ?? '');

      if (lat == null || lng == null) {
        EasyLoading.showInfo(
          'No saved location found. Please set a default location.',
        );
        hasProfileLocation.value = false;
        profileLat.value = null;
        profileLng.value = null;
        return;
      }

      profileLat.value = lat;
      profileLng.value = lng;
      hasProfileLocation.value = true;
      EasyLoading.showSuccess('Location loaded');
    } catch (e, st) {
      print('Error loading profile location: $e');
      print(st);
      EasyLoading.showError('Failed to load profile location');
      hasProfileLocation.value = false;
    } finally {
      isLoadingLocation.value = false;
    }
  }
}
