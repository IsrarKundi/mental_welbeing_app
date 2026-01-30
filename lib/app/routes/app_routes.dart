part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const CHAT = _Paths.CHAT;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const JOURNAL = _Paths.JOURNAL;
  static const BREATHING = _Paths.BREATHING;
  static const MEDITATION = _Paths.MEDITATION;
  static const SLEEP_STORIES = _Paths.SLEEP_STORIES;
  static const MINDFUL_WALK = _Paths.MINDFUL_WALK;
  static const YOGA = _Paths.YOGA;
  static const MOOD_HISTORY = _Paths.MOOD_HISTORY;
  static const MAIN_NAV = _Paths.MAIN_NAV;
  static const CHAT_DETAIL = _Paths.CHAT_DETAIL;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const CHAT = '/chat';
  static const ONBOARDING = '/onboarding';
  static const JOURNAL = '/journal';
  static const BREATHING = '/breathing';
  static const MEDITATION = '/meditation';
  static const SLEEP_STORIES = '/sleep-stories';
  static const MINDFUL_WALK = '/mindful-walk';
  static const YOGA = '/yoga';
  static const MOOD_HISTORY = '/mood-history';
  static const MAIN_NAV = '/main';
  static const CHAT_DETAIL = '/chat-detail';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const FORGOT_PASSWORD = '/forgot-password';
}
