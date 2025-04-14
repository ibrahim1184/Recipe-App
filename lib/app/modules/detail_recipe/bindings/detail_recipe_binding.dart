import 'package:get/get.dart';

import '../controllers/detail_recipe_controller.dart';

class DetailRecipeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailRecipeController>(
      () => DetailRecipeController(),
    );
  }
}
