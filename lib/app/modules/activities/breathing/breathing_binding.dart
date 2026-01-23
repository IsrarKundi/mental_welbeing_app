import 'package:get/get.dart';

import 'breathing_controller.dart';

class BreathingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BreathingController>(() => BreathingController());
  }
}
