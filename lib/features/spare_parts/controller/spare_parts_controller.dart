import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/service/translation_service.dart';
import 'package:yousef1234321/features/spare_parts/controller/products_controller.dart';
import 'package:yousef1234321/features/spare_parts/screen/parts_search_results_screen.dart';

class SparePartsController extends GetxController {
  final TextEditingController searchInputController = TextEditingController();
  var selectedModel = RxnString();
  var selectedCategory = RxnString();

  final RxList<String> dropDownCategories = <String>[].obs;

  // Use dynamic map for API-friendly parsing
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  final random = Random();

  Color getRandomColor() {
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.red.shade100,
      Colors.yellow.shade100,
      Colors.purple.shade100,
      Colors.orange.shade100,
      Colors.teal.shade100,
      Colors.grey.shade200,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategoriesFromApi();
  }

  @override
  void onClose() {
    searchInputController.dispose();
    super.onClose();
  }

  /// Clears the search text field and selected category/model item
  void clearSearchFields() {
    searchInputController.clear();
    selectedModel.value = null;
    selectedCategory.value = null;
  }

  String _getEnglishText(String key) {
    final englishMap = Get.translations['en_US'];
    if (englishMap != null && englishMap.containsKey(key)) {
      return englishMap[key]!;
    }
    return key;
  }

  /// Performs product search and clears the search keyword/item after search
  Future<void> performSearch() async {
    final searchText = searchInputController.text.trim();
    final category = selectedCategory.value;

    if (searchText.isEmpty && (category == null || category.isEmpty)) {
      final ts = Get.find<TranslationService>();
      final title = await ts.translate(_getEnglishText("selection_required"));
      final msg = await ts.translate(_getEnglishText("enter_search_term_or_category"));

      Get.snackbar(
        title,
        msg,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Find category ID by name from categories list
    String? catId;
    if (category != null && category.isNotEmpty) {
      final match = categories.firstWhere(
        (c) => (c['name']?.toString() ?? '') == category,
        orElse: () => {},
      );
      if (match.isNotEmpty) catId = match['id']?.toString();
    }

    final searchTerm = searchText.isNotEmpty ? searchText : null;

    // Clear search keyword and selected item after gathering parameters
    clearSearchFields();

    final productsCtrl = Get.put(
      ProductsController(),
      tag: 'productsList',
    );

    await productsCtrl.fetchProducts(
      page: 1,
      limit: 20,
      categoryId: catId,
      category: category,
      search: searchTerm,
    );

    Get.to(() => const PartsSearchResultsScreen());
  }

  Future<void> fetchCategoriesFromApi() async {
    try {
      final resp = await ApiClient.to.get(Endpoint.partsCategory);
      if (resp.statusCode == 200 && resp.body != null) {
        final body = resp.body;
        // body expected shape: { success, message, data: { data: [...], pagination: {...}}}
        final list = <Map<String, dynamic>>[];
        if (body is Map &&
            body['data'] is Map &&
            body['data']['data'] is List) {
          for (final item in body['data']['data']) {
            if (item is Map) {
              final id = item['id'] ?? item['_id'] ?? '';
              list.add(<String, dynamic>{
                'id': id.toString(),
                'name': item['name']?.toString() ?? '',
                'icon': Icons.category,
              });
            }
          }
        }

        // update reactive lists
        if (list.isNotEmpty) {
          categories.assignAll(list);
          final names = list
              .map((e) => e['name']?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList();
          dropDownCategories.assignAll(names);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('fetchCategoriesFromApi error: $e');
    }
  }
}

