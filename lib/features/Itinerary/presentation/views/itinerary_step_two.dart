// ignore_for_file: use_build_context_synchronously
import 'package:etrip/core/constants.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/utils/assets.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItineraryStepTwo extends StatefulWidget {
  final int noOfDays;
  final String budget;
  final String popularity;
  final String withWho;
  final List<String> tourismTypeWeights;
  final void Function(Map<String, dynamic> args)? onItineraryCreated;

  const ItineraryStepTwo({
    super.key,
    required this.noOfDays,
    required this.budget,
    required this.popularity,
    required this.withWho,
    required this.tourismTypeWeights,
    this.onItineraryCreated,
  });

  @override
  State<ItineraryStepTwo> createState() => _ItineraryStepTwoState();
}

class _ItineraryStepTwoState extends State<ItineraryStepTwo> {
  final List<String> categories = [
    "library",
    "museum",
    "theater",
    "garden",
    "fortress",
    "mosque",
    "tower",
    "palace",
    "tomb",
    "shopping",
    "zoo",
    "synagogue",
    "historical site",
    "temple",
    "aquarium",
    "church"
  ];
  final Set<String> selectedCategories = {};
  bool _loading = false;

  Future<void> _handleItineraryCreation() async {
    final lang = context.read<LocaleCubit>().state.languageCode;
    if (selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Translations.tr('select_at_least_one', lang))));
      return;
    }
    setState(() {
      _loading = true;
    });

    try {
      final resultArgs = {
        "noOfDays": widget.noOfDays,
        "budget": widget.budget,
        "popularity": widget.popularity,
        "withWho": widget.withWho,
        "tourismTypeWeights": widget.tourismTypeWeights,
        "categoryWeights": selectedCategories.toList(),
      };
      if (widget.onItineraryCreated != null) {
        widget.onItineraryCreated!(resultArgs);
        await Future.delayed(const Duration(seconds: 4));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${Translations.tr('error', context.read<LocaleCubit>().state.languageCode)}: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return ReusableScreen(
      backgroundColor: kSecondaryColor,
      imageColor: Colors.black,
      child: AbsorbPointer(
        absorbing: _loading,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.defaultSize! * 7, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Translations.tr('pick_up_to_10', lang),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(categories.length, (index) {
                          final cat = categories[index];
                          final isSelected = selectedCategories.contains(cat);
                          return ChoiceChip(
                            checkmarkColor: Colors.white,
                            label: Text(Translations.tr(cat, lang)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (isSelected) {
                                  selectedCategories.remove(cat);
                                } else if (selectedCategories.length < 10) {
                                  selectedCategories.add(cat);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                    Translations.tr('max_10_selected', lang),
                                  )));
                                }
                              });
                            },
                            selectedColor:
                                const Color.fromARGB(255, 64, 77, 151),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: CustomJoinButton(
                      text: _loading ? Translations.tr('loading', lang) : Translations.tr('create_itinerary', lang),
                      onTap: _loading ? () {} : _handleItineraryCreation,
                    ),
                  ),
                ],
              ),
            ),
            if (_loading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
