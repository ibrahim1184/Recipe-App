import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/home/views/card_widget.dart';
import 'package:recipe_app_firebase/colors.dart';
import 'package:recipe_app_firebase/typography.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: AppColors.mainText,
            ),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Çıkış Yap'),
                  content:
                      const Text('Çıkış yapmak istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('İptal'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.logout();
                        Get.offAllNamed('/sign-in');
                      },
                      child: const Text(
                        'Çıkış Yap',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Gap(40),
              Stack(
                children: [
                  Obx(() {
                    if (controller.isUploading.value) {
                      return const CircleAvatar(
                        radius: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (controller.profileImageUrl.value == null) {
                      return const CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    }

                    if (controller.profileImageUrl.value!.startsWith('/')) {
                      // Yerel dosya yolu ise
                      return CircleAvatar(
                        backgroundImage:
                            FileImage(File(controller.profileImageUrl.value!)),
                        radius: 50,
                      );
                    }

                    return CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: Image.network(
                          controller.profileImageUrl.value!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => controller.showImageSourceDialog(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Obx(() => Text(
                    controller.fullName.value,
                    style: AppTypography.headline2.copyWith(
                      color: const Color(0xFF3E5481),
                    ),
                  )),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  profileNumberDetails("123", "Tarifler"),
                  const Gap(12),
                  profileNumberDetails("543", "Takip"),
                  const Gap(12),
                  profileNumberDetails("1.287", "Takipçiler"),
                ],
              ),
              const Gap(12),
              divider(context),
              const Gap(12),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: const Color(0xFF3E5481),
                      unselectedLabelColor: AppColors.secondaryText,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: MaterialIndicator(
                        height: 4,
                        topLeftRadius: 0,
                        topRightRadius: 0,
                        bottomLeftRadius: 0,
                        bottomRightRadius: 0,
                        color: AppColors.primary,
                        paintingStyle: PaintingStyle.fill,
                      ),
                      tabs: const [
                        Tab(text: "Tarifler"),
                        Tab(text: "Beğenilenler"),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: TabBarView(
                        children: [
                          Obx(() => controller.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 0.75,
                                  ),
                                  itemCount: controller.recipes.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () => Get.toNamed(
                                      "/detail-recipe",
                                      arguments: controller.recipes[index],
                                    ),
                                    child: CardWidget(
                                      index: index,
                                      hideUserInfo: true,
                                    ),
                                  ),
                                )),
                          Obx(() => GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: controller.favorites.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () => Get.toNamed(
                                    "/detail-recipe",
                                    arguments: controller.favorites[index],
                                  ),
                                  child: CardWidget(
                                    index: index,
                                    hideUserInfo: true,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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

  Column profileNumberDetails(String number, String text) {
    return Column(
      children: [
        Text(
          number,
          style: AppTypography.headline2.copyWith(
            color: const Color(0xFF3E5481),
          ),
        ),
        Text(
          text,
          style:
              AppTypography.smallText.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}
