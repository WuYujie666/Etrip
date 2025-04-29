import 'package:flutter/material.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/features/auth/domain/respotireis/auth_repo.dart';
import 'package:egyptopia/features/auth/data/respotireis/auth_repo_impl.dart';
import 'package:go_router/go_router.dart';

class SignInController {
  final AuthRepo _authRepo = AuthRepoImpl();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signIn(BuildContext context, ValueChanged<bool> setLoading) async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
      return;
    }

    setLoading(true);

    final result = await _authRepo.loginWithEmail(email, password);

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
          const SnackBar(content: Text('Sign in successful!')),
        );
        GoRouter.of(context).pushReplacement(AppRouter.kScreens);
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