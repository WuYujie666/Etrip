import 'package:etrip/features/auth/data/models/egyptopia_user.dart';
import 'package:etrip/features/auth/data/services/local_storage_service.dart';

class FirestoreUserService {
  final LocalStorageService _storage = LocalStorageService();

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    String? country,
    String? dateOfBirth,
    String? gender,
  }) async {
    await _storage.createUserProfile(
      uid: uid,
      name: name,
      email: email,
      country: country,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );
  }

  EgyptopiaUser? getUserProfile(String uid) {
    return _storage.getUserProfile(uid);
  }

  Future<void> updateUserProfile(EgyptopiaUser user) async {
    await _storage.updateUserProfile(user);
  }
}
