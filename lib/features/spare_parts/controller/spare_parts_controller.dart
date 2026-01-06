//import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class SparePartsController extends GetxController {
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
