import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Food extends StatelessWidget {
  const Food({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ReusableScreen(
          backgroundColor: kSecondaryColor,
          gradientStops: const [0.1, 0.7],
          imageColor: Colors.black,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Food & Drinks",
                  style: GoogleFonts.imFellFrenchCanonSc(
                    fontSize: 45,
                    color: Colors.white,
                  ),
                ),
                const VerticalSpace(8),
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.80,
                      padding: const EdgeInsets.symmetric(
                          vertical: 120, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 72, 84, 118),
                            Color.fromARGB(255, 229, 224, 239),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            "Great taste,\nGreat sensation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          VerticalSpace(2),
                          Text(
                            "Discover delicious Egyptian food & drinks that you didn't know before!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70,
                            ),
                          ),
                          VerticalSpace(6),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Image.asset(
                        AssetsData.vectors2,
                        width: 350,
                        height: 120,
                        fit: BoxFit.cover,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      child: SizedBox(
                        height: 70,
                        width: 215,
                        child: CustomGeneralButton(
                          text: "Get Started",
                          onTap: () {
                            GoRouter.of(context)
                                .pushReplacement(AppRouter.kFood2);
                          },
                        ),
                      ),
                    ),
                    const Positioned(
                      top: -60,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(
                          AssetsData.foodImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: SizeConfig.defaultSize!,
          top: SizeConfig.defaultSize! * 2,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
