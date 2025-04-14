import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/modules/home/controllers/home_controller.dart';
import 'package:recipe_app_firebase/app/modules/notification/controllers/notification_controller.dart';
import 'package:recipe_app_firebase/app/modules/profile/controllers/profile_controller.dart';
import 'package:recipe_app_firebase/app/modules/upload/controllers/upload_controller.dart';

import '../controllers/base_controller.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BaseController>(() => BaseController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<UploadController>(() => UploadController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
