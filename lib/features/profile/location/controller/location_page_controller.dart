// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/secrets/google_map_api_key.dart';

class LocationPageController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  // Map state
  // Use a Completer to follow the google_maps_flutter example and ensure
  // we await the controller before calling camera operations.
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final initialCameraPosition = const CameraPosition(
    target: LatLng(25.2048, 55.2708), // default to Dubai
    zoom: 12,
  );
  CameraPosition? _pendingCamera;

  final Rx<LatLng?> selectedLatLng = Rxn<LatLng>();
  final RxString resolvedAddress = ''.obs;
  final RxBool isSaving = false.obs;
  final RxBool isLoadingProfile = false.obs;

  /// Get Geocoding API key
  String _getGeocodingApiKey() {
    return GoogleMapApiKey.geocodingApiKey;
  }

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocationFromProfile();
  }

  /// Check if a LatLng coordinate is valid (within acceptable ranges)
  bool _isValidCoordinate(double lat, double lng) {
    return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
  }

  Future<void> _loadSavedLocationFromProfile() async {
    try {
      isLoadingProfile.value = true;
      final res = await ApiClient.to.get(Endpoint.profile);
      if (res.statusCode == 200 &&
          res.body is Map &&
          res.body['data'] != null) {
        final data = res.body['data'] as Map<String, dynamic>;
        final lat = data['userLat'];
        final lng = data['userLng'];
        if (lat != null && lng != null) {
          final parsedLat = (lat is num)
              ? lat.toDouble()
              : double.tryParse(lat.toString());
          final parsedLng = (lng is num)
              ? lng.toDouble()
              : double.tryParse(lng.toString());
          if (parsedLat != null &&
              parsedLng != null &&
              _isValidCoordinate(parsedLat, parsedLng)) {
            selectedLatLng.value = LatLng(parsedLat, parsedLng);
            // populate address for saved coordinates
            await reverseGeocode(selectedLatLng.value!);
            // move camera if map is ready (or set pending)
            if (_mapController.isCompleted) {
              final ctrl = await _mapController.future;
              ctrl.animateCamera(
                CameraUpdate.newLatLngZoom(selectedLatLng.value!, 15),
              );
            } else {
              _pendingCamera = CameraPosition(
                target: selectedLatLng.value!,
                zoom: 15,
              );
            }
          } else {
            print(
              'Invalid coordinates from profile: lat=$parsedLat, lng=$parsedLng',
            );
            // Don't set selectedLatLng - let it remain null so map uses hardcoded default
          }
        }
      }
    } catch (e, st) {
      print('Failed to load profile location: $e');
      print(st);
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Move camera when GoogleMapController becomes available
  void onMapCreated(GoogleMapController controller) {
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
    }

    if (selectedLatLng.value != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLatLng.value!, 15),
      );
    } else if (_pendingCamera != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(_pendingCamera!));
      _pendingCamera = null;
    }
  }

  /// When user taps on map
  void onMapTap(LatLng latLng) {
    selectedLatLng.value = latLng;
    // reverse geocode tapped location
    reverseGeocode(latLng);
  }

  /// User moves map around - we can update a temporary center if desired
  void onCameraMove(CameraPosition position) {
    // Intentionally left simple: update a preview marker at center
    selectedLatLng.value = position.target;
  }

  /// Use device GPS to get current location and move camera
  Future<void> setCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied) {
          EasyLoading.showError('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are permanently denied, open app settings
        EasyLoading.showError(
          'Location permission permanently denied. Please enable it from settings.',
        );
        await Geolocator.openAppSettings();
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      selectedLatLng.value = latLng;
      // reverse geocode current location
      await reverseGeocode(latLng);
      if (_mapController.isCompleted) {
        final ctrl = await _mapController.future;
        await ctrl.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
      } else {
        _pendingCamera = CameraPosition(target: latLng, zoom: 15);
      }
    } catch (e, st) {
      print('Error getting current location: $e');
      print(st);
      EasyLoading.showError('Unable to get current location');
    }
  }

  /// Search location by text using Google Geocoding API
  Future<void> searchLocationByText() async {
    final query = searchController.text.trim();
    if (query.isEmpty) return;
    try {
      EasyLoading.show(status: 'Searching location...');
      final apiKey = _getGeocodingApiKey();
      print('Using Geocoding API Key: $apiKey');
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(query)}&key=$apiKey',
      );
      print('Geocoding URL: $url');
      final res = await http.get(url);
      print('Geocoding Response Status: ${res.statusCode}');
      print('Geocoding Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final body = json.decode(res.body) as Map<String, dynamic>;
        final status = body['status'] as String?;
        print('Geocoding Status: $status');

        if (status == 'OK' && (body['results'] as List).isNotEmpty) {
          final loc = body['results'][0]['geometry']['location'];
          final lat = (loc['lat'] as num).toDouble();
          final lng = (loc['lng'] as num).toDouble();
          final latLng = LatLng(lat, lng);
          selectedLatLng.value = latLng;
          // reverse geocode search result to populate address
          await reverseGeocode(latLng);
          if (_mapController.isCompleted) {
            final ctrl = await _mapController.future;
            await ctrl.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
          } else {
            _pendingCamera = CameraPosition(target: latLng, zoom: 15);
          }
          EasyLoading.dismiss();
        } else {
          final errorMsg = body['error_message'] ?? 'Location not found';
          print('Geocoding Error: $errorMsg');
          EasyLoading.showError(errorMsg ?? 'Location not found');
        }
      } else {
        EasyLoading.showError(
          'Failed to search location (Status: ${res.statusCode})',
        );
      }
    } catch (e, st) {
      print('Geocoding error: $e');
      print(st);
      EasyLoading.showError('Failed to search location');
    }
  }

  /// Save selectedLatLng to user profile via PATCH
  Future<void> setDefaultLocation() async {
    final latlng = selectedLatLng.value;
    if (latlng == null) {
      EasyLoading.showError('Please select a location on map first');
      return;
    }

    try {
      isSaving.value = true;
      // The API expects strings for userLat/userLng
      final body = {
        'userLat': latlng.latitude.toString(),
        'userLng': latlng.longitude.toString(),
      };
      final res = await ApiClient.to.patch(Endpoint.editProfile, body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        EasyLoading.showSuccess('Default location set successfully!');
        // Refresh saved location from profile to keep consistency with server
        await _loadSavedLocationFromProfile();
      } else {
        print('Failed to save location: ${res.statusCode} ${res.bodyString}');
        EasyLoading.showError('Failed to save location');
      }
    } catch (e, st) {
      print('Error saving location: $e');
      print(st);
      EasyLoading.showError('Failed to save location');
    } finally {
      isSaving.value = false;
    }
  }

  /// Reverse geocode to get a human-readable address for a lat/lng
  Future<void> reverseGeocode(LatLng latLng) async {
    try {
      final apiKey = _getGeocodingApiKey();
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey',
      );
      print('Reverse Geocoding URL: $url');
      final res = await http.get(url);
      print('Reverse Geocoding Response Status: ${res.statusCode}');
      print('Reverse Geocoding Response Body: ${res.body}');

      if (res.statusCode == 200) {
        final body = json.decode(res.body) as Map<String, dynamic>;
        final status = body['status'] as String?;
        print('Reverse Geocoding Status: $status');

        if (status == 'OK' && (body['results'] as List).isNotEmpty) {
          final address = body['results'][0]['formatted_address'] as String?;
          resolvedAddress.value = address ?? '';
          print('Resolved Address: ${resolvedAddress.value}');
          return;
        } else {
          final errorMsg = body['error_message'] ?? 'No results found';
          print('Reverse Geocoding Error: $errorMsg');
        }
      }
      resolvedAddress.value = '';
    } catch (e, st) {
      print('Reverse geocode error: $e');
      print(st);
      resolvedAddress.value = '';
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
