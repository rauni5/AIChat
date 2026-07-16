import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/local_storage_service.dart';
import '../../../../core/network/api_exception.dart';
import '../models/user_model.dart';

/// Talks only to Firebase Auth (+ the Google/Facebook SDKs it federates
/// to). There is no remote user-profile database — the only per-user
/// state kept outside Firebase Auth itself (the onboarding-complete flag)
/// lives in local storage, read here so callers get a complete UserModel
/// in one call.
abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithFacebook();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final LocalStorageService _localStorage;

  AuthRemoteDataSourceImpl({
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    LocalStorageService? localStorage,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _localStorage = localStorage ?? LocalStorageService();

  Future<UserModel> _toModel(fb.User fbUser) async {
    final completed = await _localStorage.getBool(
      AppConstants.onboardingCompleteKey(fbUser.uid),
    );
    return UserModel.fromFirebaseUser(fbUser, hasCompletedOnboarding: completed);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw UnauthorizedException('Google sign-in was cancelled');
      }
      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      if (userCred.user == null) throw ServerException('No user returned');
      return _toModel(userCred.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Firebase auth error');
    }
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success || result.accessToken == null) {
        throw UnauthorizedException('Facebook sign-in was cancelled');
      }
      final credential = fb.FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      if (userCred.user == null) throw ServerException('No user returned');
      return _toModel(userCred.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Firebase auth error');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      FacebookAuth.instance.logOut(),
    ]);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) return null;
    return _toModel(fbUser);
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) return null;
      return _toModel(fbUser);
    });
  }
}
