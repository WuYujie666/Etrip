import 'package:cached_network_image/cached_network_image.dart';
import 'package:egyptopia/core/config.dart';
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
        padding: EdgeInsets.only(
          top: SizeConfig.defaultSize! * 7,
          left: 16,
          right: 16,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              foodItem['Egyptian_Name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: SizeConfig.defaultSize! * 2.5,
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
            Expanded(
              child: ListView(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: "${AppConfig.apiBaseUrl}${foodItem['Image']}",
                      height: SizeConfig.defaultSize! * 23.5,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.error,
                          size: 65,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpace(1),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foodItem['Egyptian_Name'],
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const VerticalSpace(0.6),
                        Row(
                          children: [
                            const Icon(
                              Icons.restaurant_menu,
                              size: 17,
                              color: Color.fromARGB(255, 25, 37, 106),
                            ),
                            const HorizantalSpace(0.3),
                            Text(
                              "(${foodItem['Name']})",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 119, 119, 119),
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpace(1.2),
                        Text(
                          "About the Dish",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const VerticalSpace(0.6),
                        Text(
                          foodItem['Description'],
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}