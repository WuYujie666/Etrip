import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/Itinerary/presentation/views/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
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
    return ReusableScreen(
      gradientStops: const [0, 0.6],
      backgroundColor: kSecondaryColor,
      imageColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Plan your trip',
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
              label: "Days",
              items: List.generate(7, (i) => i + 1),
              value: _noOfDays,
              onChanged: (val) => setState(() => _noOfDays = val ?? 3),
              itemLabelBuilder: (n) => "$n day${n == 1 ? '' : 's'}",
            ),
            const VerticalSpace(0.8),
            Row(
              children: [
                Expanded(
                  child: CustomDropdown<String>(
                    label: "Budget",
                    items: budgets,
                    value: _budget,
                    onChanged: (val) => setState(() => _budget = val!),
                  ),
                ),
                const HorizantalSpace(0.5),
                Expanded(
                  child: CustomDropdown<String>(
                    label: "Popularity",
                    items: popularities,
                    value: _popularity,
                    onChanged: (val) => setState(() => _popularity = val!),
                  ),
                ),
              ],
            ),
            const VerticalSpace(0.8),
            CustomDropdown<String>(
              label: "Travel With",
              items: companions,
              value: _withWho,
              onChanged: (val) => setState(() => _withWho = val!),
            ),
            const VerticalSpace(1),
            Text(
              "Tourism Types (choose up to 2):",
              style: GoogleFonts.inter(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 1, 44, 80),
                  fontWeight: FontWeight.bold),
            ),
            const VerticalSpace(0.5),
            ...tourismTypes.map((type) => CheckboxListTile(
                  title: Text(
                    type[0].toUpperCase() + type.substring(1),
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
                            "يا معرص اختار 2 بس",
                            style: GoogleFonts.inter(fontSize: 18),
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
                text: "Next",
                onTap: () {
                  if (selectedTourismTypes.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("Please select at least one tourism type.")));
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
