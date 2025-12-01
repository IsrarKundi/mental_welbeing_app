part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const CHAT = _Paths.CHAT;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const JOURNAL = _Paths.JOURNAL;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const CHAT = '/chat';
  static const ONBOARDING = '/onboarding';
  static const JOURNAL = '/journal';
}
