// ignore_for_file: use_build_context_synchronously

import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/core/widgets/custom_card.dart';
import 'package:etrip/core/widgets/language_dialog.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/Profile/bloc/user_bloc.dart';
import 'package:etrip/features/Profile/bloc/user_event.dart';
import 'package:etrip/features/Profile/presentation/views/widgets/profile_image.dart';
import 'package:etrip/features/auth/data/models/egyptopia_user.dart';
import 'package:etrip/features/auth/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key, required this.user});
  final EgyptopiaUser user;
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state;
    final lang = locale.languageCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpace(10),
        Row(
          children: [
            const HorizantalSpace(2),
            ProfileImage(
              imageUrl: user.profileImg,
              userId: user.id,
              onImageChanged: (_) {
                context.read<UserBloc>().add(LoadUser(user.id));
              },
            ),
            const HorizantalSpace(3),
            Column(
              children: [
                Text(
                  user.name,
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  user.email,
                  style: GoogleFonts.inter(
                      color: const Color(0xFF8E8E8E),
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
                CustomJoinButton(
                  text: Translations.tr('edit_profile', lang),
                  onTap: () {
                    GoRouter.of(context)
                        .push(AppRouter.kEditProfile, extra: user);
                  },
                  fontSize: 11,
                  minimumSize: const Size(90, 30),
                )
              ],
            ),
          ],
        ),
        const VerticalSpace(2),
        CustomCard(
            icon: const Icon(Icons.favorite_border),
            text: Translations.tr('favourites', lang),
            onTap: () {
              GoRouter.of(context).push(AppRouter.kWishList);
            }),
        CustomCard(
            icon: const Icon(Icons.account_box_outlined),
            text: Translations.tr('about_me', lang),
            onTap: () {
              GoRouter.of(context).push(AppRouter.kAboutMe, extra: user);
            }),
        CustomCard(
          icon: const Icon(Icons.language),
          text: Translations.tr('language', lang),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const LanguageDialog(),
            );
          },
        ),
        CustomCard(
            icon: const Icon(Icons.vpn_key_outlined),
            text: Translations.tr('change_password', lang),
            onTap: () {
              GoRouter.of(context).push(AppRouter.kCreateNewPassword);
            }),
        CustomCard(
          icon: const Icon(Icons.logout),
          text: Translations.tr('log_out', lang),
          onTap: () async {
            await LocalStorageService().logout();
            context.read<UserBloc>().add(LogoutUser());
            GoRouter.of(context).pushReplacement(AppRouter.kSignIn);
          },
        ),
      ],
    );
  }
}
