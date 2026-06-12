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

class PreferenceTwo extends StatefulWidget {
  const PreferenceTwo({super.key});

  @override
  State<PreferenceTwo> createState() => _PreferenceTwoState();
}

class _PreferenceTwoState extends State<PreferenceTwo> {
  final List<String> categories = [
    "Religious and Spiritual Attractions",
    "Cultural and Historical Attractions",
    "Entertainment and Modern Attractions",
    "Natural Attractions",
    "Medical Attractions"
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
        final savedTourismTypes =
            List<String>.from(prefs['tourism_type'] ?? []);
        setState(() {
          selectedIndexes = categories
              .asMap()
              .entries
              .where((entry) => savedTourismTypes.contains(entry.value))
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
    final Map<String, dynamic>? previousData =
        GoRouterState.of(context).extra as Map<String, dynamic>?;
    final List<String> receivedCategories =
        previousData?['categories']?.cast<String>() ?? [];

    return ReusableScreen(
      showBackButton: true,
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
                  Row(
                    children: [
                      Text(
                        Translations.tr('favourite_tourism_type', lang),
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
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          GoRouter.of(context).push(
                            AppRouter.kPreferenceThree,
                            extra: {
                              'categories': receivedCategories,
                              'tourismTypes': <String>[],
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 52, right: 10),
                          child: Text(
                            Translations.tr('skip', lang),
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              color: Colors.white,
                              shadows: [
                                const Shadow(
                                  color: Colors.black,
                                  offset: Offset(4, 4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(1.5),
                  Image.asset(
                    AssetsData.spacer,
                    width: double.infinity,
                  ),
                  const VerticalSpace(1.5),
                  Text(
                    "${Translations.tr('choose_many', lang)}, ${Translations.tr('skip', lang).toLowerCase()} for now",
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
                        final selectedTourismTypes = selectedIndexes
                            .map((index) => categories[index])
                            .toList();
                        GoRouter.of(context).push(
                          AppRouter.kPreferenceThree,
                          extra: {
                            'categories': receivedCategories,
                            'tourismTypes': selectedTourismTypes,
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                Translations.tr('please_choose_one_or_skip', lang)),
                            backgroundColor: Colors.black,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
