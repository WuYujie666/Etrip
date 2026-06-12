import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/core/utils/assets.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/build_social_icon.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/core/widgets/custom_fields.dart';
import 'package:etrip/core/widgets/panda_logo.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/auth/data/logic/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({super.key});

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final SignUpController _controller = SignUpController();
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return AbsorbPointer(
      absorbing: _loading,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                PandaLogo(
                  size: SizeConfig.defaultSize! * 10,
                ),
                Text(
                  Translations.tr('app_name', lang),
                  style: TextStyle(
                    fontSize: SizeConfig.defaultSize! * 3,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const VerticalSpace(1),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.defaultSize!),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.defaultSize! * 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ListView(children: [
                        Text(" ${Translations.tr('sign_up', lang)}",
                            style: GoogleFonts.imFellFrenchCanon(
                                fontSize: 30, fontWeight: FontWeight.w500)),
                        const VerticalSpace(2),
                        CustomInputField(
                          label: Translations.tr('full_name', lang),
                          hint: Translations.tr('enter_your_name', lang),
                          controller: _controller.nameController,
                        ),
                        const VerticalSpace(1.5),
                        CustomInputField(
                          label: Translations.tr('email', lang),
                          hint: Translations.tr('enter_your_email', lang),
                          inputType: TextInputType.emailAddress,
                          controller: _controller.emailController,
                        ),
                        const VerticalSpace(1.5),
                        CustomInputField(
                          label: Translations.tr('password', lang),
                          hint: Translations.tr('enter_your_password', lang),
                          isPassword: true,
                          controller: _controller.passwordController,
                        ),
                        const VerticalSpace(1.5),
                        Row(
                          children: [
                            Expanded(
                                child: CustomInputField(
                              label: Translations.tr('country', lang),
                              hint: Translations.tr('select_country', lang),
                              isCountryPicker: true,
                              onChanged: (value) {
                                setState(() => _controller.country = value);
                              },
                            )),
                            const HorizantalSpace(2),
                            Expanded(
                                child: CustomInputField(
                              label: Translations.tr('date_of_birth', lang),
                              hint: Translations.tr('select_date_of_birth', lang),
                              isDatePicker: true,
                              onChanged: (value) {
                                setState(() => _controller.dateOfBirth = value);
                              },
                            ))
                          ],
                        ),
                        const VerticalSpace(1.5),
                        CustomInputField(
                          label: Translations.tr('gender', lang),
                          hint: Translations.tr('select_gender', lang),
                          isDropdown: true,
                          onChanged: (value) {
                            setState(() => _controller.gender = value);
                          },
                        ),
                        const VerticalSpace(2),
                        CustomGeneralButton(
                          text: _loading ? Translations.tr('loading', lang) : Translations.tr('sign_up', lang),
                          onTap: () => _controller.signUp(context, (isLoading) {
                            setState(() {
                              _loading = isLoading;
                            });
                          }),
                        ),
                        if (_loading)
                          const Center(child: CircularProgressIndicator()),
                        SizedBox(height: SizeConfig.defaultSize!),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                Translations.tr('or', lang),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpace(1.5),
                        BuildSocialIcon(
                            onTap: () {
                              _controller.loginWithGoogle(context,
                                  (isLoading) {
                                setState(() {
                                  _loading = isLoading;
                                });
                              });
                            },
                            assetPath: AssetsData.google,
                            size: SizeConfig.defaultSize! * 3),
                        const VerticalSpace(1.5),
                        Center(
                          child: GestureDetector(
                            onTap: () => GoRouter.of(context)
                                .pushReplacement(AppRouter.kSignIn),
                            child: RichText(
                              text: TextSpan(
                                text: "${Translations.tr('already_have_account', lang)} ",
                                style: GoogleFonts.inter(
                                    fontSize: 16, color: Colors.grey),
                                children: [
                                  TextSpan(
                                    text: Translations.tr('sign_in', lang),
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const VerticalSpace(2)
                      ])),
                )
              ],
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
