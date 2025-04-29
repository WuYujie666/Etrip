import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/build_social_icon.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/custom_fields.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/auth/data/logic/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final SignInController _controller = SignInController();
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
      child: SingleChildScrollView(
        child: Container(
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
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.defaultSize!,
                    vertical: SizeConfig.defaultSize! * 2),
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
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(" Sign in",
                          style: GoogleFonts.imFellFrenchCanon(
                              fontSize: 30, fontWeight: FontWeight.w500)),
                      const VerticalSpace(2),
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
                      const VerticalSpace(2),
                      CustomGeneralButton(
                        text: _loading ? "Processing..." : "Sign in",
                        onTap: ()=> _controller.signIn(context,  (isLoading) {
                    setState(() {
                      _loading = isLoading;
                    });
                  },
                ),
              ),
                      if (_loading)
                        const Center(child: CircularProgressIndicator()),
                      SizedBox(height: SizeConfig.defaultSize!),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            GoRouter.of(context).push(AppRouter.kForgetPassword);
                          },
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.inter(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.grey,
                              fontSize: SizeConfig.defaultSize! * 1.6,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpace(1),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              .pushReplacement(AppRouter.kSignUp),
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.inter(
                                  fontSize: 16, color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: "Sign up",
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
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
