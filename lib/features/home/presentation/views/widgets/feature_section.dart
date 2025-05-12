import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureSection extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final VoidCallback onSeeAll;
  final Widget slider;

  const FeatureSection({
    super.key,
    required this.title,
    this.titleStyle,
    required this.onSeeAll,
    required this.slider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: titleStyle ??
                  GoogleFonts.montserrat(
                    color: const Color(0xFF1F2544),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                "See All",
                style: GoogleFonts.inter(
                  color: Colors.black,
                  shadows: [
                    const Shadow(
                      color: Colors.white,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        slider,
      ],
    );
  }
}
