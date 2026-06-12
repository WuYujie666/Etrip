// ignore_for_file: use_build_context_synchronously
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:etrip/core/constants.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/core/utils/assets.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/auth/data/egyptopia_api_service.dart';
import 'package:etrip/features/auth/data/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class PreferenceOne extends StatefulWidget {
  const PreferenceOne({super.key});

  @override
  State<PreferenceOne> createState() => _PreferenceOneState();
}

class _PreferenceOneState extends State<PreferenceOne> {
  final List<String> categories = [
    "Monastery",
    "Temple",
    "Historical Site",
    "Mosque",
    "Water Park",
    "Church",
    "Museum",
    "Cultural Center",
    "Island",
    "Mountain",
    "Natural Reserve",
    "Tomb",
    "Beach",
    "Shopping",
    "Fortress",
    "Palace",
    "Library",
    "Tower",
    "Hot Spring",
    "Garden",
    "Theme Park",
    "Rehabilitation & Wellness Center",
    "Aquarium",
    "Healing Oases & Sand Therapy",
    "Theater",
    "Synagogue",
    "Zoo"
  ];

  List<int> selectedIndexes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final userId = LocalStorageService().currentUid ?? '';
    if (userId.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await EgyptopiaApiService().getUserPreferences(userId);
      if (prefs != null) {
        final savedCategories = List<String>.from(prefs['category'] ?? []);
        setState(() {
          selectedIndexes = categories
              .asMap()
              .entries
              .where((entry) => savedCategories.contains(entry.value))
              .map((entry) => entry.key)
              .toList();
        });
      }
    } catch (e) {
      final lang = context.read<LocaleCubit>().state.languageCode;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.tr('failed_load_preferences', lang) + e.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return ReusableScreen(
      gradientStops: const [0.1, 0.9],
      backgroundColor: kSecondaryColor,
      imageColor: Colors.black,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 30),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translations.tr('how_spend_time', lang),
                    style: TextStyle(
                      fontSize: SizeConfig.defaultSize! * 3,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          offset: Offset(3, 3),
                          blurRadius: 4,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(1.5),
                  Image.asset(
                    AssetsData.spacer,
                    width: double.infinity,
                  ),
                  const VerticalSpace(1.5),
                  Text(
                    Translations.tr('choose_many', lang),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 19,
                    ),
                  ),
                  const VerticalSpace(1.5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(categories.length, (index) {
                          bool isSelected = selectedIndexes.contains(index);
                          return TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              backgroundColor: Colors.transparent,
                              foregroundColor: const Color(0xFF1F2544),
                              side: BorderSide(
                                color: isSelected ? Colors.black : Colors.white,
                                width: 2.5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                if (isSelected) {
                                  selectedIndexes.remove(index);
                                } else {
                                  selectedIndexes.add(index);
                                }
                              });
                            },
                            child: Text(
                              categories[index],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const VerticalSpace(1),
                  CustomGeneralButton(
                    text: Translations.tr('next', lang),
                    onTap: () {
                      if (selectedIndexes.isNotEmpty) {
                        final selectedCategories = selectedIndexes
                            .map((index) => categories[index])
                            .toList();
                        GoRouter.of(context).push(
                          AppRouter.kPreferenceTwo,
                          extra: {'categories': selectedCategories},
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(Translations.tr('please_choose_one', lang)),
                            backgroundColor: Colors.black,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
      ),
    );
  }
}
