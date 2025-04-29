import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/build_social_icon.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/custom_fields.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/auth/data/logic/sign_up_controller.dart';
import 'package:flutter/material.dart';
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
    return AbsorbPointer(
      absorbing: _loading,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Image.asset(
                  AssetsData.logo,
                  height: SizeConfig.defaultSize! * 10,
                ),
                Text(
                  "Egyptopia",
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
                            color: Colors.black.withValues(alpha:0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ListView(children: [
                        Text(" Sign up",
                            style: GoogleFonts.imFellFrenchCanon(
                                fontSize: 30, fontWeight: FontWeight.w500)),
                        const VerticalSpace(2),
                        CustomInputField(
                          label: "Full Name",
                          hint: "Enter Your Name",
                          controller: _controller.nameController,
                        ),
                        const VerticalSpace(1.5),
                        CustomInputField(
                          label: "Email",
                          hint: "Enter Your Email",
                          inputType: TextInputType.emailAddress,
                          controller: _controller.emailController,
                        ),
                        const VerticalSpace(1.5),
                        CustomInputField(
                          label: "Password",
                          hint: "Enter Your Password",
                          isPassword: true,
                          controller: _controller.passwordController,
                        ),
                        const VerticalSpace(1.5),
                        Row(
                          children: [
                            Expanded(
                                child: CustomInputField(
                              label: "Country",
                              hint: "Select Country",
                              isCountryPicker: true,
                              onChanged: (value) {
                                setState(() => _controller.country = value);
                              },
                            )),
                            const HorizantalSpace(2),
                            Expanded(
                                child: CustomInputField(
                              label: "Date Of Birth",
                              hint: "Select Date Of Birth",
                              isDatePicker: true,
                              onChanged: (value) {
                                setState(() => _controller.dateOfBirth = value);
                              },
                            ))
                          ],
                        ),
                        const VerticalSpace(1.5),
                        CustomInputField(
                          label: "Gender",
                          hint: "Select Gender",
                          isDropdown: true,
                          onChanged: (value) {
                            setState(() => _controller.gender = value);
                          },
                        ),
                        const VerticalSpace(2),
                        CustomGeneralButton(
                          text: _loading ? "Processing..." : "Sign up",
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
                                "OR",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BuildSocialIcon(
                                assetPath: AssetsData.fblogo,
                                size: SizeConfig.defaultSize! * 3),
                            const HorizantalSpace(2),
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
                            const HorizantalSpace(2),
                            BuildSocialIcon(
                                assetPath: AssetsData.insta,
                                size: SizeConfig.defaultSize! * 3),
                          ],
                        ),
                        const VerticalSpace(1.5),
                        Center(
                          child: GestureDetector(
                            onTap: () => GoRouter.of(context)
                                .pushReplacement(AppRouter.kSignIn),
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: GoogleFonts.inter(
                                    fontSize: 16, color: Colors.grey),
                                children: [
                                  TextSpan(
                                    text: "Sign in",
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
