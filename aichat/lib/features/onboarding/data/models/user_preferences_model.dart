import 'dart:convert';
import '../../domain/entities/user_preferences_entity.dart';

class UserPreferencesModel extends UserPreferencesEntity {
  const UserPreferencesModel({required super.interests, super.updatedAt});

  factory UserPreferencesModel.fromJsonString(String jsonStr) {
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    return UserPreferencesModel(
      interests: List<String>.from(json['interests'] as List? ?? []),
      updatedAt:
          json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'] as String) : null,
    );
  }

  String toJsonString() {
    return jsonEncode({
      'interests': interests,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}
