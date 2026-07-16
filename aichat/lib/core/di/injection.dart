import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/sign_in_with_facebook.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';

import '../../features/onboarding/data/datasources/preferences_remote_data_source.dart';
import '../../features/onboarding/data/repositories/preferences_repository_impl.dart';
import '../../features/onboarding/domain/repositories/preferences_repository.dart';
import '../../features/onboarding/domain/usecases/get_preferences.dart';
import '../../features/onboarding/domain/usecases/save_preferences.dart';

import '../../features/chat/data/datasources/ai_remote_data_source.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/send_message.dart';

import '../../features/gamification/data/datasources/gamification_remote_data_source.dart';
import '../../features/gamification/data/repositories/gamification_repository_impl.dart';
import '../../features/gamification/domain/repositories/gamification_repository.dart';
import '../../features/gamification/domain/usecases/update_streak.dart';

class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  late final AuthRepository authRepository;
  late final PreferencesRepository preferencesRepository;
  late final ChatRepository chatRepository;
  late final GamificationRepository gamificationRepository;

  late final SignInWithGoogle signInWithGoogle;
  late final SignInWithFacebook signInWithFacebook;
  late final SignOut signOut;
  late final GetCurrentUser getCurrentUser;

  late final SavePreferences savePreferences;
  late final GetPreferences getPreferences;

  late final SendMessage sendMessage;

  late final RecordInteraction recordInteraction;

  bool _initialized = false;

  void init() {
    if (_initialized) return;

    final authRemote = AuthRemoteDataSourceImpl();
    authRepository = AuthRepositoryImpl(authRemote);
    signInWithGoogle = SignInWithGoogle(authRepository);
    signInWithFacebook = SignInWithFacebook(authRepository);
    signOut = SignOut(authRepository);
    getCurrentUser = GetCurrentUser(authRepository);

    final prefsRemote = PreferencesRemoteDataSourceImpl();
    preferencesRepository = PreferencesRepositoryImpl(prefsRemote);
    savePreferences = SavePreferences(preferencesRepository);
    getPreferences = GetPreferences(preferencesRepository);

    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    final aiRemote = AiRemoteDataSourceImpl(apiKey: apiKey);
    chatRepository = ChatRepositoryImpl(aiDataSource: aiRemote);
    sendMessage = SendMessage(chatRepository);

    final gamificationRemote = GamificationRemoteDataSourceImpl();
    gamificationRepository = GamificationRepositoryImpl(
      remoteDataSource: gamificationRemote,
    );
    recordInteraction = RecordInteraction(gamificationRepository);

    _initialized = true;
  }
}

final sl = ServiceLocator.instance;
