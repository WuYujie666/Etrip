import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return ReusableScreen(
      //showBackButton: true,
      gradientStops: const [0, 0.6],
      backgroundColor: kSecondaryColor,
      imageColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.defaultSize! * 7, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pick up to 10 categories:",
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
                      label:
                          Text(cat.replaceFirst(cat[0], cat[0].toUpperCase())),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (isSelected) {
                            selectedCategories.remove(cat);
                          } else if (selectedCategories.length < 10) {
                            selectedCategories.add(cat);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              "يا معرص اختار 10 بس",
                              style: GoogleFonts.inter(fontSize: 18),
                            )));
                          }
                        });
                      },
                      selectedColor: const Color.fromARGB(255, 64, 77, 151),
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
                text: "Create Itinerary",
                onTap: () {
                  if (selectedCategories.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Select at least one category.")));
                    return;
                  }
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
