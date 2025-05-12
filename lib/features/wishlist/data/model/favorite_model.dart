import 'package:hive/hive.dart';
part 'favorite_model.g.dart';

// Enum لتحديد نوع العنصر المفضل
@HiveType(typeId: 0)
enum FavoriteType {
  @HiveField(0)
  place,
  @HiveField(1)
  activity,
  @HiveField(2)
  event,
}

@HiveType(typeId: 1)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final FavoriteType type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String? price;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final String? additionalInfo;

  @HiveField(7)
  final String? rate;

  @HiveField(8)
  final String? category;

  @HiveField(9)
  final String? tourismType;

  // New fields
  @HiveField(10)
  final String? description;

  @HiveField(11)
  final String? googleMapsLink;

  @HiveField(12)
  final int? totalRates;

  @HiveField(13)
  final List<dynamic>? carousel;

  FavoriteModel({
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    this.price,
    required this.city,
    this.additionalInfo,
    this.rate,
    this.category,
    this.tourismType,
    this.description,
    this.googleMapsLink,
    this.totalRates,
    this.carousel,
  });

  // Convert to map for compatibility with PlaceDetails
  Map<String, dynamic> toMap() {
    return {
      'place_id': id,
      'name': title,
      'profile_image': imageUrl,
      'city_name': city,
      'category': category,
      'tourism_type': tourismType,
      'rate': rate,
      'description': description,
      'google_maps_link': googleMapsLink,
      'total_rates': totalRates,
      'carousel': carousel,
    };
  }
}
