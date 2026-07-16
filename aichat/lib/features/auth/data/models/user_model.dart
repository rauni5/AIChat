import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user_entity.dart';

/// Data-layer model. Knows how to build itself from a Firebase Auth user.
/// `hasCompletedOnboarding` is not part of Firebase's user object — it's
/// read separately from local storage and passed in here.
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.email,
    super.displayName,
    super.photoUrl,
    super.hasCompletedOnboarding,
  });

  factory UserModel.fromFirebaseUser(
    fb.User user, {
    bool hasCompletedOnboarding = false,
  }) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      hasCompletedOnboarding: hasCompletedOnboarding,
    );
  }

  UserModel copyWith({bool? hasCompletedOnboarding}) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}
