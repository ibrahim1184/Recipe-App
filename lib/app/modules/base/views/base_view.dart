import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/home/views/home_view.dart';
import 'package:recipe_app_firebase/app/modules/notification/views/notification_view.dart';
import 'package:recipe_app_firebase/app/modules/profile/views/profile_view.dart';
import 'package:recipe_app_firebase/app/modules/upload/views/upload_view.dart';
import 'package:recipe_app_firebase/colors.dart';

import '../controllers/base_controller.dart';

class BaseView extends GetView<BaseController> {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const UploadView(),
      const NotificationView(),
      const ProfileView(),
    ];

    return Obx(
      () => Scaffold(
        body: PageView.builder(
          controller: controller.pageController,
          onPageChanged: (index) => controller.currentIndex.value = index,
          itemCount: pages.length,
          itemBuilder: (context, index) => pages[index],
        ),
        bottomNavigationBar: controller.currentIndex.value == 1
            ? null
            : BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: controller.currentIndex.value,
                onTap: controller.changePage,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.secondaryText,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Ana Sayfa',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: 'Tarif Ekle',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Bildirimler',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profil',
                  ),
                ],
              ),
      ),
    );
  }
}
