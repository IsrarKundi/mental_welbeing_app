/// Centralized asset paths for the Mental Wellbeing app.
///
/// This class provides constants for all illustration assets,
/// making it easy to update paths in one place.
class AppAssets {
  AppAssets._();

  static const String _base = 'assets/images/illustrations';

  // ─────────────────────────────────────────────────────────────
  // Activity Illustrations
  // ─────────────────────────────────────────────────────────────
  static const String breathing = '$_base/activities/breathing.jpg';
  static const String meditation = '$_base/activities/meditation.jpg';
  static const String journal = '$_base/activities/journal.png';
  static const String sleepStories = '$_base/activities/sleep_stories.jpg';
  static const String mindfulWalk = '$_base/activities/mindful_walk.png';
  static const String yoga = '$_base/activities/yoga.jpg';

  // ─────────────────────────────────────────────────────────────
  // Mentor Avatars
  // ─────────────────────────────────────────────────────────────
  static const String mentorSerene = '$_base/mentors/serene.png';
  static const String mentorAtlas = '$_base/mentors/atlas.png';
  static const String mentorNova = '$_base/mentors/nova.png';
  static const String mentorSage = '$_base/mentors/sage.png';

  // ─────────────────────────────────────────────────────────────
  // Sleep Story Thumbnails
  // ─────────────────────────────────────────────────────────────
  static const String storyForest = '$_base/stories/forest_dreams.png';
  static const String storyOcean = '$_base/stories/ocean_waves.png';
  static const String storyMountain = '$_base/stories/mountain_retreat.png';
  // More story images can be added when image generation quota resets
  static const String storyStarlit = '$_base/stories/starlit_garden.png';
  static const String storyRainy = '$_base/stories/rainy_evening.png';

  // ─────────────────────────────────────────────────────────────
  // Onboarding Illustrations (pending generation)
  // ─────────────────────────────────────────────────────────────
  static const String onboardingWelcome = '$_base/onboarding/welcome.png';
  static const String onboardingAi = '$_base/onboarding/ai_support.png';
  static const String onboardingMood = '$_base/onboarding/mood_tracking.png';
  static const String onboardingActivities = '$_base/onboarding/activities.png';

  // ─────────────────────────────────────────────────────────────
  // Resource Illustrations (pending generation)
  // ─────────────────────────────────────────────────────────────
  static const String resourceStress = '$_base/resources/stress_management.png';
  static const String resourceSleep = '$_base/resources/sleep_hygiene.png';
  static const String resourceMindfulness = '$_base/resources/mindfulness.png';
  static const String resourceRelationships =
      '$_base/resources/relationships.png';
  static const String resourceSelfCare = '$_base/resources/self_care.png';

  // ─────────────────────────────────────────────────────────────
  // Hero Images
  // ─────────────────────────────────────────────────────────────
  static const String dailyFocus = '$_base/heroes/daily_focus.png';
}
