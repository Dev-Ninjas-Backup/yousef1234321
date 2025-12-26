import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class BrakePadsController extends GetxController {
  var selectedImageIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final RxMap<String, dynamic> product = <String, dynamic>{}.obs;

  // reactive image list; default assets used as fallback
  final RxList<String> images = <String>[
    'assets/images/spare_parts5.png',
    'assets/images/spare_parts1.png',
    'assets/images/spare_parts2.png',
    'assets/images/spare_parts3.png',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final productId = Get.arguments as String?;
    if (productId != null) {
      fetchProductDetails(productId);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductDetails(String productId) async {
    try {
      isLoading.value = true;
      final resp = await ApiClient.to.get('${Endpoint.products}/$productId');

      if (resp.statusCode == 200 && resp.body != null) {
        final body = resp.body;
        Map<String, dynamic> map;
        if (body is Map && body['id'] != null) {
          map = Map<String, dynamic>.from(body);
        } else if (body is Map && body['data'] is Map) {
          map = Map<String, dynamic>.from(body['data']);
        } else {
          map = {};
        }

        product.value = map;

        // populate gallery from photos if available
        if (map['photos'] is List && (map['photos'] as List).isNotEmpty) {
          final photos = (map['photos'] as List)
              .map((e) => e.toString())
              .toList();
          images.assignAll(photos);
          selectedImageIndex.value = 0;
        }
      } else {
        // keep defaults; ApiClient.handleGlobalStatus will show message
      }
    } catch (e) {
      // ignore: avoid_print
      print('BrakePadsController.fetchProductDetails error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeImage(int index) {
    if (index >= 0 && index < images.length) selectedImageIndex.value = index;
  }
}
