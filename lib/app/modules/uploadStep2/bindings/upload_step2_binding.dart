import 'package:get/get.dart';

import '../controllers/upload_step2_controller.dart';

class UploadStep2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadStep2Controller>(
      () => UploadStep2Controller(),
    );
  }
}
