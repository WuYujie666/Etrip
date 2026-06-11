import 'package:dartz/dartz.dart';
import 'package:etrip/features/auth/data/models/egyptopia_user.dart';

abstract class AuthRepo {
  Future<Either<Exception, EgyptopiaUser>> loginWithEmail(
      String loginEmail, String loginPassword);

  Future<Either<Exception, EgyptopiaUser>> signUpWithEmail(
    EgyptopiaUser user,
    String signUpPassword,
  );

  Future<Either<Exception, EgyptopiaUser>> loginWithGoogle();

  Future<Either<Exception, void>> sendPasswordResetEmail(String email);

  Future<Either<Exception, void>> changePassword(String oldPassword, String newPassword);
}
