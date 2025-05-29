import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/features/search/data/search_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:egyptopia/features/places/data/models/place_model.dart';

class SearchResultCard extends StatelessWidget {
  final SearchItem item;
  final List<PlaceModel>? places;
  final List<Map<String, dynamic>>? events;
  final List<Map<String, dynamic>>? activities;

  const SearchResultCard({
    super.key,
    required this.item,
    this.places,
    this.events,
    this.activities,
  });

  @override
  Widget build(BuildContext context) {
    String? extraInfo;
    if (item.type == "event" && events != null) {
      final event = events!.firstWhere(
          (e) => e['event_id'].toString() == item.id,
          orElse: () => {});
      String? price = event['ticket_price']?.toString();
      if (price != null && price.isNotEmpty) {
        extraInfo = "Price: $price LE";
      }
    } else if (item.type == "activity" && activities != null) {
      final activity = activities!
          .firstWhere((a) => a['id'].toString() == item.id, orElse: () => {});
      String? price = activity['price_after']?.toString();
      if (price != null && price.isNotEmpty) {
        extraInfo = "Price: $price LE";
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        if (item.type == "place" && places != null) {
          final place = places!.firstWhere((p) => p.id == item.id);
          context.push(AppRouter.kPlaceDetails, extra: place);
        } else if (item.type == "event" && events != null) {
          final event = events!.firstWhere(
              (e) => e['event_id'].toString() == item.id,
              orElse: () => {});
          if (event.isNotEmpty) {
            final eventData = {
              'event_id': event['event_id'].toString(),
              'event_name': event['event_name'],
              'Image': event['Image'],
            };
            context.push(AppRouter.kEventDetails, extra: eventData);
          }
        } else if (item.type == "activity" && activities != null) {
          final activity = activities!.firstWhere(
              (a) => a['id'].toString() == item.id,
              orElse: () => {});
          if (activity.isNotEmpty) {
            String registrationLink = activity['link'] ?? '';
            if (registrationLink.isNotEmpty &&
                await canLaunchUrl(Uri.parse(registrationLink))) {
              await launchUrl(Uri.parse(registrationLink));
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 3),
                blurRadius: 10,
              ),
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.grey[200],
                child: Image.network(
                  item.imageUrl,
                  width: 80,
                  height: 70,
                  fit: BoxFit.fill,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.photo, color: Colors.grey[400], size: 40),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.merriweather(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF232434),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (item.city.isNotEmpty) item.city,
                      if (item.info != null && item.info!.isNotEmpty)
                        item.info,
                      if (extraInfo != null) extraInfo,
                    ].join(" • "),
                    style: GoogleFonts.lato(
                      fontSize: 13.2,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      letterSpacing: 0.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (item.rating != null && item.rating != "0.0")
              Column(
                children: [
                  const Icon(Icons.star, size: 20, color: Colors.amber),
                  Text(
                    item.rating!,
                    style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        fontSize: 13.5),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
