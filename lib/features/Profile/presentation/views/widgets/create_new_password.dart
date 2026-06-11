// ignore_for_file: use_build_context_synchronously

import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/custom_fields.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/features/auth/data/services/local_storage_service.dart';
import 'package:etrip/features/onbording/presentation/views/widgets/page_view_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String lang,
  }) async {
    try {
      final uid = LocalStorageService().currentUid;
      if (uid == null) return Translations.tr('no_user_logged_in', lang);

      await LocalStorageService().changePassword(uid, currentPassword, newPassword);
      return null;
    } catch (e) {
      if (e.toString().contains('旧密码不正确')) {
        return Translations.tr('old_password_incorrect', lang);
      }
      return e.toString();
    }
  }

  void onChangePasswordTap(BuildContext context) async {
    final lang = context.read<LocaleCubit>().state.languageCode;
    final oldPw = oldPasswordController.text.trim();
    final newPw = newPasswordController.text.trim();
    final confirmPw = confirmPasswordController.text.trim();

    if (oldPw.isEmpty || newPw.isEmpty || confirmPw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.tr('please_enter_all_fields', lang))),
      );
      return;
    }
    if (newPw != confirmPw) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.tr('passwords_dont_match', lang))),
      );
      return;
    }
    setState(() => _loading = true);

    final error =
        await changePassword(currentPassword: oldPw, newPassword: newPw, lang: lang);
    setState(() => _loading = false);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Translations.tr('password_changed', lang))),
      );
      GoRouter.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return ReusableScreen(
      showBackButton: true,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
              child: Column(
                children: [
                  const VerticalSpace(4),
                  Text(
                    Translations.tr('create_new_password', lang),
                    style: GoogleFonts.imFellFrenchCanon(
                      fontSize: SizeConfig.defaultSize! * 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const VerticalSpace(2),
                  PageViewItem(
                    image: 'assets/images/new1.png',
                    title: Translations.tr('new_password_must_differ', lang),
                    subTitle: '',
                    titleFontSize: 18,
                    subTitleFontSize: 1,
                  ),
                  CustomInputField(
                    controller: oldPasswordController,
                    label: Translations.tr('old_password', lang),
                    hint: Translations.tr('enter_old_password', lang),
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  const VerticalSpace(2),
                  CustomInputField(
                    controller: newPasswordController,
                    label: Translations.tr('new_password', lang),
                    hint: Translations.tr('enter_new_password', lang),
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  const VerticalSpace(2),
                  CustomInputField(
                    controller: confirmPasswordController,
                    label: Translations.tr('confirm_new_password', lang),
                    hint: Translations.tr('reenter_password', lang),
                    inputType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CustomGeneralButton(
                      text: _loading ? Translations.tr('loading', lang) : Translations.tr('confirm', lang),
                      onTap:
                          _loading ? null : () => onChangePasswordTap(context),
                    ),
                  ),
                ],
              ),
            ),
            if (_loading)
              Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
