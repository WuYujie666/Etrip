import 'package:etrip/core/mock_data.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/core/widgets/app_image.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/wishlist/data/model/favorite_model.dart';
import 'package:etrip/features/wishlist/presentation/views/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/core/constants.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  late Future<List<dynamic>> eventsFuture;

  @override
  void initState() {
    super.initState();
    eventsFuture = fetchEvents();
  }

  Future<List<dynamic>> fetchEvents() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockEvents;
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                Translations.tr('events_title', lang),
                style: TextStyle(
                  fontSize: SizeConfig.defaultSize! * 3.25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                      offset: Offset(3, 3), // Adjust shadow position
                      blurRadius: 4, // Adjust blur intensity
                      color: Colors.black, // Shadow color
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),

            // Events List
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${Translations.tr('error', lang)}: ${snapshot.error}'));
                  }

                  final events = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return GestureDetector(
                        onTap: () {
                          final eventData = {
                            'event_id': event['event_id'].toString(),
                            'event_name': event['event_name'],
                            'Image': event['Image'],
                          };
                          context.push(AppRouter.kEventDetails,
                              extra: eventData);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    AppImage(
                                      event['Image'],
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          event['event_date'],
                                          style: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromARGB(
                                                255, 99, 99, 99),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: FavoriteIcon(
                                          iconSize: 30,
                                          id: event['event_id'].toString(),
                                          type: FavoriteType.event,
                                          title: event['event_name'],
                                          imageUrl: event['Image'],
                                          price: event['ticket_price'],
                                          city: event['city_name'],
                                          additionalInfo:
                                              event['registration_link'],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        localizedEventName(event, lang),
                                        style: GoogleFonts.inter(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${Translations.tr('type_label', lang)}${localizedEventType(event['event_type'] ?? '', lang)}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 119, 119, 119),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on,
                                                  size: 16),
                                              const HorizantalSpace(0.1),
                                              Text(
                                                localizedCityName(event['city_name'] ?? '', lang),
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
                                              const Icon(
                                                  Icons.access_time_filled,
                                                  size: 16),
                                              const HorizantalSpace(0.3),
                                              Text(
                                                event['event_time'],
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 119, 119, 119),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
