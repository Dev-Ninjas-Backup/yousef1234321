// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/home/home_page/model/garage_model.dart';

class HomeController extends GetxController {
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
    startScroll();
    fetchServices();
    fetchTopRatedGarages();
  }

  @override
  void onClose() {
    timer.cancel();
    scrollController.dispose();
    super.onClose();
  }

  var garages = <GarageModel>[].obs;

  var services = [
    "ac_repair",
    "battery",
    "engine",
    "tires",
    "electrical", 
    "spares",
  ];

  var selectedService = RxnString();
  var selectedLocation = RxnString();

  final serviceTypes = <String>[].obs; // Changed to observable list

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

      // Fetch more garages (limit 10) to have better selection for top 2
      var response = await ApiClient.to.get(
        '${Endpoint.findGarage}?page=1&limit=10&status=APPROVED&sortBy=averageRating&order=desc',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null &&
            body['success'] == true &&
            body['data'] != null &&
            body['data']['data'] != null) {
          final List<dynamic> garagesJson = body['data']['data'];

          // If no APPROVED garages found, try fetching all garages
          if (garagesJson.isEmpty) {
            response = await ApiClient.to.get(
              '${Endpoint.findGarage}?page=1&limit=10&sortBy=averageRating&order=desc',
            );

            if (response.statusCode == 200 || response.statusCode == 201) {
              final allBody = response.body;
              if (allBody != null &&
                  allBody['success'] == true &&
                  allBody['data'] != null &&
                  allBody['data']['data'] != null) {
                final allGaragesJson = allBody['data']['data'] as List<dynamic>;

                final garagesList = allGaragesJson
                    .map((json) => GarageModel.fromJson(json))
                    .toList();

                // Sort by averageRating in descending order
                garagesList.sort(
                  (a, b) => b.averageRating.compareTo(a.averageRating),
                );

                // Log ratings for debugging
                for (var garage in garagesList) {}

                // Take only top 2
                garages.value = garagesList.take(2).toList();
              }
            }
          } else {
            final garagesList = garagesJson
                .map((json) => GarageModel.fromJson(json))
                .toList();

            // Sort by averageRating in descending order (client-side backup)
            garagesList.sort(
              (a, b) => b.averageRating.compareTo(a.averageRating),
            );

            // Log ratings for debugging
            for (var garage in garagesList) {}

            // Take only top 2
            garages.value = garagesList.take(2).toList();
          }
        } else {}
      } else {}
    } catch (e, stackTrace) {
    } finally {
      isLoadingGarages.value = false;
    }
  }

  Future<void> fetchServices() async {
    try {
      isLoadingServices.value = true;

      final response = await ApiClient.to.get(Endpoint.getService);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;

        if (body != null && body['serviceCategories'] != null) {
          final List<dynamic> categories = body['serviceCategories'];
          serviceTypes.value = categories.map((e) => e.toString()).toList();
        } else {}
      } else {}
    } catch (e) {
      // Fallback to default services if API fails
      serviceTypes.value = [
        "ac_repair",
        "battery",
        "engine",
        "tires",
        "electrical",
        "spares",
        "brakes",
        "body_work",
      ];
    } finally {
      isLoadingServices.value = false;
    }
  }
}
