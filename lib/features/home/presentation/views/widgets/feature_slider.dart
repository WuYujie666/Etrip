import 'package:egyptopia/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'featured_slider_item.dart';

class FeatureSlider extends StatelessWidget {
  final double? height;
  final double? width;
  final String? imageAsset;
  final List<Map<String, dynamic>>? places;
  final void Function(Map<String, dynamic>? place)? onTap;

  const FeatureSlider({
    super.key,
    this.height,
    this.width,
    this.imageAsset,
    this.places,
    this.onTap,
  }) : assert(
          (imageAsset != null && places == null) ||
              (imageAsset == null && places != null),
          'Either imageAsset or places must be provided, but not both.',
        );

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://192.168.1.12:8000';

    final uniquePlaces = places != null
        ? (places!
            .fold<Map<String, Map<String, dynamic>>>(
              {},
              (map, place) {
                final name = place['name'] as String;
                if (!map.containsKey(name)) {
                  map[name] = place;
                }
                return map;
              },
            )
            .values
            .toList())
        : null;

    return Container(
      padding: const EdgeInsets.only(left: 8),
      height: height ?? SizeConfig.defaultSize! * 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: uniquePlaces != null ? uniquePlaces.length : 5,
        itemBuilder: (context, index) {
          if (uniquePlaces != null) {
            final place = uniquePlaces[index];
            final profileImage = place['profile_image']?.toString() ?? '';
            final carouselRaw = place['carousel'];

            String carouselImage = '';
            if (carouselRaw != null) {
              if (carouselRaw is List<dynamic>) {
                final carousel = carouselRaw;
                if (carousel.isNotEmpty) {
                  final firstItem = carousel[0];
                  if (firstItem is Map<String, dynamic>) {
                    carouselImage = firstItem['image']?.toString() ?? '';
                  } else if (firstItem is String) {
                    carouselImage = firstItem;
                  }
                }
              } else if (carouselRaw is String) {
                carouselImage = carouselRaw;
              }
            }

            final imageUrl = profileImage.isNotEmpty
                ? '$baseUrl/$profileImage'
                : (carouselImage.isNotEmpty ? '$baseUrl/$carouselImage' : '');
            final cityName = place['city_name']?.toString() ?? '';
            final name = place['name']?.toString() ?? '';
            final rate =
                double.tryParse(place['rate']?.toString() ?? '0') ?? 0.0;
            final placeId = place['place_id']?.toString() ?? '';
            final category = place['category']?.toString() ?? '';
            final tourismType = place['tourism_type']?.toString() ?? '';
            final description = place['description']?.toString() ?? '';
            final googleMapsLink = place['google_maps_link']?.toString() ?? '';
            final totalRates = place['total_rates'] ?? 0;
            final carousel = place['carousel'] ?? [];

            return FeaturedSliderItem(
              width: width,
              imageUrl: imageUrl,
              isStatic: false,
              cityName: cityName,
              name: name,
              rate: rate,
              placeId: placeId,
              category: category,
              tourismType: tourismType,
              description: description,
              googleMapsLink: googleMapsLink,
              totalRates: totalRates,
              carousel: carousel,
              onTap: () => onTap?.call(place),
            );
          } else {
            return FeaturedSliderItem(
              width: width,
              imageAsset: imageAsset!,
              isStatic: true,
              onTap: () => onTap?.call(null),
            );
          }
        },
      ),
    );
  }
}
