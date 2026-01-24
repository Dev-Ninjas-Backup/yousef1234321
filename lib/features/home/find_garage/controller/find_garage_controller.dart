import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindGarageController extends GetxController {
  // Observables for location
  final Rxn<double> currentLat = Rxn<double>();
  final Rxn<double> currentLng = Rxn<double>();

  // Dropdown & Filter logic
  final RxBool isDropdownVisible = false.obs;
  final RxList<String> items = <String>['All', 'Repair', 'Wash', 'Service'].obs;
  final RxString selectedItem = 'All'.obs;

  // Search
  final TextEditingController searchController = TextEditingController();

  // Garage Data
  final RxList<GarageModel> garages = <GarageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentLocation();
    fetchGarages();
  }

  void loadCurrentLocation() {
    // Mock location (Dubai)
    // In a real app, use Geolocator.getCurrentPosition()
    currentLat.value = 25.2048;
    currentLng.value = 55.2708;
  }

  void fetchGarages() {
    // Mock data - Replace with actual API call
    garages.value = [
      GarageModel(
        id: '1',
        name: 'Dubai Auto Care',
        garageLat: 25.2100,
        garageLng: 55.2800,
        coverPhoto:
            'https://images.pexels.com/photos/4489749/pexels-photo-4489749.jpeg',
        profileImage:
            'https://images.pexels.com/photos/4489749/pexels-photo-4489749.jpeg',
      ),
      GarageModel(
        id: '2',
        name: 'Quick Fix Garage',
        garageLat: 25.1900,
        garageLng: 55.2600,
        coverPhoto:
            'https://images.pexels.com/photos/2244746/pexels-photo-2244746.jpeg',
        profileImage:
            'https://images.pexels.com/photos/2244746/pexels-photo-2244746.jpeg',
      ),
    ];
  }
}

class GarageModel {
  final String id;
  final String name;
  final double garageLat;
  final double garageLng;
  final String coverPhoto;
  final String profileImage;

  GarageModel({
    required this.id,
    required this.name,
    required this.garageLat,
    required this.garageLng,
    required this.coverPhoto,
    required this.profileImage,
  });
}
