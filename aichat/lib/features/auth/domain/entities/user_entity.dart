import 'package:equatable/equatable.dart';

/// Pure Dart entity — no Firebase, no JSON. This is what Domain and
/// Presentation work with; Data is responsible for producing it.
class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool hasCompletedOnboarding;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.hasCompletedOnboarding = false,
  });

  @override
  List<Object?> get props =>
      [uid, email, displayName, photoUrl, hasCompletedOnboarding];
}
