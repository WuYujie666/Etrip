// import 'dart:convert';
import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';
import 'package:egyptopia/features/auth/domain/respotireis/auth_repo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
// import 'package:http/http.dart' as http;

class AuthRepoImpl extends AuthRepo {
  @override
  Future<Either<Exception, UserCredential>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return Left(Exception('Google sign-in was cancelled.'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // // اتأكد إذا كان اليوزر جديد (أول تسجيل) من خلال API
        // final response = await http.get(
        //   Uri.parse('https://yourapi.com/users/${user.uid}'),
        // );

        // if (response.statusCode == 404) {
        //   // أول دخول: ابعت بيانات المستخدم للـ API الخاص بك
        //   EgyptopiaUser egyptopiaUser = EgyptopiaUser(
        //     id: user.uid,
        //     name: user.displayName ?? '',
        //     email: user.email ?? '',
        //     country: '',
        //     dateOfBirth: '',
        //     gender: '',
        //     photoUrl: user.photoURL,
        //   );

        //   await http.post(
        //     Uri.parse('https://yourapi.com/users'),
        //     headers: {'Content-Type': 'application/json'},
        //     body: json.encode(egyptopiaUser.toMap()),
        //   );
        // }
      }

      return Right(userCredential);
    } catch (e) {
      return Left(Exception('Error during Google Sign-In: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, UserCredential?>> signUpWithEmail(
    EgyptopiaUser user,
    String signUpPassword,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: signUpPassword,
      );

      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        EgyptopiaUser newUser = EgyptopiaUser(
          id: firebaseUser.uid,
          name: user.name,
          email: user.email,
          country: user.country,
          dateOfBirth: user.dateOfBirth,
          gender: user.gender,
          photoUrl: user.photoUrl,
        );

        // await http.post(
        //   Uri.parse('https://yourapi.com/users'),
        //   headers: {'Content-Type': 'application/json'},
        //   body: json.encode(newUser.toMap()),
        // );

        // ابعت verification email وسجّل خروج لو عايز
        if (!firebaseUser.emailVerified) {
          await firebaseUser.sendEmailVerification();
          await FirebaseAuth.instance.signOut();
          return const Right(null);
        }
        return Right(userCredential);
      }

      return Left(Exception("Sign up failed, please try again."));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Left(Exception(
            'There is an account actually associated with this email.'));
      } else {
        return Left(Exception(e.message ?? 'An error happened'));
      }
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, UserCredential>> loginWithEmail(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        await FirebaseAuth.instance.signOut();
        return Left(Exception("Please verify your email before logging in."));
      }

      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(Exception('There is no account with this e-mail!'));
      } else if (e.code == 'wrong-password') {
        return Left(Exception('The password is incorrect!'));
      } else {
        return Left(Exception(e.message ?? 'An error happened'));
      }
    }
  }
}
