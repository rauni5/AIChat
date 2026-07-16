import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/sign_in_with_facebook.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';

class ServiceLocator {
  ServiceLocator._();
  static final ServiceLocator instance = ServiceLocator._();

  late final AuthRepository authRepository;

  late final SignInWithGoogle signInWithGoogle;
  late final SignInWithFacebook signInWithFacebook;
  late final SignOut signOut;
  late final GetCurrentUser getCurrentUser;

  bool _initialized = false;

  void init() {
    if (_initialized) return;

    final authRemote = AuthRemoteDataSourceImpl();
    authRepository = AuthRepositoryImpl(authRemote);
    signInWithGoogle = SignInWithGoogle(authRepository);
    signInWithFacebook = SignInWithFacebook(authRepository);
    signOut = SignOut(authRepository);
    getCurrentUser = GetCurrentUser(authRepository);

    _initialized = true;
  }
}

final sl = ServiceLocator.instance;
