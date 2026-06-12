import 'search_item.dart';
import 'package:etrip/features/places/data/models/place_model.dart';

class UnifiedSearchService {
  static List<SearchItem> search({
    required String query,
    required List<PlaceModel> places,
  }) {
    final q = query.toLowerCase();

    return places.where((p) => p.name.toLowerCase().contains(q)).map((p) => SearchItem(
      id: p.id,
      type: "place",
      title: p.name,
      imageUrl: p.profileImage.isNotEmpty ? p.profileImage : (p.carouselImages.isNotEmpty ? p.carouselImages.first : ""),
      city: p.cityName,
      rating: p.rate.toString(),
      info: p.category,
    )).toList();
  }
}