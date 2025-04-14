import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/onboarding/views/custom_button_widget.dart';
import 'package:recipe_app_firebase/app/modules/sign_in/views/custom_mini_circle_widget.dart';
import 'package:recipe_app_firebase/app/modules/sign_in/views/custom_text_form_field_widget.dart';
import 'package:recipe_app_firebase/app/routes/app_pages.dart';
import 'package:recipe_app_firebase/colors.dart';
import 'package:recipe_app_firebase/typography.dart';

import '../controllers/upload_step2_controller.dart';

class UploadStep2View extends GetView<UploadStep2Controller> {
  const UploadStep2View({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ingredientsSection(),
            ),
            const Gap(16),
            divider(context),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: stepsSection(),
            ),
            const Gap(16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomElevatedButton(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    color: AppColors.form,
                    textColor: AppColors.mainText,
                    text: "Geri",
                    onPressed: () {
                      Get.toNamed("/upload");
                    },
                    width: 150,
                  ),
                  const Gap(20),
                  CustomElevatedButton(
                    elevation: 0,
                    color: AppColors.primary,
                    textColor: Colors.white,
                    text: "Kaydet",
                    onPressed: () {
                      controller.saveRecipe();
                    },
                    width: 150,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      title: GestureDetector(
        onTap: () => Get.offAllNamed(Routes.BASE),
        child: Text(
          "İptal",
          style: AppTypography.headline2.copyWith(
            color: AppColors.secondary,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            "2/2",
            style: AppTypography.headline2.copyWith(
              color: const Color(0xFF3E5481),
            ),
          ),
        ),
      ],
    );
  }

  Column stepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Adımlar",
          style:
              AppTypography.headline2.copyWith(color: const Color(0XFF3E5481)),
        ),
        const Gap(16),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.steps.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    CustomCircleWidget(
                      size: 24,
                      color: const Color(0xFF3E5481),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.outline),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: controller.steps[index],
                            textInputAction: TextInputAction.done,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Yemeğinizden bahsediniz",
                              hintStyle: AppTypography.bodyText2.copyWith(
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (index > 0)
                      IconButton(
                        onPressed: () => controller.removeStep(index),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        const Gap(16),
        CustomElevatedButton(
            elevation: 0,
            shadowColor: Colors.transparent,
            borderColor: AppColors.outline,
            text: "+ Adım Ekle",
            color: Colors.white,
            textColor: const Color(0xFF3E5481),
            onPressed: () {
              controller.addStep();
            })
      ],
    );
  }

  SizedBox divider(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: const Divider(
        height: 8,
        thickness: 8,
        color: AppColors.form,
      ),
    );
  }

  Column ingredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        Text(
          "Malzemeler",
          style: AppTypography.headline2.copyWith(
            color: const Color(0XFF3E5481),
          ),
        ),
        const Gap(16),
        SingleChildScrollView(
          child: Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.ingredients.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            controller: controller.ingredients[index],
                            hintText: "Malzemeyi giriniz",
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        if (index > 1)
                          IconButton(
                            onPressed: () => controller.removeIngredient(index),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                      ],
                    ),
                  );
                },
              )),
        ),
        const Gap(16),
        CustomElevatedButton(
            elevation: 0,
            shadowColor: Colors.transparent,
            borderColor: AppColors.outline,
            text: "+ Malzeme Ekle",
            color: Colors.white,
            textColor: const Color(0xFF3E5481),
            onPressed: () {
              controller.addIngredient();
            })
      ],
    );
  }
}
