import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/onboarding/views/custom_button_widget.dart';
import 'package:recipe_app_firebase/app/modules/sign_in/views/custom_mini_circle_widget.dart';
import 'package:recipe_app_firebase/app/modules/sign_in/views/custom_text_form_field_widget.dart';
import 'package:recipe_app_firebase/colors.dart';
import 'package:recipe_app_firebase/typography.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  final _formKey = GlobalKey<FormState>();
  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Hoşgeldiniz!",
                      style: AppTypography.headline1
                          .copyWith(color: AppColors.mainText),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Text(
                      "Lütfen email adresinizi giriniz",
                      style: AppTypography.bodyText1
                          .copyWith(color: AppColors.secondaryText),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Gap(48),
                Column(
                  children: [
                    CustomTextFormField(
                      textCapitalization: TextCapitalization.none,
                      controller: controller.emailController,
                      prefixIcon: SvgPicture.asset("assets/icons/email.svg"),
                      hintText: "Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email alanı boş olamaz';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),
                    CustomTextFormField(
                      textCapitalization: TextCapitalization.none,
                      controller: controller.passwordController,
                      obscureText: true,
                      onChanged: (value) {
                        controller.checkPassword(value);
                        
                      },
                      prefixIcon: SvgPicture.asset("assets/icons/password.svg"),
                      hintText: "Şifre",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifre alanı boş olamaz';
                        }
                        if (value.length < 6) {
                          return 'Şifre en az 6 karakter olmalıdır';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),
                    CustomTextFormField(
                      controller: controller.nameController,
                      prefixIcon: SvgPicture.asset("assets/icons/person.svg"),
                      hintText: "Ad",
                      textInputAction: TextInputAction.next,
                    ),
                    const Gap(16),
                    CustomTextFormField(
                      controller: controller.surnameController,
                      prefixIcon: SvgPicture.asset("assets/icons/person.svg"),
                      hintText: "Soyad",
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
                const Gap(32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Şifreniz şunları içermedir:",
                      style: AppTypography.bodyText1
                          .copyWith(color: AppColors.mainText),
                    ),
                    const Gap(8),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomCircleWidget(
                                size: 24,
                                color: controller.isPasswordLengthValid.value
                                    ? const Color(0xFFE3FFF1)
                                    : const Color(0xFF9FA5C0).withOpacity(0.1),
                                child: SvgPicture.asset(
                                    controller.isPasswordLengthValid.value
                                        ? "assets/icons/check_enable.svg"
                                        : "assets/icons/check_disable.svg")),
                            const Gap(8),
                            Text("En az 6 karakter olmalı",
                                style: AppTypography.bodyText1.copyWith(
                                  color: controller.isPasswordLengthValid.value
                                      ? AppColors.mainText
                                      : AppColors.secondaryText,
                                )),
                          ],
                        )),
                    const Gap(8),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomCircleWidget(
                                size: 24,
                                color: controller.isPasswordHasNumber.value
                                    ? const Color(0xFFE3FFF1)
                                    : const Color(0xFF9FA5C0).withOpacity(0.1),
                                child: SvgPicture.asset(
                                    controller.isPasswordHasNumber.value
                                        ? "assets/icons/check_enable.svg"
                                        : "assets/icons/check_disable.svg")),
                            const Gap(8),
                            Text("Bir rakam içermeli",
                                style: AppTypography.bodyText1.copyWith(
                                  color: controller.isPasswordHasNumber.value
                                      ? AppColors.mainText
                                      : AppColors.secondaryText,
                                )),
                          ],
                        )),
                  ],
                ),
                const Gap(48),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    text: "Kayıt Ol",
                    color: AppColors.primary,
                    onPressed: controller.isLoading.value
                        ? () {}
                        : () {
                            if (_formKey.currentState!.validate()) {
                              controller.register();
                            }
                          },
                  ),
                ),
                const Gap(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Zaten hesabınız var mı?",
                      style: AppTypography.bodyText2.copyWith(
                        color: AppColors.mainText,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "Giriş Yap",
                        style: AppTypography.headline3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
