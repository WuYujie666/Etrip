import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/food/build_category_tile.dart';
import 'package:flutter/material.dart';

class FoodCategories extends StatelessWidget {
  const FoodCategories({super.key});

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
            const VerticalSpace(7.5),
            Text(
              "Food",
              style: TextStyle(
                fontSize: SizeConfig.defaultSize! * 3.25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    offset: Offset(3, 3), // Adjust shadow position
                    blurRadius: 4, // Adjust blur intensity
                    color: Colors.black, // Shadow color
                  ),
                ],
              ),
            ),
            const BuildCategoryTile(
              text: "Main dishes",
              imagePath: "assets/images/main_dish.png",
              category: "Main Dishes",
            ),
            const BuildCategoryTile(
                text: "Desserts",
                imagePath: "assets/images/desserts.png",
                category: "Desserts"),
            const BuildCategoryTile(
                text: "Side dishes & appetizers",
                imagePath: "assets/images/appetizers.png",
                category: "Appetizers & Side Dishes"),
            const VerticalSpace(1),
            Text(
              "Drinks",
              style: TextStyle(
                fontSize: SizeConfig.defaultSize! * 3.25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    offset: Offset(2, 2), // Adjust shadow position
                    blurRadius: 4, // Adjust blur intensity
                    color: Colors.black, // Shadow color
                  ),
                ],
              ),
            ),
            const BuildCategoryTile(
                text: "Hot drinks",
                imagePath: "assets/images/hot_drinks.png",
                category: "Hot Drinks"),
            const BuildCategoryTile(
                text: "Cold drinks",
                imagePath: "assets/images/cold_drinks.png",
                category: "Cold Drinks"),
          ],
        ),
      ),
    );
  }
}
