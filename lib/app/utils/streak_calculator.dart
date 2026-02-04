/// Utility class for calculating activity streaks.
///
/// Extracts shared streak calculation logic from HomeController
/// and ProfileController to eliminate code duplication.
class StreakCalculator {
  StreakCalculator._();

  /// Calculates the current streak based on completed activity dates.
  ///
  /// [dates] should be a list of DateTime objects representing days
  /// with completed activities, sorted newest first.
  ///
  /// Returns the number of consecutive days up to and including today.
  static int calculateCurrentStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;

    // Normalize to date-only (no time component)
    final normalizedDates =
        dates.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList()
          ..sort((a, b) => b.compareTo(a)); // newest first

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final yesterday = todayNormalized.subtract(const Duration(days: 1));

    // Check if the most recent activity was today or yesterday
    final mostRecent = normalizedDates.first;
    if (mostRecent != todayNormalized && mostRecent != yesterday) {
      return 0; // Streak broken
    }

    int streak = 0;
    DateTime checkDate = mostRecent;

    for (final date in normalizedDates) {
      if (date == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        // Gap in dates, streak ends
        break;
      }
    }

    return streak;
  }

  /// Calculates the longest streak ever achieved.
  ///
  /// [dates] should be a list of DateTime objects representing days
  /// with completed activities.
  static int calculateLongestStreak(List<DateTime> dates) {
    if (dates.isEmpty) return 0;

    // Normalize and sort oldest first
    final normalizedDates =
        dates.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList()
          ..sort();

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < normalizedDates.length; i++) {
      final diff = normalizedDates[i].difference(normalizedDates[i - 1]).inDays;

      if (diff == 1) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else if (diff > 1) {
        currentStreak = 1;
      }
      // diff == 0 means same day, ignore
    }

    return longestStreak;
  }

  /// Checks if a streak includes activity for today.
  static bool hasActivityToday(List<DateTime> dates) {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    return dates.any(
      (d) =>
          d.year == todayNormalized.year &&
          d.month == todayNormalized.month &&
          d.day == todayNormalized.day,
    );
  }
}
