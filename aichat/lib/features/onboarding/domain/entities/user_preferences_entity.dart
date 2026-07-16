import 'package:equatable/equatable.dart';

class UserPreferencesEntity extends Equatable {
  final List<String> interests;
  final DateTime? updatedAt;

  const UserPreferencesEntity({required this.interests, this.updatedAt});

  @override
  List<Object?> get props => [interests, updatedAt];
}
