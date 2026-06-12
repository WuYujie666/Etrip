// ignore_for_file: use_build_context_synchronously
import 'package:etrip/features/Profile/bloc/user_bloc.dart';
import 'package:etrip/features/Profile/bloc/user_event.dart';
import 'package:flutter/material.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/features/auth/data/models/egyptopia_user.dart';
import 'package:etrip/features/auth/domain/respotireis/auth_repo.dart';
import 'package:etrip/features/auth/data/respotireis/auth_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';

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

  Future<void> signUp(
      BuildContext context, ValueChanged<bool> setLoading) async {
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
        SnackBar(
            content: Text(
          Translations.tr('please_fill_all_fields', context.read<LocaleCubit>().state.languageCode),
          style: GoogleFonts.lato(),
        )),
      );
      return;
    }

    setLoading(true);

    final result = await _authRepo.signUpWithEmail(
      EgyptopiaUser(
        id: '',
        name: name,
        email: email,
        country: userCountry,
        dateOfBirth: dob,
        gender: userGender,
        profileImg: null,
      ),
      password,
    );

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
      (user) async {
        context.read<UserBloc>().add(LoadUser(user.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            Translations.tr('sign_up_successful', context.read<LocaleCubit>().state.languageCode),
            style: GoogleFonts.lato(),
          )),
        );
        GoRouter.of(context).pushReplacement(AppRouter.kScreens);
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
    }, (user) async {
      context.read<UserBloc>().add(LoadUser(user.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(Translations.tr('google_sign_in_successful', context.read<LocaleCubit>().state.languageCode),
                style: GoogleFonts.lato())),
      );
      GoRouter.of(context).pushReplacement(AppRouter.kScreens);
    });
  }
}
