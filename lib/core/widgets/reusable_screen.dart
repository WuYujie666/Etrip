import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReusableScreen extends StatelessWidget {
  final Widget child;
  final List<Color>? backgroundColor;
  final List<double>? gradientStops;
  final Color? imageColor;
  final bool showBackButton;

  const ReusableScreen({
    super.key,
    required this.child,
    this.imageColor = Colors.white,
    this.backgroundColor = konBordingColor,
    this.gradientStops, this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundColor!,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: gradientStops ?? [0.25, 0.6],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Image.asset(
                AssetsData.vectors,
                color: imageColor,
              ),
            ),
            if (showBackButton)
              Positioned(
                left: SizeConfig.defaultSize!,
                top: SizeConfig.defaultSize! * 2,
                child: IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }
}
