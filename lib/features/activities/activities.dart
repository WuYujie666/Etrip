import 'package:etrip/core/mock_data.dart';
import 'package:etrip/core/widgets/app_image.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/core/widgets/custom_star_rating_widget.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/wishlist/data/model/favorite_model.dart';
import 'package:etrip/features/wishlist/presentation/views/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/core/constants.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  late Future<List<dynamic>> activitiesFuture;
  RangeValues priceRange = const RangeValues(0, 70000);
  List<String> selectedTypes = [];

  final List<String> activityTypes = [
    "Balloon Tours",
    "Camel Tours",
    "Diving",
    "Safari",
    "Submarine Tours",
    "Swimming With Dolphins"
  ];

  @override
  void initState() {
    super.initState();
    activitiesFuture = fetchActivities();
  }

  Future<List<dynamic>> fetchActivities() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockActivities;
  }

  List<dynamic> filterActivities(List<dynamic> allActivities) {
    return allActivities.where((activity) {
      final double priceAfter =
          double.tryParse(activity['price_after'].toString()) ?? 0;
      final String type = activity['activity_type'];
      final bool matchesPrice =
          priceAfter >= priceRange.start && priceAfter <= priceRange.end;
      final bool matchesType =
          selectedTypes.isEmpty || selectedTypes.contains(type);
      return matchesPrice && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return ReusableScreen(
      showBackButton: true,
      backgroundColor: kSecondaryColor,
      gradientStops: const [0.1, 0.7],
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
                Translations.tr('activities_title', lang),
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 3.25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                        offset: Offset(3, 3),
                        blurRadius: 4,
                        color: Colors.black),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Price Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    "${Translations.tr('filter_by_price', lang)}: ${priceRange.start.toInt()} LE - ${priceRange.end.toInt()} LE",
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  RangeSlider(
                    min: 0,
                    max: 70000,
                    divisions: 100,
                    values: priceRange,
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                    labels: RangeLabels(
                      "${priceRange.start.toInt()} LE",
                      "${priceRange.end.toInt()} LE",
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        priceRange = values;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Type Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: activityTypes.map((type) {
                  final isSelected = selectedTypes.contains(type);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      checkmarkColor: Colors.white,
                      label: Text(localizedActivityType(type, lang)),
                      labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      selected: isSelected,
                      selectedColor: Colors.black87,
                      backgroundColor: Colors.white,
                      onSelected: (selected) {
                        setState(() {
                          selected
                              ? selectedTypes.add(type)
                              : selectedTypes.remove(type);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Activities List
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: activitiesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${Translations.tr('error', lang)}: ${snapshot.error}"));
                  }

                  final filtered = filterActivities(snapshot.data!);

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final activity = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 4,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image + badge
                              Stack(
                                children: [
                                  AppImage(
                                    activity['Image'],
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        localizedActivityType(activity['activity_type'] ?? '', lang),
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 99, 99, 99),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Text Content
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localizedActivityTitle(activity, lang),
                                      style: GoogleFonts.inter(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const VerticalSpace(0.5),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 16),
                                        const HorizantalSpace(0.1),
                                        Text(
                                          localizedCityName(activity['city_name'] ?? '', lang),
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromARGB(
                                                255, 119, 119, 119),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalSpace(0.1),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.whatshot,
                                                size: 16, color: Colors.orange),
                                            const HorizantalSpace(0.1),
                                            CustomStarRatingWidget(
                                                rating: double.tryParse(
                                                        activity['rating']
                                                            .toString()) ??
                                                    0),
                                            const HorizantalSpace(0.3),
                                            Text(
                                              activity['rating'],
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.discount,
                                                size: 16),
                                            const HorizantalSpace(0.3),
                                            Text(
                                              "${activity['price_before']} LE",
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 150, 150, 150),
                                                decoration: TextDecoration
                                                    .lineThrough, // 👈 adds strike-through
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "${activity['price_after']} LE",
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors
                                                    .black, // make it stand out
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const VerticalSpace(0.5),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomJoinButton(
                                            text: Translations.tr('join_now', lang),
                                            onTap: () async {
                                              String registrationLink = activity[
                                                  'link']; // Replace 'event' with your actual event data

                                              // Check if the link can be launched
                                              if (await canLaunchUrl(Uri.parse(
                                                  registrationLink))) {
                                                await launchUrl(Uri.parse(
                                                    registrationLink));
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        FavoriteIcon(
                                          id: activity['id'].toString(),
                                          type: FavoriteType.activity,
                                          title: activity['title'],
                                          imageUrl: activity['Image'],
                                          price: activity['price_after'],
                                          city: activity['city_name'],
                                          additionalInfo: activity['link'],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
