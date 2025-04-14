import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/data/models/recipe_model.dart';
import 'package:recipe_app_firebase/app/modules/home/controllers/home_controller.dart';
import 'package:recipe_app_firebase/app/modules/upload/controllers/upload_controller.dart';

class UploadStep2Controller extends GetxController {
  final RxList<TextEditingController> ingredients =
      <TextEditingController>[].obs;
  final RxList<TextEditingController> steps = <TextEditingController>[].obs;
  final HomeController homeController = Get.find<HomeController>();
  final UploadController uploadController = Get.find<UploadController>();

  @override
  void onInit() {
    super.onInit();
    ingredients.add(TextEditingController());
    ingredients.add(TextEditingController());
    addStep();
  }

  void addStep() {
    steps.add(TextEditingController());
  }

  void addIngredient() {
    ingredients.add(TextEditingController());
  }

  void removeStep(int index) {
    steps.removeAt(index);
  }

  void removeIngredient(int index) {
    ingredients[index].dispose();
    ingredients.removeAt(index);
  }

  @override
  void onClose() {
    for (var controller in ingredients) {
      controller.dispose();
    }
    super.onClose();
  }

  void saveRecipe() {
    if (ingredients.any((controller) => controller.text.isEmpty)) {
      Get.snackbar('Hata', 'Lütfen tüm malzemeleri doldurun');
      return;
    }

    if (steps.any((controller) => controller.text.isEmpty)) {
      Get.snackbar('Hata', 'Lütfen tüm adımları doldurun');
      return;
    }
    final uploadController = Get.find<UploadController>();
    final homeController = Get.find<HomeController>();

    final ingredientsList =
        ingredients.map((controller) => controller.text).toList();
    final stepsList = steps
        .map(
          (controller) => RecipeStep(
            description: controller.text,
          ),
        )
        .toList();

    homeController.uploadRecipe(
      title: uploadController.tempTitle.value,
      description: uploadController.tempDescription.value,
      preparationTime: uploadController.tempPreparationTime.value,
      ingredients: ingredientsList,
      steps: stepsList,
      imageUrl: uploadController.tempImageUrl.value,
    );
    Get.offAllNamed('/base');
  }
}
