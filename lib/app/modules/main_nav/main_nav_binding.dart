import 'package:get/get.dart';

import 'main_nav_controller.dart';
import '../home/home_controller.dart';
import '../progress/progress_controller.dart';
import '../chat/chat_controller.dart';
import '../profile/profile_controller.dart';
import '../mood_history/mood_history_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProgressController>(() => ProgressController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<MoodHistoryController>(() => MoodHistoryController());
  }
}
