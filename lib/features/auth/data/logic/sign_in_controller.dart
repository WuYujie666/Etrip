// ignore_for_file: use_build_context_synchronously

import 'package:egyptopia/features/Profile/bloc/user_bloc.dart';
import 'package:egyptopia/features/Profile/bloc/user_event.dart';
import 'package:flutter/material.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/features/auth/domain/respotireis/auth_repo.dart';
import 'package:egyptopia/features/auth/data/respotireis/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInController {
  final AuthRepo _authRepo = AuthRepoImpl();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> signIn(
      BuildContext context, ValueChanged<bool> setLoading) async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Please fill all fields!', style: GoogleFonts.lato())),
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
            content: Text(failure.toString().replaceAll('Exception: ', ''),
                style: GoogleFonts.lato()),
            backgroundColor: Colors.red[800],
          ),
        );
      },
      (userCredential) async {
        final user = userCredential.user;
        if (user != null) {
          context.read<UserBloc>().add(LoadUser(user.uid));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Sign in successful! ✅', style: GoogleFonts.lato())),
          );
          GoRouter.of(context).pushReplacement(AppRouter.kScreens);
        }
      },
    );
  }

  Future<void> loginWithGoogle(
      BuildContext context, ValueChanged<bool> setLoading) async {
    setLoading(true);

    final result = await _authRepo.loginWithGoogle();

    setLoading(false);

    result.fold((failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.toString().replaceAll('Exception: ', ''),
              style: GoogleFonts.lato()),
          backgroundColor: Colors.red[800],
        ),
      );
    }, (userCredential) async {
      final user = userCredential.user;
      if (user != null) {
        context.read<UserBloc>().add(LoadUser(user.uid));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Sign in with Google successful ✅',
                  style: GoogleFonts.lato())),
        );
        GoRouter.of(context).pushReplacement(AppRouter.kScreens);
      }
    });
  }

  Future<void> sendPasswordReset(
      BuildContext context, String email, ValueChanged<bool> setLoading) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Please enter your email!", style: GoogleFonts.lato())),
      );
      return;
    }
    setLoading(true);
    final result = await _authRepo.sendPasswordResetEmail(email);

    setLoading(false);
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  failure
                      .toString()
                      .replaceAll('Exception: ', '')
                      .toUpperCase(),
                  style: GoogleFonts.lato())),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "If That Email Exists, A Password Reset Email Has Been Sent ✅",
                  style: GoogleFonts.lato())),
        );
        GoRouter.of(context).pop();
      },
    );
  }
}
