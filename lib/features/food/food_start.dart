import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FoodStart extends StatelessWidget {
  const FoodStart({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableScreen(
        showBackButton: true,
        backgroundColor: kSecondaryColor,
        gradientStops: const [0.1, 0.7],
        imageColor: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Food & Drinks",
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 4.3,
                  color: Colors.white,
                ),
              ),
              const VerticalSpace(8),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: SizeConfig.screenWidth! * 0.8,
                    height: SizeConfig.screenHeight! * 0.62,
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 8,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Great taste,\nGreat sensation",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.defaultSize! * 3.3,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const VerticalSpace(2),
                        Text(
                          "Discover delicious Egyptian food & drinks that you didn't know before!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: SizeConfig.defaultSize! * 1.6,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                          ),
                        ),
                        const VerticalSpace(6),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Image.asset(
                      AssetsData.vectors,
                      width: SizeConfig.screenWidth! * 0.8,
                      height: SizeConfig.defaultSize! * 11,
                      fit: BoxFit.cover,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    top: -SizeConfig.defaultSize! * 6,
                    child: CircleAvatar(
                      radius: SizeConfig.defaultSize! * 7.8,
                      backgroundColor: Colors.white,
                      backgroundImage: const AssetImage(
                        AssetsData.foodImage,
                      ),
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: Offset(0, -SizeConfig.defaultSize! * 3),
                child: SizedBox(
                  height: SizeConfig.defaultSize! * 6.5,
                  width: SizeConfig.defaultSize! * 20,
                  child: CustomGeneralButton(
                    text: "Get Started",
                    onTap: () {
                      GoRouter.of(context).push(AppRouter.kFoodCategories);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
