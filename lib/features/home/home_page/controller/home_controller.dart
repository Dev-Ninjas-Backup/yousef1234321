// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/features/home/home_page/model/garage_model.dart';
import 'package:yousef1234321/features/home/home_page/service/home_service.dart';

class HomeController extends GetxController {
  final HomeService _homeService;

  HomeController(this._homeService);

  final ScrollController scrollController = ScrollController();
  late Timer timer;

  double speed = 1.0;

  startScroll() {
    timer = Timer.periodic(const Duration(milliseconds: 16), (t) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.offset + speed);

        if (scrollController.offset >=
            scrollController.position.maxScrollExtent) {
          scrollController.jumpTo(0);
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    _requestLocationPermissionOnAppStart();
    startScroll();
    fetchServices();
    fetchTopRatedGarages();
  }

  Future<void> _requestLocationPermissionOnAppStart() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    timer.cancel();
    scrollController.dispose();
    super.onClose();
  }

  var garages = <GarageModel>[].obs;

  var selectedService = RxnString();
  var selectedLocation = RxnString();

  final serviceTypes = <String>[].obs;

  final locations = [
    "abu_dhabi",
    "dubai",
    "sharjah",
    "ajman",
    "fujairah",
    "ras_al_khaimah",
    "umm_al_quwain",
  ];

  final isLoadingServices = false.obs;
  final isLoadingGarages = false.obs;

  Future<void> fetchTopRatedGarages() async {
    try {
      isLoadingGarages.value = true;
      final fetchedGarages = await _homeService.fetchTopRatedGarages();
      garages.value = fetchedGarages;
    } catch (e) {
      print('Error fetching garages: $e');
    } finally {
      isLoadingGarages.value = false;
    }
  }

  Future<void> fetchServices() async {
    try {
      isLoadingServices.value = true;
      final fetchedServices = await _homeService.fetchServices();
      serviceTypes.value = fetchedServices;
    } catch (e) {
      print('Error fetching services: $e');
    } finally {
      isLoadingServices.value = false;
    }
  }
}
