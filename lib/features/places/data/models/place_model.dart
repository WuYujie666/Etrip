import 'package:egyptopia/core/config.dart';

class PlaceModel {
  final String id;
  final String name;
  final String profileImage;
  final List<String> carouselImages;
  final String tourismType;
  final String category;
  final String cityName;
  final double rate;
  final int totalRates;
  final String description;
  final String googleMapsLink;

  PlaceModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.carouselImages,
    required this.tourismType,
    required this.category,
    required this.cityName,
    required this.rate,
    required this.totalRates,
    required this.description,
    required this.googleMapsLink,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    List<String> carousel = [];
    if (json['carousel'] != null && json['carousel'] is List) {
      carousel = (json['carousel'] as List).map((item) {
        if (item is Map && item['image'] != null) {
          String url = item['image'].toString();
          if (!url.startsWith('http')) {
            url = '${AppConfig.apiBaseUrl}/$url';
          }
          return url;
        }
        return '';
      }).where((url) => url.isNotEmpty).toList();
    }

    String profileImage = json['profile_image']?.toString() ?? '';
    if (profileImage.isNotEmpty && !profileImage.startsWith('http')) {
      profileImage = '${AppConfig.apiBaseUrl}/$profileImage';
    }

    // لو الكاروسيل فاضي عايزين صورة واحدة على الأقل
    if (carousel.isEmpty && profileImage.isNotEmpty) {
      carousel = [profileImage];
    }

    return PlaceModel(
      id: json['place_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? 'No name',
      profileImage: profileImage,
      carouselImages: carousel,
      tourismType: json['tourism_type'] ?? json['type'] ?? '',
      category: json['category'] ?? '',
      cityName: json['city_name'] ?? json['city'] ?? '',
      rate: double.tryParse(json['rate']?.toString() ?? '') ?? 0.0,
      totalRates: int.tryParse(json['total_rates']?.toString() ?? json['total_reviews']?.toString() ?? '0') ?? 0,
      description: json['description'] ?? '',
      googleMapsLink: json['google_maps_link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': id,
      'name': name,
      'profile_image': profileImage,
      'carousel': carouselImages.map((img) => {'image': img}).toList(),
      'tourism_type': tourismType,
      'category': category,
      'city_name': cityName,
      'rate': rate,
      'total_rates': totalRates,
      'description': description,
      'google_maps_link': googleMapsLink,
    };
  }
}