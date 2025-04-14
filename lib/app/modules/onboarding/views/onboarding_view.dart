import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/onboarding/views/custom_button_widget.dart';
import 'package:recipe_app_firebase/colors.dart';
import 'package:recipe_app_firebase/typography.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            "assets/images/onboarding.png",
            width: screenWidth,
            height: screenHeight * 0.5,
            fit: BoxFit.cover,
          ),
          Text(
            "Yemek Pişirmeye Başla",
            style: AppTypography.headline1.copyWith(
              color: AppColors.mainText,
            ),
          ),
          Text("Daha lezzetli yemekler için\n      topluluğumuza katılın",
              style: AppTypography.bodyText1.copyWith(
                color: AppColors.secondaryText,
              )),
          CustomElevatedButton(
              text: "Hadi Başlayalım",
              color: AppColors.primary,
              onPressed: () {
                Get.toNamed("/sign-in");
              }),
        ],
      ),
    );
  }
}
