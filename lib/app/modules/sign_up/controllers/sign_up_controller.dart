import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';

class SignUpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordLengthValid = false.obs;
  final isPasswordHasNumber = false.obs;

  void checkPassword(String value) {
    isPasswordLengthValid.value = value.length >= 6;
    isPasswordHasNumber.value = value.contains(RegExp(r'[0-9]'));
  }

  Future<void> register() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.trim().isEmpty ||
        surnameController.text.trim().isEmpty) {
      Get.snackbar(
        'Hata',
        'Lütfen tüm alanları doldurun',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isPasswordLengthValid.value || !isPasswordHasNumber.value) {
      Get.snackbar(
        'Hata',
        'Şifre gereksinimleri karşılanmıyor',
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

    final error = await _authService.createUser(
      emailController.text.trim(),
      passwordController.text,
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
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
      Get.snackbar("Başarılı", "Kullanıcı oluşturuldu");
      emailController.clear();
      passwordController.clear();
      nameController.clear();
      surnameController.clear();

      Get.offNamed("/sign-in",
          preventDuplicates: false);  
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    super.onClose();
  }
}
