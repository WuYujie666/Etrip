import 'package:cached_network_image/cached_network_image.dart';
import 'package:egyptopia/core/config.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildFoodCard extends StatelessWidget {
  final Map<String, dynamic> foodItem;
  const BuildFoodCard({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push(AppRouter.kFoodDetails, extra: foodItem);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFB0B0BB),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: "${AppConfig.apiBaseUrl}${foodItem['Image']}",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 50, color: Colors.red),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "${foodItem['Egyptian_Name']}",
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
