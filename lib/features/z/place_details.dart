import 'package:carousel_slider/carousel_slider.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/features/auth/data/egyptopia_api_service.dart';
import 'package:egyptopia/features/home/presentation/views/widgets/feature_slider.dart';
import 'package:egyptopia/core/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetails extends StatelessWidget {
  final Map<String, dynamic> place;

  const PlaceDetails({super.key, required this.place});

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
    // Debug the place data

    // Base URL for images (adjust as needed based on your API)
    const String baseUrl = 'http://192.168.1.12:8000';

    // Process carousel images
    List<String> images = [];
    if (place['carousel'] != null && place['carousel'] is List) {
      images = (place['carousel'] as List<dynamic>)
          .map((item) {
            // Handle cases where item might not be a Map or might not have 'image'
            if (item is Map<String, dynamic> && item['image'] != null) {
              String imageUrl = item['image'].toString();
              // Prepend base URL if the image URL is relative
              if (!imageUrl.startsWith('http')) {
                imageUrl = '$baseUrl/$imageUrl';
              }
              return imageUrl;
            }
            return '';
          })
          .where((url) => url.isNotEmpty)
          .toList();
    }

    // Fallback to profile_image if carousel is empty or invalid
    if (images.isEmpty) {
      String? profileImage = place['profile_image']?.toString();
      if (profileImage != null && profileImage.isNotEmpty) {
        if (!profileImage.startsWith('http')) {
          profileImage = '$baseUrl/$profileImage';
        }
        images = [profileImage];
      } else {
        images = ['']; // Empty string will trigger errorBuilder
      }
    }

    final apiService = EgyptopiaApiService();

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
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Place Details',
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 3.25,
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

            // Content
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
                                ? Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey,
                                        child: const Center(
                                            child:
                                                Text('Image failed to load')),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey,
                                    child: const Center(
                                        child: Text('No image available')),
                                  ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // About Place Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(place['name'] ?? 'No name available',
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
                              place['tourism_type'],
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
                                  place['city_name'],
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
                                Row(
                                  children: List.generate(5, (index) {
                                    double rating = double.tryParse(
                                            place['rate'].toString()) ??
                                        0;

                                    if (rating > 4.5) {
                                      rating = 5.0;
                                    } else if (rating > 4.0) {
                                      rating = 4.5;
                                    }

                                    if (rating >= index + 1) {
                                      return const Icon(Icons.star,
                                          size: 16, color: Colors.amber);
                                    } else if (rating > index &&
                                        rating < index + 1) {
                                      return const Icon(Icons.star_half,
                                          size: 16, color: Colors.amber);
                                    } else {
                                      return const Icon(Icons.star_border,
                                          size: 16, color: Colors.amber);
                                    }
                                  }),
                                ),
                                const HorizantalSpace(0.3),
                                Text(
                                  (place['rate'] as double? ?? 0.0)
                                      .toStringAsFixed(1),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                        255, 119, 119, 119),
                                  ),
                                ),
                                const HorizantalSpace(0.3),
                                Text(
                                  "(${place['total_rates']})".toString(),
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
                        Text('Description',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 6),
                        Text(
                          place['description'] ?? 'No description available.',
                          style: GoogleFonts.inter(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 12),
                        Text("Location",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () =>
                              _openMap(place['google_maps_link'] ?? ''),
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
                          "Nearby Places",
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFF1F2544),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: apiService
                              .fetchNearbyPlaces(place['place_id'].toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Failed to load nearby places'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No nearby places found'));
                            }
                            // Debug the nearby places data
                            // Transform data to ensure compatibility with FeatureSlider and PlaceDetails
                            final transformedPlaces =
                                snapshot.data!.map((place) {
                              return {
                                'place_id': place['place_id']?.toString() ??
                                    place['id']?.toString(),
                                'name': place['name'] ?? 'Unknown Place',
                                'profile_image': place['profile_image'] ??
                                    place['image'] ??
                                    '',
                                'tourism_type': place['tourism_type'] ??
                                    place['type'] ??
                                    'Unknown',
                                'city_name': place['city_name'] ??
                                    place['city'] ??
                                    'Unknown',
                                'rate': place['rate'] ?? place['rating'] ?? 0,
                                'total_rates': place['total_rates'] ??
                                    place['total_reviews'] ??
                                    0,
                                'description': place['description'] ?? '',
                                'google_maps_link':
                                    place['google_maps_link'] ?? '',
                                'carousel': place['carousel'] ?? [],
                                'category': place['category'] ?? 'Unknown',
                              };
                            }).toList();
                            return FeatureSlider(
                              places: transformedPlaces,
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
