import 'package:get/get.dart';
import 'package:recipe_app_firebase/app/data/services/auth_service.dart';

class Setup {
  static void init() {
   
    Get.put(AuthService());
  }
}
