import 'package:flutter/material.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';
import 'package:egyptopia/features/auth/domain/respotireis/auth_repo.dart';
import 'package:egyptopia/features/auth/data/respotireis/auth_repo_impl.dart';
import 'package:go_router/go_router.dart';

class SignUpController {
  final AuthRepo _authRepo = AuthRepoImpl();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? country;
  String? dateOfBirth;
  String? gender;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signUp(BuildContext context, ValueChanged<bool> setLoading) async {
    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final userCountry = country ?? '';
    final dob = dateOfBirth ?? '';
    final userGender = gender ?? '';

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        userCountry.isEmpty ||
        dob.isEmpty ||
        userGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
      return;
    }

    setLoading(true);

    final user = EgyptopiaUser(
      id: '', // سيتم إضافة الـid بعد التسجيل عند الحاجة
      name: name,
      email: email,
      country: userCountry,
      dateOfBirth: dob,
      gender: userGender,
      photoUrl: null,
    );

    final result = await _authRepo.signUpWithEmail(user, password);

    setLoading(false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red[800],
          ),
        );
      },
      (userCredential) {
        if (userCredential == null) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Verify Your Email'),
              content: const Text(
                  'A verification email has been sent. Please check your inbox and verify your email address before logging in.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    GoRouter.of(context).pushReplacement(AppRouter.kSignIn);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign up was successful!')),
          );
        }
      },
    );
  }

   Future<void> loginWithGoogle(BuildContext context, ValueChanged<bool> setLoading) async {
    setLoading(true);

    final result = await _authRepo.loginWithGoogle();

    setLoading(false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red[800],
          ),
        );
      },
      (userCredential) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in with Google successful!')),
        );
        GoRouter.of(context).pushReplacement(AppRouter.kScreens); 
      },
    );
  }
}