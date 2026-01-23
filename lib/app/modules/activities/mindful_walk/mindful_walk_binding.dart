import 'package:get/get.dart';

import 'mindful_walk_controller.dart';

class MindfulWalkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MindfulWalkController>(() => MindfulWalkController());
  }
}
