import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/bamboo_texture.dart';
import 'package:etrip/core/widgets/panda_logo.dart';
import 'package:etrip/core/constants.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:go_router/go_router.dart';

class RegistrationBody extends StatelessWidget {
  const RegistrationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: SizeConfig.screenHeight! * 0.73,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(SizeConfig.defaultSize! * 14),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: kMainColor,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.defaultSize! * 2,
            horizontal: SizeConfig.defaultSize! * 3,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                Translations.tr('start_discover', context.watch<LocaleCubit>().state.languageCode),
                textAlign: TextAlign.center,
                style: GoogleFonts.imFellFrenchCanon(
                  fontSize: SizeConfig.defaultSize! * 1.8,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2544),
                ),
              ),
              const VerticalSpace(2),
              Row(
                children: [
                  Expanded(
                    child: CustomGeneralButton(
                      text: Translations.tr('sign_up', context.watch<LocaleCubit>().state.languageCode),
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kSignUp);
                      },
                    ),
                  ),
                  const HorizantalSpace(1),
                  Expanded(
                    child: CustomGeneralButton(
                      text: Translations.tr('sign_in', context.watch<LocaleCubit>().state.languageCode),
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kSignIn);
                      },
                    ),
                  ),
                ],
              ),
              const VerticalSpace(1),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go(AppRouter.kScreens);
                },
                child: Text(
                  Translations.tr('skip_now', context.watch<LocaleCubit>().state.languageCode),
                  style: GoogleFonts.inter(
                    decoration: TextDecoration.underline,
                    fontSize: SizeConfig.defaultSize! * 1.6,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: SizeConfig.defaultSize! * 15,
          left: 0,
          right: 0,
          child: Column(
            children: [
              PandaLogo(
                size: SizeConfig.defaultSize! * 13,
              ),
              const VerticalSpace(1),
              Text(
                "Etrip",
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 4.8,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const VerticalSpace(7),
              const BambooTexture(),
            ],
          ),
        ),
      ],
    );
  }
}
