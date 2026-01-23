import 'package:get/get.dart';

import 'sleep_stories_controller.dart';

class SleepStoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SleepStoriesController>(() => SleepStoriesController());
  }
}
