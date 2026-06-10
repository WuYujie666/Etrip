import 'package:etrip/core/mock_data.dart';
import 'package:etrip/core/widgets/app_image.dart';
import 'package:etrip/core/widgets/custom_buttons.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/wishlist/data/model/favorite_model.dart';
import 'package:etrip/features/wishlist/presentation/views/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetails extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetails({super.key, required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late Future<Map<String, dynamic>> _eventFuture;

  @override
  void initState() {
    super.initState();
    _eventFuture = fetchEvent(widget.event['event_id']);
  }

  Future<Map<String, dynamic>> fetchEvent(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final event = mockEvents.firstWhere(
      (e) => e['event_id'].toString() == eventId,
      orElse: () => throw Exception('Event not found'),
    );
    return event;
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
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                Translations.tr('event_details', lang),
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
              child: FutureBuilder<Map<String, dynamic>>(
                future: _eventFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${Translations.tr('error', lang)}: ${snapshot.error}'));
                  }

                  final event = snapshot.data!;

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      // Header Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(blurRadius: 6, color: Colors.black12)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: AppImage(
                                    event['Image'],
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      localizedEventType(event['event_type'] ?? '', lang),
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizedEventName(event, lang),
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 18),
                                      const HorizantalSpace(0.1),
                                      Text(
                                        localizedCityName(event['location'] ?? '', lang),
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 99, 99, 99),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const HorizantalSpace(0.1),
                                      const Icon(Icons.calendar_month,
                                          size: 16),
                                      const HorizantalSpace(0.3),
                                      Text(
                                        '${event['event_date']} - ${event['end_date']}',
                                        style: GoogleFonts.inter(fontSize: 13),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${Translations.tr('price_label', lang)}${event['ticket_price']} LE',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 64, 77, 151),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const HorizantalSpace(0.1),
                                      const Icon(Icons.access_time_filled,
                                          size: 16),
                                      const HorizantalSpace(0.3),
                                      Text(
                                        event['event_time'],
                                        style: GoogleFonts.inter(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // About Event Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Translations.tr('about_event', lang),
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              event['description'] ??
                                  Translations.tr('no_description', lang),
                              style: GoogleFonts.inter(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Translations.tr('organizer', lang),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      event['organizer'] ?? Translations.tr('n_a', lang),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: const Color.fromARGB(
                                            255, 64, 77, 151),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                CustomJoinButton(
                                  text: Translations.tr('contact_info', lang),
                                  fontSize: 14,
                                  onTap: () async {
                                    final email = event['contact_info'] ??
                                        'info@travelchina.gov.cn';
                                    final Uri emailUri = Uri(
                                      scheme: 'mailto',
                                      path: email,
                                    );
                                    if (await canLaunchUrl(emailUri)) {
                                      await launchUrl(emailUri);
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              Translations.tr('location', lang),
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _openMap(event['google_map_link']),
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
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomJoinButton(
                                    text: Translations.tr('join_event', lang),
                                    minimumSize: const Size(200, 45),
                                    onTap: () async {
                                      String registrationLink =
                                          event['registration_link'];
                                      Uri registrationUri =
                                          Uri.parse(registrationLink);
                                      if (await canLaunchUrl(registrationUri)) {
                                        await launchUrl(registrationUri);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                FavoriteIcon(
                                  id: event['event_id'].toString(),
                                  type: FavoriteType.event,
                                  title: event['event_name'],
                                  imageUrl: event['Image'],
                                  price: event['ticket_price'],
                                  city: event['city_name'],
                                  additionalInfo: event['registration_link'],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
