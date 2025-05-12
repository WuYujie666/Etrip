// ignore_for_file: use_build_context_synchronously

import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/wishlist/data/model/favorite_model.dart';
import 'package:egyptopia/features/wishlist/data/service/favorite_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'favorite_icon.dart';
import 'package:go_router/go_router.dart';

class FavoriteCard extends StatelessWidget {
  final FavoriteType type;

  const FavoriteCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<FavoriteModel>>(
      valueListenable:
          Hive.box<FavoriteModel>(FavoriteService.boxName).listenable(),
      builder: (context, box, _) {
        final favorites = box.values.where((fav) => fav.type == type).toList();

        if (favorites.isEmpty) {
          return Center(
            child: Text(
              'No Favorites yet',
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final fav = favorites[index];

            // Determine card shape based on type
            final isPlace = fav.type == FavoriteType.place;
            final isEvent = fav.type == FavoriteType.event;
            final cardShape = RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isPlace ? 30 : 20),
            );
            final cardElevation = isPlace ? 6.0 : 4.0;

            return GestureDetector(
              onTap: () {
                if (isEvent) {
                  // Pass minimal event data, primarily the event_id
                  final eventData = {
                    'event_id': fav.id,
                    'event_name': fav.title, // Optional: for immediate display
                    'Image': fav.imageUrl, // Optional: for immediate display
                  };
                  context.push(AppRouter.kEventDetails, extra: eventData);
                } else if (isPlace) {
                  // Existing place navigation logic
                  final rate = fav.rate != null
                      ? double.tryParse(fav.rate!) ?? 0.0
                      : 0.0;
                  final place = {
                    'place_id': fav.id,
                    'name': fav.title,
                    'profile_image': fav.imageUrl,
                    'city_name': fav.city,
                    'category': fav.category ?? '',
                    'tourism_type': fav.tourismType ?? '',
                    'rate': rate,
                    'description':
                        fav.description ?? 'Description not available',
                    'google_maps_link': fav.googleMapsLink ?? '',
                    'total_rates': fav.totalRates ?? 0,
                    'carousel': fav.carousel ?? [],
                  };
                  context.push(AppRouter.kPlaceDetails, extra: place);
                }
              },
              child: Card(
                shape: cardShape,
                elevation: cardElevation,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  height: SizeConfig.defaultSize! * (isPlace ? 22 : 18),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          fav.imageUrl,
                          width: SizeConfig.defaultSize! * 13,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                      const HorizantalSpace(1),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fav.title,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const VerticalSpace(0.5),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16),
                                const HorizantalSpace(0.5),
                                Text(
                                  fav.city,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(
                                        255, 119, 119, 119),
                                  ),
                                ),
                              ],
                            ),
                            const VerticalSpace(0.4),
                            if (fav.price != null && fav.price!.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(Icons.discount, size: 16),
                                  const HorizantalSpace(0.5),
                                  Text(
                                    "${fav.price} LE",
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            if (isPlace) ...[
                              if (fav.category != null &&
                                  fav.category!.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(Icons.category, size: 16),
                                    const HorizantalSpace(0.5),
                                    Text(
                                      "Category: ${fav.category}",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              const VerticalSpace(0.5),
                              if (fav.tourismType != null &&
                                  fav.tourismType!.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(Icons.travel_explore, size: 16),
                                    const HorizantalSpace(0.5),
                                    Expanded(
                                      child: Tooltip(
                                        message: fav.tourismType ??
                                            'No Tourism Type',
                                        child: Text(
                                          "Type: ${fav.tourismType != null && fav.tourismType!.isNotEmpty ? fav.tourismType : 'No Tourism Type'}",
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const VerticalSpace(0.5),
                              if (fav.rate != null && fav.rate!.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        size: 16, color: Colors.amber),
                                    const HorizantalSpace(0.5),
                                    Text(
                                      "Rating: ${fav.rate}",
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                            const Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomJoinButton(
                                    text: isPlace ? "Explore Now" : "Join Now",
                                    onTap: () async {
                                      if (isPlace) {
                                        final rate = fav.rate != null
                                            ? double.tryParse(fav.rate!) ?? 0.0
                                            : 0.0;
                                        final place = {
                                          'place_id': fav.id,
                                          'name': fav.title,
                                          'profile_image': fav.imageUrl,
                                          'city_name': fav.city,
                                          'category': fav.category ?? '',
                                          'tourism_type': fav.tourismType ?? '',
                                          'rate': rate,
                                          'description': fav.description ??
                                              'Description not available',
                                          'google_maps_link':
                                              fav.googleMapsLink ?? '',
                                          'total_rates': fav.totalRates ?? 0,
                                          'carousel': fav.carousel ?? [],
                                        };
                                        context.push(AppRouter.kPlaceDetails,
                                            extra: place);
                                      } else {
                                        final uri =
                                            Uri.parse(fav.additionalInfo ?? '');
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Could not launch the link'),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                                const HorizantalSpace(0.5),
                                FavoriteIcon(
                                  id: fav.id,
                                  type: fav.type,
                                  title: fav.title,
                                  imageUrl: fav.imageUrl,
                                  additionalInfo: fav.additionalInfo,
                                  price: fav.price,
                                  city: fav.city,
                                  rate: fav.rate,
                                  category: fav.category,
                                  tourismType: fav.tourismType,
                                  description: fav.description,
                                  googleMapsLink: fav.googleMapsLink,
                                  totalRates: fav.totalRates,
                                  carousel: fav.carousel,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
