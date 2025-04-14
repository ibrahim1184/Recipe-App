import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';

class SignInController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Hata',
        'Lütfen email ve şifre alanlarını doldurun',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    final error = await _authService.login(
      emailController.text.trim(),
      passwordController.text,
    );

    isLoading.value = false;
    Get.back();  

    if (error != null) {
      Get.snackbar(
        'Hata',
        error,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.offAllNamed('/base');  
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
