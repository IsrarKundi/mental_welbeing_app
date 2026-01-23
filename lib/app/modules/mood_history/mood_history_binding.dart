import 'package:get/get.dart';

import 'mood_history_controller.dart';

class MoodHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoodHistoryController>(() => MoodHistoryController());
  }
}
