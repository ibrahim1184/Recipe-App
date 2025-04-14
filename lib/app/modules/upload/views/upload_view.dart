import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/onboarding/views/custom_button_widget.dart';
import 'package:recipe_app_firebase/app/modules/sign_in/views/custom_text_form_field_widget.dart';
import 'package:recipe_app_firebase/app/routes/app_pages.dart';
import 'package:recipe_app_firebase/colors.dart';
import 'package:recipe_app_firebase/typography.dart';

import '../controllers/upload_controller.dart';

class UploadView extends GetView<UploadController> {
  const UploadView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
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
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "1/",
                      style: AppTypography.headline2.copyWith(
                        color: const Color(0xFF3E5481),
                      )),
                  TextSpan(
                    text: "2",
                    style: AppTypography.headline2.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => controller.showImageSourceDialog(),
                child: dottedBorder(),
              ),
              const Gap(16),
              Text(
                "Yemek Adı",
                style: AppTypography.headline2.copyWith(
                  color: const Color(0xFF3E5481),
                ),
              ),
              const Gap(16),
              CustomTextFormField(
                controller: controller.nameController,
                hintText: "Yemek Adınızı Yazın",
                textInputAction: TextInputAction.next,
                focusedBorderColor: AppColors.outline,
              ),
              const Gap(16),
              Text(
                "Yemek Açıklaması",
                style: AppTypography.headline2.copyWith(
                  color: const Color(0xFF3E5481),
                ),
              ),
              const Gap(16),
              Container(
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
                    textInputAction: TextInputAction.done,
                    controller: controller.descriptionController,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Yemek Açıklamanızı Yazın",
                      hintStyle: AppTypography.bodyText2.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(20),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Pişirme Süresi",
                      style: AppTypography.headline2.copyWith(
                        color: const Color(0xFF3E5481),
                      ),
                    ),
                    TextSpan(
                      text: " (Dakika)",
                      style: AppTypography.bodyText2.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              cookingDuration(),
              const Gap(16),
              CustomElevatedButton(
                text: "İleri",
                color: AppColors.primary,
                onPressed: () {
                  controller.validateAndContinue();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Column cookingDuration() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "<10",
              style: AppTypography.headline2.copyWith(
                color: const Color(0xFF3E5481),
              ),
            ),
            Text(
              "30",
              style: AppTypography.headline2.copyWith(
                color: const Color(0xFF3E5481),
              ),
            ),
            Text(
              ">60",
              style: AppTypography.headline2.copyWith(
                color: const Color(0xFF3E5481),
              ),
            ),
          ],
        ),
        FlutterSlider(
          values: [controller.cookingTime.value.toDouble()],
          min: 10,
          max: 50,
          onDragging: (handlerIndex, lowerValue, upperValue) {
            controller.cookingTime.value = lowerValue.toInt();
          },
          handler: FlutterSliderHandler(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Container(),
          ),
          trackBar: const FlutterSliderTrackBar(
            inactiveTrackBarHeight: 8,
            activeTrackBarHeight: 8,
            activeTrackBar: BoxDecoration(
              color: AppColors.primary,
            ),
          ),
          tooltip: FlutterSliderTooltip(
            disabled: true,
          ),
          handlerWidth: 24,
          handlerHeight: 24,
          touchSize: 24,
          handlerAnimation: const FlutterSliderHandlerAnimation(
            scale: 1,
          ),
        ),
      ],
    );
  }

  DottedBorder dottedBorder() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      dashPattern: const [8, 8],
      color: Colors.grey.shade400,
      strokeWidth: 2,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    return controller.selectedImage.value != null
                        ? Image.file(
                            controller.selectedImage.value!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/images/upload_view_photo.png",
                            width: 64,
                            height: 64,
                          );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Resim Yükle",
              style: AppTypography.headline3.copyWith(
                color: const Color(0xFF3E5481),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
