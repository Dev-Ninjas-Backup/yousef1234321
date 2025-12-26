// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import '../model/listing_model.dart';
import '../model/product_model.dart';

class ListingController extends GetxController {
  var selectedTab = 0.obs;
  var tabs = ["All listing", "Active listing", "Previous listing"].obs;

  final allListings = <ListingModel>[].obs;
  var listings = <ListingModel>[].obs;

  final isLoading = false.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyListings();
  }

  Future<void> fetchMyListings() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      print('ListingController: Fetching my listings...');

      final response = await ApiClient.to.get(Endpoint.myListing);
      print('ListingController: Response status=${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;

        if (body is List<dynamic>) {
          print('ListingController: Found ${body.length} products');

          final products = body
              .map(
                (json) => ProductModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

          // Convert ProductModel to ListingModel for UI compatibility
          final convertedListings = products
              .map(
                (product) => ListingModel(
                  id: product.id,
                  title: product.partName,
                  description: product.description,
                  image: product.mainImage,
                  price: double.tryParse(product.price) ?? 0.0,
                  rating: 0.0, // Not provided by API
                  reviews: product.inquiries,
                  isActive: product.isActive,
                ),
              )
              .toList();

          allListings.assignAll(convertedListings);
          print('ListingController: Loaded ${allListings.length} listings');

          filterListings();
        }
      } else {
        print('ListingController: Failed with status ${response.statusCode}');
        hasError.value = true;
      }
    } catch (e, stackTrace) {
      print('Failed to fetch listings: $e');
      print('Stack trace: $stackTrace');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
    filterListings();
  }

  void filterListings() {
    if (selectedTab.value == 0) {
      listings.assignAll(allListings);
    } else if (selectedTab.value == 1) {
      listings.assignAll(allListings.where((e) => e.isActive).toList());
    } else {
      listings.assignAll(allListings.where((e) => !e.isActive).toList());
    }
  }

  void repost(int index) {}

  void markAsSold(int index) {}
}
