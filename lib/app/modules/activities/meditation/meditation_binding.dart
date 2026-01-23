import 'package:get/get.dart';

import 'meditation_controller.dart';

class MeditationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeditationController>(() => MeditationController());
  }
}
