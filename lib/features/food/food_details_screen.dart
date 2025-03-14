import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> foodItem;

  const FoodDetailsScreen({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return ReusableScreen(
      showBackButton: true,
      backgroundColor: kSecondaryColor,
      gradientStops: const [0.1, 0.7],
      imageColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpace(8),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "http://192.168.1.12:8000${foodItem['Image']}",
                height: SizeConfig.defaultSize! * 23.5,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            const VerticalSpace(2),
            Text(
              foodItem['Egyptian_Name'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const VerticalSpace(1),
            Text(
              "(${foodItem['Name']})",
              style: GoogleFonts.sora(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 99, 99, 99),
              ),
            ),
            const VerticalSpace(1),
            const Text(
              "Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 46, 69, 81),
              ),
            ),
            const VerticalSpace(0.5),
            Text(
              foodItem['Description'],
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
