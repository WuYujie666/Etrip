import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/features/z/food_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodSecond extends StatelessWidget {
  const FoodSecond({super.key});

  Widget _buildCategoryTile({
    required String text,
    required String imagePath,
    required VoidCallback onTap,
    double width = double.infinity,
    double height = 80,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 3),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: width,
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: GoogleFonts.imFellFrenchCanonSc(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 86, 84, 84),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: -15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: ReusableScreen(
              backgroundColor: kSecondaryColor,
              gradientStops: const [0.1, 0.7],
              imageColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Text(
                        "Food",
                        style: GoogleFonts.imFellFrenchCanonSc(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(3, 3), // Adjust shadow position
                              blurRadius: 4, // Adjust blur intensity
                              color: Colors.black, // Shadow color
                            ),
                          ],
                        ),
                      ),
                      _buildCategoryTile(
                        text: "Main dishes",
                        imagePath: "assets/images/main_dish.png",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FoodCategoryScreen(category: "Main Dishes"),
                            ),
                          );
                        },
                      ),
                      _buildCategoryTile(
                        text: "Desserts",
                        imagePath: "assets/images/desserts.png",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FoodCategoryScreen(category: "Desserts"),
                            ),
                          );
                        },
                      ),
                      _buildCategoryTile(
                        text: "Side dishes & appetizers",
                        imagePath: "assets/images/appetizers2.png",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodCategoryScreen(
                                  category: "Appetizers & Side Dishes"),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Drinks",
                        style: GoogleFonts.imFellFrenchCanonSc(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2), // Adjust shadow position
                              blurRadius: 4, // Adjust blur intensity
                              color: Colors.black, // Shadow color
                            ),
                          ],
                        ),
                      ),
                      _buildCategoryTile(
                        text: "Hot drinks",
                        imagePath: "assets/images/hot_drinks.png",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FoodCategoryScreen(category: "Hot Drinks"),
                            ),
                          );
                        },
                      ),
                      _buildCategoryTile(
                        text: "Cold drinks",
                        imagePath: "assets/images/cold_drinks.png",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FoodCategoryScreen(category: "Cold Drinks"),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: SizeConfig.defaultSize!,
            top: SizeConfig.defaultSize! * 2,
            child: IconButton(
              onPressed: () {
                context.pushReplacement(AppRouter.kFood);
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
