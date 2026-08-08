import 'package:get/get.dart';
import 'package:yousef1234321/features/profile/my_listing/service/my_listing_service.dart';
import '../model/product_model.dart';

class ListingController extends GetxController {
  final MyListingService _myListingService;

  ListingController(this._myListingService);

  var selectedTab = 0.obs;
  var tabs = [
    "All Active",
    "Promoted",
    "Approved",
    "Pending",
    "Expired",
  ].obs;

  final allProducts = <ProductModel>[].obs;
  final products = <ProductModel>[].obs;

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

      final response = await _myListingService.getMyListings();
      print('ListingController: Response status=${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        List<dynamic> listData = [];

        if (body is List<dynamic>) {
          listData = body;
        } else if (body is Map<String, dynamic>) {
          if (body['data'] is List) {
            listData = body['data'];
          } else if (body['products'] is List) {
            listData = body['products'];
          }
        }

        print('ListingController: Found ${listData.length} products');

        final fetchedProducts = listData
            .map(
              (json) => ProductModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        allProducts.assignAll(fetchedProducts);
        print('ListingController: Loaded ${allProducts.length} products');

        filterListings();
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
    final list = allProducts;
    switch (selectedTab.value) {
      case 0: // All Active: status != 'DRAFT' && !isExpired
        products.assignAll(
          list.where((p) => p.status != 'DRAFT' && !p.isExpired).toList(),
        );
        break;
      case 1: // Promoted Only: isPromoted == true && status != 'DRAFT' && !isExpired
        products.assignAll(
          list.where((p) => p.isPromoted && p.status != 'DRAFT' && !p.isExpired).toList(),
        );
        break;
      case 2: // Approved: status == 'APPROVED' && !isExpired
        products.assignAll(
          list.where((p) => p.status == 'APPROVED' && !p.isExpired).toList(),
        );
        break;
      case 3: // Pending: status == 'PENDING'
        products.assignAll(
          list.where((p) => p.status == 'PENDING').toList(),
        );
        break;
      case 4: // Expired: status == 'APPROVED' && isExpired == true
        products.assignAll(
          list.where((p) => p.status == 'APPROVED' && p.isExpired).toList(),
        );
        break;
      default:
        products.assignAll(list);
    }
  }

  void repost(int index) {}

  void markAsSold(int index) {}
}
