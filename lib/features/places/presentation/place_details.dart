import 'package:carousel_slider/carousel_slider.dart';
import 'package:etrip/core/widgets/app_image.dart';
import 'package:etrip/core/widgets/custom_star_rating_widget.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/places/data/models/place_model.dart';
import 'package:etrip/core/mock_data.dart';
import 'package:etrip/features/places/data/places_api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/features/home/presentation/views/widgets/feature_slider.dart';
import 'package:etrip/core/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceDetails extends StatelessWidget {
  final PlaceModel place;

  const PlaceDetails({super.key, required this.place});

  String _getDescription(PlaceModel place, String lang) {
    return lang == 'zh'
        ? (placeDescriptionsZh[place.id] ?? place.description)
        : place.description;
  }

  void _openMap(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = place.carouselImages.isNotEmpty
        ? place.carouselImages
        : [place.profileImage];
    final apiService = PlacesApiService();
    final lang = context.watch<LocaleCubit>().state.languageCode;

    return ReusableScreen(
      showBackButton: true,
      backgroundColor: kSecondaryColor,
      gradientStops: const [0.1, 0.6],
      imageColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.only(top: SizeConfig.defaultSize! * 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                localizedPlaceName(place, lang),
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
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  // Image Carousel
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 1.0,
                    ),
                    items: images.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: imageUrl.isNotEmpty
                                ? AppImage(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: Colors.grey,
                                    child: Center(
                                        child: Text(Translations.tr('no_image', lang))),
                                  ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(localizedPlaceName(place, lang),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.travel_explore,
                              size: 17,
                              color: Color.fromARGB(255, 25, 37, 106),
                            ),
                            const HorizantalSpace(0.3),
                            Text(
                              localizedTourismType(place.tourismType, lang),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 119, 119, 119),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.place,
                                    color: Color.fromARGB(255, 25, 37, 106),
                                    size: 19),
                                const HorizantalSpace(0.15),
                                Text(
                                  localizedCityName(place.cityName, lang),
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(
                                        255, 119, 119, 119),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CustomStarRatingWidget(rating: place.rate),
                                const HorizantalSpace(0.3),
                                Text(
                                  place.rate.toStringAsFixed(1),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 119, 119, 119),
                                  ),
                                ),
                                const HorizantalSpace(0.3),
                                Text(
                                  "(${place.totalRates})",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 119, 119, 119),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(Translations.tr('description', lang),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 6),
                        Text(
                          _getDescription(place, lang).isNotEmpty
                              ? _getDescription(place, lang)
                              : Translations.tr('no_description', lang),
                          style: GoogleFonts.inter(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 12),
                        Text(Translations.tr('location', lang),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _openMap(place.googleMapsLink),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/map_placeholder.png',
                              fit: BoxFit.cover,
                              height: 150,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        // Nearby Places Slider
                        const SizedBox(height: 24),
                        Text(
                          Translations.tr('nearby_places', lang),
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF1F2544),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<List<PlaceModel>>(
                          future: apiService.fetchNearbyPlaces(place.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(Translations.tr('failed_nearby', lang)));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                  child: Text(Translations.tr('no_nearby', lang)));
                            }
                            return FeatureSlider(
                              places: snapshot.data!,
                              width: SizeConfig.screenWidth! * 0.35,
                              onTap: (nearbyPlace) {
                                if (nearbyPlace != null) {
                                  context.push(AppRouter.kPlaceDetails,
                                      extra: nearbyPlace);
                                }
                              },
                            );
                          },
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
