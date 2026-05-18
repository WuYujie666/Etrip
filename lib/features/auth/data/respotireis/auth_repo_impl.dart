import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';
import 'package:egyptopia/features/auth/domain/respotireis/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  Future<Either<Exception, UserCredential>> loginWithGoogle() async {
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      return Right(credential);
    } catch (e) {
      return Left(Exception('Google sign-in unavailable in offline mode.'));
    }
  }

  @override
  Future<Either<Exception, UserCredential?>> signUpWithEmail(
    EgyptopiaUser user,
    String signUpPassword,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: signUpPassword,
      );

      final firebaseUser = credential.user;
      if (firebaseUser != null) {
        // Auto-verify the email so login works immediately
        await firebaseUser.verifyBeforeUpdateEmail(firebaseUser.email!);
        return Right(credential);
      }

      return Left(Exception("Sign up failed, Please try again."));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Left(Exception(
            '⚠️ There Is An Account Actually Associated With This Email.'));
      } else {
        return Left(Exception(e.message ?? '⚠️ An error happened'));
      }
    } on Exception catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, UserCredential>> loginWithEmail(
      String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return Left(Exception('❌ No Account Found With This Email.'));
        case 'wrong-password':
          return Left(Exception('❌ The Password Is Incorrect.'));
        case 'invalid-email':
          return Left(Exception('⚠️ The Email Address Is Badly Formatted.'));
        case 'invalid-credential':
          return Left(Exception(
              "❌ This Email Doesn't Exist or The Password Is Incorrect"));
        default:
          return Left(Exception('❗ Firebase error: ${e.code}'));
      }
    }
  }

  @override
  Future<Either<Exception, void>> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(Exception('⚠️ No Account Found With This Email!'));
      } else {
        return Left(Exception(e.message ?? '⚠️ An Error Occurred!'));
      }
    } catch (e) {
      return Left(Exception('⚠️ An Error Occurred!'));
    }
  }

  @override
  Future<Either<Exception, void>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        return Left(Exception("No user logged in"));
      }
      final cred = EmailAuthProvider.credential(
          email: user.email!, password: oldPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return Left(Exception("Old password is incorrect!"));
      }
      return Left(Exception(e.message ?? "Error changing password"));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
