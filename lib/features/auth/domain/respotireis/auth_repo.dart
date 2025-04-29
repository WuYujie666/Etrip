import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';

abstract class AuthRepo {
  Future<Either<Exception, UserCredential>> loginWithEmail(
      String loginEmail, String loginPassword);

  Future<Either<Exception, UserCredential?>> signUpWithEmail(
    EgyptopiaUser user,
    String signUpPassword,
  );

  Future<Either<Exception, UserCredential>> loginWithGoogle();
}