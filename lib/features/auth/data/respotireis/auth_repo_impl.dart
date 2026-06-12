import 'package:etrip/features/auth/data/services/local_storage_service.dart';
import 'package:etrip/features/auth/data/models/egyptopia_user.dart';
import 'package:etrip/features/auth/domain/respotireis/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl extends AuthRepo {
  final LocalStorageService _storage = LocalStorageService();

  @override
  Future<Either<Exception, EgyptopiaUser>> loginWithGoogle() async {
    return Left(Exception('Google登录暂不支持'));
  }

  @override
  Future<Either<Exception, EgyptopiaUser>> signUpWithEmail(
    EgyptopiaUser user,
    String signUpPassword,
  ) async {
    try {
      final createdUser = await _storage.register(
        name: user.name,
        email: user.email,
        password: signUpPassword,
        country: user.country,
        dateOfBirth: user.dateOfBirth,
        gender: user.gender,
      );
      return Right(createdUser);
    } on Exception catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, EgyptopiaUser>> loginWithEmail(
      String email, String password) async {
    try {
      final user = await _storage.login(email, password);
      if (user == null) {
        return Left(Exception('邮箱或密码错误'));
      }
      return Right(user);
    } on Exception catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> sendPasswordResetEmail(String email) async {
    if (!_storage.checkEmailExists(email)) {
      return Left(Exception('该邮箱未注册'));
    }
    return const Right(null);
  }

  @override
  Future<Either<Exception, void>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final uid = _storage.currentUid;
      if (uid == null) return Left(Exception('用户未登录'));
      await _storage.changePassword(uid, oldPassword, newPassword);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
