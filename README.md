# AI Companion — Personalized AI Chatbot (Flutter)

A Flutter app that authenticates users (Google/Facebook via Firebase Auth), onboards
them with interest preferences, and chats with a Gemini-backed AI that tailors its
answers to those preferences. Engagement is gamified with points, a daily streak, and
badges.

**No backend database.** Firebase Auth is the only cloud dependency — everything else
(onboarding preferences, gamification stats) is stored on-device via
`shared_preferences`. There's no Firestore, no cross-device sync, and no leaderboard,
since a real leaderboard needs data shared across users, which is out of scope for a
local-storage-only build.

## 1. Setup / Run Instructions

### Prerequisites
- Flutter SDK 3.22+ (Dart 3.3+)
- A Firebase project with **Authentication** enabled (Firestore is not needed)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)
- A Gemini API key (https://aistudio.google.com/apikey)

### Steps

```bash
# 1. Install dependencies
flutter pub get

# 2. Configure Firebase for this project (generates real lib/firebase_options.dart)
firebase login
flutterfire configure
#   -> select your Firebase project
#   -> select Android + iOS
#   -> this overwrites the placeholder lib/firebase_options.dart

# 3. Enable sign-in providers in the Firebase Console
#    Authentication > Sign-in method > enable Google and Facebook
#    (Facebook requires an App ID/Secret from developers.facebook.com)
#    Firestore does NOT need to be enabled for this build.

# 4. Add platform config files
#    Android: android/app/google-services.json  (from Firebase console)
#    iOS:     ios/Runner/GoogleService-Info.plist (from Firebase console)

# 5. Environment variables (AI provider keys)
    .env
#   edit .env and set GEMINI_API_KEY=... (or OPENAI_API_KEY=...)
#   .env is git-ignored — never commit real keys

# 6. Run
flutter run
```

### AI provider
This build calls the Gemini API directly (`AiRemoteDataSourceImpl` in
`lib/features/chat/data/datasources/ai_remote_data_source.dart`). It's isolated behind
the `AiRemoteDataSource` interface, so swapping in a different provider later only
means writing a new implementation of that interface — no changes needed anywhere
else in the app.

---

## 2. Architecture

**Clean Architecture (Uncle Bob), feature-first.** Each feature (`auth`, `onboarding`,
`chat`, `gamification`) has its own `data / domain / presentation` stack. The
dependency rule is strict and one-directional: