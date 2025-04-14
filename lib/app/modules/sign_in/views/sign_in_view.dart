import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/onboarding/views/custom_button_widget.dart';
import 'package:recipe_app_firebase/app/modules/sign_in/views/custom_text_form_field_widget.dart';
import 'package:recipe_app_firebase/colors.dart';
import 'package:recipe_app_firebase/typography.dart';

import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  final _formKey = GlobalKey<FormState>();
  SignInView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Gap(48),
                  Column(
                    children: [
                      Text(
                        "Tekrar Hoşgeldiniz!",
                        style: AppTypography.headline1
                            .copyWith(color: AppColors.mainText),
                      ),
                      const Gap(8),
                      Text(
                        "Lütfen email adresinizi giriniz",
                        style: AppTypography.bodyText1
                            .copyWith(color: AppColors.secondaryText),
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
                        prefixIcon:
                            SvgPicture.asset("assets/icons/password.svg"),
                        hintText: "Şifre",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifre alanı boş olamaz';
                          }
                          return null;
                        },
                      ),
                      const Gap(8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Şifrenizi mi unuttunuz?",
                            style: AppTypography.bodyText2.copyWith(
                              color: AppColors.mainText,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(48),
                  Column(
                    children: [
                      CustomElevatedButton(
                        text: "Giriş Yap",
                        color: AppColors.primary,
                        onPressed: controller.isLoading.value
                            ? () {}
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  controller.login();
                                }
                              },
                      ),
                      const Gap(16),
                      Text(
                        "Ya da şununla devam edin",
                        style: AppTypography.bodyText2.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const Gap(16),
                      CustomElevatedButton(
                        text: "Google",
                        color: const Color(0xFFFF5842),
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/icons/google.svg"),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hesabınız yok mu?",
                            style: AppTypography.bodyText2
                                .copyWith(color: AppColors.mainText),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/sign-up');
                            },
                            child: Text(
                              "Kayıt Ol",
                              style: AppTypography.headline3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
