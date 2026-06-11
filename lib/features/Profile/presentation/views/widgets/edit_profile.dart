import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/core/widgets/custom_fields.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/Profile/bloc/user_bloc.dart';
import 'package:etrip/features/Profile/bloc/user_event.dart';
import 'package:etrip/features/Profile/bloc/user_state.dart';
import 'package:etrip/features/Profile/presentation/views/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:etrip/features/auth/data/models/egyptopia_user.dart';
import 'package:etrip/features/auth/data/services/firestore_user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';

class EditProfile extends StatefulWidget {
  final EgyptopiaUser user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController countryController;
  late TextEditingController genderController;
  late TextEditingController dateOfBirthController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
    countryController = TextEditingController(text: widget.user.country ?? '');
    genderController = TextEditingController(text: widget.user.gender ?? '');
    dateOfBirthController =
        TextEditingController(text: widget.user.dateOfBirth ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      EgyptopiaUser currentUser = widget.user;
      if (state is UserLoaded) currentUser = state.user;

      return ReusableScreen(
        imageColor: const Color(0xFF999EB9),
        backgroundColor: const [Colors.white, Colors.white],
        showBackButton: true,
        iconColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                  child: Text(
                Translations.tr('edit_profile', lang),
                style: GoogleFonts.inter(
                    color: const Color(0xFF1F2544),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
              const VerticalSpace(1),
              ProfileImage(
                imageUrl: currentUser.profileImg,
                userId: currentUser.id,
                onImageChanged: (_) async {
                  context.read<UserBloc>().add(LoadUser(currentUser.id));
                },
              ),
              const VerticalSpace(1),
              CustomInputField(
                label: Translations.tr('email_cant_edit', lang),
                hint: "",
                controller: TextEditingController(text: currentUser.email),
                enabled: false,
              ),
              const VerticalSpace(1),
              CustomInputField(
                label: Translations.tr('name', lang),
                hint: Translations.tr('enter_your_name', lang),
                controller: nameController,
              ),
              const VerticalSpace(1),
              CustomInputField(
                controller: countryController,
                label: Translations.tr('country', lang),
                hint: countryController.text,
                onChanged: (val) {
                  countryController.text = val;
                },
                isCountryPicker: true,
              ),
              const VerticalSpace(1),
              CustomInputField(
                label: Translations.tr('gender', lang),
                hint: genderController.text,
                controller: genderController,
                onChanged: (val) {
                  genderController.text = val;
                },
                isDropdown: true,
              ),
              const VerticalSpace(1),
              CustomInputField(
                label: Translations.tr('date_of_birth', lang),
                hint: dateOfBirthController.text,
                controller: dateOfBirthController,
                onChanged: (val) {
                  dateOfBirthController.text = val;
                },
                isDatePicker: true,
              ),
              const VerticalSpace(1),
              CustomGeneralButton(
                  onTap: () async {
                    final updatedUser = EgyptopiaUser(
                      id: currentUser.id,
                      email: currentUser.email,
                      name: nameController.text.trim(),
                      country: countryController.text.trim(),
                      gender: genderController.text.trim(),
                      dateOfBirth: dateOfBirthController.text.trim(),
                      profileImg: currentUser.profileImg,
                    );
                    await FirestoreUserService()
                        .updateUserProfile(updatedUser);
                    context.read<UserBloc>().add(UpdateUser(updatedUser));
                    GoRouter.of(context).pop();
                  },
                  text: Translations.tr('save_changes', lang)),
            ],
          ),
        ),
      );
    });
  }
}
