class AppConstants {
  AppConstants._();

  // Local storage keys (per-uid, prefixed) — see LocalStorageService.
  // Everything below lives on-device only; there is no cloud database.
  static const String onboardingCompleteKeyPrefix = 'onboarding_complete_';
  static const String interestsKeyPrefix = 'interests_';
  static const String statsKeyPrefix = 'user_stats_';
  static const String themePrefKey = 'is_dark_mode';

  static String onboardingCompleteKey(String uid) => '$onboardingCompleteKeyPrefix$uid';
  static String interestsKey(String uid) => '$interestsKeyPrefix$uid';
  static String statsKey(String uid) => '$statsKeyPrefix$uid';

  // Interests available in onboarding
  static const List<String> availableInterests = [
    'Tech',
    'Fitness',
    'Travel',
    'Food',
    'Finance',
    'Health',
    'Gaming',
    'Music',
  ];

  // Gamification tuning
  static const int pointsPerMessage = 10;
  static const int levelExplorerThreshold = 100; // points
  static const int levelProThreshold = 500; // points
}
