import 'package:etrip/core/constants.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/Itinerary/presentation/views/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ItineraryStepOne extends StatefulWidget {
  final Function(Map<String, dynamic> args)? onStepTwo;
  const ItineraryStepOne({super.key, this.onStepTwo});

  @override
  State<ItineraryStepOne> createState() => _ItineraryStepOneState();
}

class _ItineraryStepOneState extends State<ItineraryStepOne> {
  int _noOfDays = 3;
  String _budget = 'medium';
  String _popularity = 'high';
  String _withWho = 'solo';

  final List<String> budgets = ["low", "medium", "high"];
  final List<String> popularities = ["low", "medium", "high"];
  final List<String> companions = ["solo", "friends", "family", "couple"];

  final List<String> tourismTypes = [
    "entertainment and modern attractions",
    "cultural and historical attractions",
    "natural attractions",
    "religious and spiritual attractions"
  ];

  final Set<String> selectedTourismTypes = {};

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return ReusableScreen(
      gradientStops: const [0, 0.6],
      backgroundColor: kSecondaryColor,
      imageColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Text(
              Translations.tr('plan_your_trip', lang),
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
            const VerticalSpace(2),
            CustomDropdown<int>(
              label: Translations.tr('days', lang),
              items: List.generate(7, (i) => i + 1),
              value: _noOfDays,
              onChanged: (val) => setState(() => _noOfDays = val ?? 3),
              itemLabelBuilder: (n) => lang == 'en'
                  ? "$n day${n == 1 ? '' : 's'}"
                  : "${n}天",
            ),
            const VerticalSpace(0.8),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    label: Translations.tr('budget', lang),
                    items: budgets,
                    value: _budget,
                    onChanged: (val) => setState(() => _budget = val!),
                    itemLabelBuilder: (val) => Translations.tr(val, lang),
                  ),
                ),
                const HorizantalSpace(0.5),
                Expanded(
                  child: CustomDropdown<String>(
                    label: Translations.tr('popularity', lang),
                    items: popularities,
                    value: _popularity,
                    onChanged: (val) => setState(() => _popularity = val!),
                    itemLabelBuilder: (val) => Translations.tr(val, lang),
                  ),
                ),
              ],
            ),
            const VerticalSpace(0.8),
            CustomDropdown<String>(
              label: Translations.tr('travel_with', lang),
              items: companions,
              value: _withWho,
              onChanged: (val) => setState(() => _withWho = val!),
              itemLabelBuilder: (val) => Translations.tr(val, lang),
            ),
            const VerticalSpace(1),
            Text(
              Translations.tr('tourism_types_choose', lang),
              style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 1, 44, 80),
                  fontWeight: FontWeight.bold),
            ),
            const VerticalSpace(0.5),
            ...tourismTypes.map((type) => CheckboxListTile(
                  title: Text(
                    Translations.tr(type, lang),
                    style: GoogleFonts.lato(color: Colors.black),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: selectedTourismTypes.contains(type),
                  activeColor: Colors.white,
                  checkColor: Colors.blue,
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        if (selectedTourismTypes.length < 2) {
                          selectedTourismTypes.add(type);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            Translations.tr('max_2_selected', lang),
                          )));
                        }
                      } else if (checked == false) {
                        selectedTourismTypes.remove(type);
                      }
                    });
                  },
                )),
            const VerticalSpace(1),
            SizedBox(
              width: double.infinity,
              child: CustomJoinButton(
                text: Translations.tr('next', lang),
                onTap: () {
                  if (selectedTourismTypes.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(Translations.tr('please_select_one_type', lang))));
                    return;
                  }
                  if (widget.onStepTwo != null) {
                    widget.onStepTwo!({
                      "noOfDays": _noOfDays,
                      "budget": _budget,
                      "popularity": _popularity,
                      "withWho": _withWho,
                      "tourismTypeWeights": selectedTourismTypes.toList(),
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
