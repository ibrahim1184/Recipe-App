import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  final pageController = PageController();

  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
