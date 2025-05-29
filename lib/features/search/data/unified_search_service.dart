import 'search_item.dart';
import 'package:egyptopia/features/places/data/models/place_model.dart';

class UnifiedSearchService {
  static Map<String, List<SearchItem>> search({
    required String query,
    required List<PlaceModel> places,
    required List<Map<String, dynamic>> events,
    required List<Map<String, dynamic>> activities,
  }) {
    final q = query.toLowerCase();

    final placeResults = places.where((p) => p.name.toLowerCase().contains(q)).map((p) => SearchItem(
      id: p.id,
      type: "place",
      title: p.name,
      imageUrl: p.profileImage.isNotEmpty ? p.profileImage : (p.carouselImages.isNotEmpty ? p.carouselImages.first : ""),
      city: p.cityName,
      rating: p.rate.toString(),
      info: p.category,
    )).toList();

    final eventResults = events.where((e) => (e['event_name'] ?? '').toString().toLowerCase().contains(q)).map((e) => SearchItem(
      id: e['event_id'].toString(),
      type: "event",
      title: e['event_name'],
      imageUrl: e['Image'] ?? "",
      city: e['city_name'] ?? "",
      info: e['event_type'] ?? e['ticket_price'],
    )).toList();

    final activityResults = activities.where((a) => (a['title'] ?? '').toString().toLowerCase().contains(q)).map((a) => SearchItem(
      id: a['id'].toString(),
      type: "activity",
      title: a['title'],
      imageUrl: a['Image'] ?? "",
      city: a['city_name'] ?? "",
      rating: a['rating']?.toString(),
      info: a['activity_type'] ?? a['price_after'],
    )).toList();

    return {
      "places": placeResults,
      "events": eventResults,
      "activities": activityResults,
    };
  }
}