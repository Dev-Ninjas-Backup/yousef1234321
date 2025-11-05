import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FindChargerController extends GetxController {
  final searchController = TextEditingController();

  var selectedItem = ''.obs;
  var isDropdownVisible = false.obs;
  final List<String> items = ['Garage Services', 'Towing Service'];

  final PageController pageController = PageController(viewportFraction: 0.6);
  var currentPage = 0.0.obs;

  final List<String> images = [
    "https://innovativeconcretecoatings.com/wp-content/uploads/2022/04/garage-interior-modern-1024x555.jpg",
    "https://innovativeconcretecoatings.com/wp-content/uploads/2022/04/garage-interior-modern-1024x555.jpg",
    "https://innovativeconcretecoatings.com/wp-content/uploads/2022/04/garage-interior-modern-1024x555.jpg",
    "https://innovativeconcretecoatings.com/wp-content/uploads/2022/04/garage-interior-modern-1024x555.jpg",
    "https://innovativeconcretecoatings.com/wp-content/uploads/2022/04/garage-interior-modern-1024x555.jpg",
    "https://innovativeconcretecoatings.com/wp-content/uploads/2022/04/garage-interior-modern-1024x555.jpg",
  ];
  @override
  void onInit() {
    super.onInit();
    pageController.addListener(() {
      currentPage.value = pageController.page ?? 0.0;
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
