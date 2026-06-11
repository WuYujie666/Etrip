import 'package:hive_flutter/hive_flutter.dart';
import 'package:etrip/features/auth/data/models/egyptopia_user.dart';
import 'dart:convert';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._();
  factory LocalStorageService() => _instance;
  LocalStorageService._();

  static const String _usersBox = 'local_users';
  static const String _credentialsBox = 'local_credentials';
  static const String _sessionBox = 'local_session';

  static Future<void> init() async {
    await Hive.openBox(_usersBox);
    await Hive.openBox(_credentialsBox);
    await Hive.openBox(_sessionBox);
  }

  Box get _users => Hive.box(_usersBox);
  Box get _credentials => Hive.box(_credentialsBox);
  Box get _session => Hive.box(_sessionBox);

  String? get currentUid => _session.get('current_uid');

  bool get isLoggedIn => _session.get('current_uid') != null;

  Future<EgyptopiaUser> register({
    required String name,
    required String email,
    required String password,
    String? country,
    String? dateOfBirth,
    String? gender,
  }) async {
    if (_credentials.containsKey(email)) {
      throw Exception('邮箱已被注册');
    }

    final uid = email;
    final user = EgyptopiaUser(
      id: uid,
      name: name,
      email: email,
      country: country ?? '',
      dateOfBirth: dateOfBirth ?? '',
      gender: gender ?? '',
    );

    await _credentials.put(email, {
      'uid': uid,
      'password': base64Encode(utf8.encode(password)),
    });
    await _users.put(uid, user.toMap());
    await _session.put('current_uid', uid);

    return user;
  }

  Future<EgyptopiaUser?> login(String email, String password) async {
    final cred = _credentials.get(email);
    if (cred == null) return null;

    final storedPw = cred['password'] as String;
    if (storedPw != base64Encode(utf8.encode(password))) return null;

    final uid = cred['uid'] as String;
    await _session.put('current_uid', uid);
    return getUserProfile(uid);
  }

  Future<void> logout() async {
    await _session.delete('current_uid');
  }

  Future<void> changePassword(
      String email, String oldPassword, String newPassword) async {
    final cred = _credentials.get(email);
    if (cred == null) throw Exception('用户不存在');

    final storedPw = cred['password'] as String;
    if (storedPw != base64Encode(utf8.encode(oldPassword))) {
      throw Exception('旧密码不正确');
    }

    await _credentials.put(email, {
      'uid': cred['uid'],
      'password': base64Encode(utf8.encode(newPassword)),
    });
  }

  bool checkEmailExists(String email) => _credentials.containsKey(email);

  EgyptopiaUser? getUserProfile(String uid) {
    final data = _users.get(uid);
    if (data == null) return null;
    return EgyptopiaUser.fromMap(Map<String, dynamic>.from(data));
  }

  Future<void> updateUserProfile(EgyptopiaUser user) async {
    await _users.put(user.id, user.toMap());
  }

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    String? country,
    String? dateOfBirth,
    String? gender,
  }) async {
    await _users.put(uid, {
      'id': uid,
      'name': name,
      'email': email,
      'country': country ?? '',
      'date_of_birth': dateOfBirth ?? '',
      'gender': gender ?? '',
      'profile_img': null,
      'preferred_categories': <String>[],
      'preferred_tourism_types': <String>[],
      'preferred_cities': <String>[],
    });
  }
}
