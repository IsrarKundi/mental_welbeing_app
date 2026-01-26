import 'package:get/get.dart';
import 'package:mental_welbeing/app/modules/activities/breathing/breathing_view.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/chat/chat_binding.dart';
import '../modules/chat/chat_view.dart';
import '../modules/chat/chat_detail_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/activities/breathing/breathing_binding.dart';
import '../modules/activities/meditation/meditation_binding.dart';
import '../modules/activities/meditation/meditation_view.dart';
import '../modules/activities/journal/journal_binding.dart';
import '../modules/activities/journal/journal_view.dart';
import '../modules/activities/sleep_stories/sleep_stories_binding.dart';
import '../modules/activities/sleep_stories/sleep_stories_view.dart';
import '../modules/activities/mindful_walk/mindful_walk_binding.dart';
import '../modules/activities/mindful_walk/mindful_walk_view.dart';
import '../modules/activities/yoga/yoga_binding.dart';
import '../modules/activities/yoga/yoga_view.dart';
import '../modules/mood_history/mood_history_binding.dart';
import '../modules/mood_history/mood_history_view.dart';
import '../modules/main_nav/main_nav_binding.dart';
import '../modules/main_nav/main_nav_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.BREATHING,
      page: () => const BreathingView(),
      binding: BreathingBinding(),
    ),
    GetPage(
      name: _Paths.MEDITATION,
      page: () => const MeditationView(),
      binding: MeditationBinding(),
    ),
    GetPage(
      name: _Paths.JOURNAL,
      page: () => const JournalView(),
      binding: JournalBinding(),
    ),
    GetPage(
      name: _Paths.SLEEP_STORIES,
      page: () => const SleepStoriesView(),
      binding: SleepStoriesBinding(),
    ),
    GetPage(
      name: _Paths.MINDFUL_WALK,
      page: () => const MindfulWalkView(),
      binding: MindfulWalkBinding(),
    ),
    GetPage(
      name: _Paths.YOGA,
      page: () => const YogaView(),
      binding: YogaBinding(),
    ),
    GetPage(
      name: _Paths.MOOD_HISTORY,
      page: () => const MoodHistoryView(),
      binding: MoodHistoryBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_NAV,
      page: () => const MainNavView(),
      binding: MainNavBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_DETAIL,
      page: () => const ChatDetailView(),
      binding: ChatBinding(),
    ),
  ];
}
