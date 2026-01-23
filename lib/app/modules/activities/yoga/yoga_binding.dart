import 'package:get/get.dart';

import 'yoga_controller.dart';

class YogaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YogaController>(() => YogaController());
  }
}
