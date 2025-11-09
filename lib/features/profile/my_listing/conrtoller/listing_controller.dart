import 'package:get/get.dart';
import '../model/listing_model.dart';

class ListingController extends GetxController {
  var selectedTab = 0.obs;
  var tabs = ["All listing", "Active listing", "Previous listing"].obs;

  // All listings
  final allListings = <ListingModel>[
    ListingModel(
      title: "Engine Oil Filter",
      description: "Universal fit for most vehicles",
      image: "assets/images/spare_parts5.png",
      price: 32000,
      rating: 4.5,
      reviews: 12,
      isActive: true,
    ),
    ListingModel(
      title: "Engine Oil Filter",
      description: "Universal fit for most vehicles",
      image: "assets/images/spare_parts5.png",
      price: 800,
      rating: 4.7,
      reviews: 8,
      isActive: false,
    ),
    ListingModel(
      title: "Engine Oil Filter",
      description: "Universal fit for most vehicles",
      image: "assets/images/spare_parts5.png",
      price: 28000,
      rating: 4.6,
      reviews: 10,
      isActive: true,
    ),
  ];

  var listings = <ListingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    filterListings();
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

  void repost(int index) {
  }

  void markAsSold(int index) {
  }
}
