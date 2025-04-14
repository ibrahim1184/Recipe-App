import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/home/views/card_widget.dart';
import 'package:recipe_app_firebase/app/modules/onboarding/views/custom_button_widget.dart';
import 'package:recipe_app_firebase/app/modules/sign_in/views/custom_text_form_field_widget.dart';
import 'package:recipe_app_firebase/colors.dart';

import '../../../../typography.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    AppColors.primary;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      prefixIcon: SvgPicture.asset("assets/icons/search.svg"),
                      hintText: "Search",
                      filled: true,
                      fillColor: AppColors.form,
                      focusedBorderColor: Colors.transparent,
                      borderColor: Colors.transparent,
                    ),
                    const Gap(24),
                    Text(
                      "Kategoriler",
                      style: AppTypography.headline2.copyWith(
                        color: const Color(0xFF3E5481),
                      ),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        categoryChange(screenWidth, screenHeight, "Tümü"),
                        const Gap(8),
                        categoryChange(screenWidth, screenHeight, "Yiyecek"),
                        const Gap(8),
                        categoryChange(screenWidth, screenHeight, "İçecek"),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(24),
              Divider(
                height: screenHeight * 0.01,
                thickness: 8,
                color: AppColors.form,
              ),
              const Gap(24),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (controller.recipes.isEmpty) {
                    controller.getRecipes();
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: ((screenWidth - 64) / 2) /
                          ((screenHeight - 64) / 2.8),
                    ),
                    itemCount: controller.recipes.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Get.toNamed("/detail-recipe",
                          arguments: controller.recipes[index]),
                      child: CardWidget(index: index),
                    ),
                  );
                }),
              )
            ],
          ),
        ));
  }

  Obx categoryChange(double screenWidth, double screenHeight, String text) {
    return Obx(() => CustomElevatedButton(
          text: text,
          color: controller.selectedCategory.value == text
              ? AppColors.primary
              : AppColors.form,
          textColor: controller.selectedCategory.value == text
              ? Colors.white
              : AppColors.secondaryText,
          onPressed: () => controller.changeCategory(text),
          width: text == "Yiyecek" ? screenWidth * 0.30 : screenWidth * 0.25,
          height: screenHeight * 0.05,
        ));
  }
}
