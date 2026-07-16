import '../../../../core/constants/app_constants.dart';
import '../../../../core/local/local_storage_service.dart';
import '../../../../core/network/api_exception.dart';
import '../models/user_preferences_model.dart';

/// Named "remote" for interface-compatibility with the rest of the app's
/// data-source naming convention, but this persists to on-device storage
/// only (no backend). Also flips the onboarding-complete flag that
/// [AuthRemoteDataSourceImpl] reads on next launch.
abstract class PreferencesRemoteDataSource {
  Future<void> savePreferences(String uid, List<String> interests);
  Future<UserPreferencesModel> getPreferences(String uid);
}

class PreferencesRemoteDataSourceImpl implements PreferencesRemoteDataSource {
  final LocalStorageService _localStorage;
  PreferencesRemoteDataSourceImpl({LocalStorageService? localStorage})
      : _localStorage = localStorage ?? LocalStorageService();

  @override
  Future<void> savePreferences(String uid, List<String> interests) async {
    try {
      final model = UserPreferencesModel(interests: interests);
      await _localStorage.setString(
        AppConstants.interestsKey(uid),
        model.toJsonString(),
      );
      await _localStorage.setBool(AppConstants.onboardingCompleteKey(uid), true);
    } catch (e) {
      throw ServerException('Failed to save preferences: $e');
    }
  }

  @override
  Future<UserPreferencesModel> getPreferences(String uid) async {
    try {
      final raw = await _localStorage.getString(AppConstants.interestsKey(uid));
      if (raw == null) return const UserPreferencesModel(interests: []);
      return UserPreferencesModel.fromJsonString(raw);
    } catch (e) {
      throw ServerException('Failed to load preferences: $e');
    }
  }
}
