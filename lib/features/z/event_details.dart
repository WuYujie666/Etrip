import 'dart:convert';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/wishlist/data/model/favorite_model.dart';
import 'package:egyptopia/features/wishlist/presentation/views/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse('http://192.168.1.12:8000/api/event/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> events = jsonDecode(utf8.decode(response.bodyBytes));
      final event = events.firstWhere(
        (e) => e['event_id'].toString() == eventId,
        orElse: () => throw Exception('Event not found'),
      );
      return event as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load event details');
    }
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
                'Event Details',
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
                    return Center(child: Text("Error: ${snapshot.error}"));
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
                                  child: Image.network(
                                    event['Image'],
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error,
                                          color: Colors.red),
                                    ),
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
                                      event['event_type'],
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
                                    event['event_name'],
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
                                        event['location'],
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
                                        'Price: ${event['ticket_price']} LE',
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
                              "About event",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              event['description'] ??
                                  'No description available.',
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
                                      'Organizer:',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      event['organizer'] ?? 'N/A',
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
                                  text: "Contact Info",
                                  fontSize: 14,
                                  onTap: () async {
                                    final email = event['contact_info'] ??
                                        'info@touregypt.gov.eg';
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
                              "Location",
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
                                    text: "Join event",
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
