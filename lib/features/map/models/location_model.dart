import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 位置类型枚举
enum LocationType { place, activity, event }

/// 地图位置数据模型
class LocationModel {
  final String id;
  final String name;
  final String nameEn;
  final double lat;
  final double lng;
  final LocationType type;
  final String category;
  final double rating;
  final String imageUrl;
  final String description;
  final String? address;
  final String? phone;
  final String? website;
  final List<String>? openingHours;
  final double? price;
  final String? currency;
  final DateTime? startTime;
  final DateTime? endTime;

  LocationModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.lat,
    required this.lng,
    required this.type,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.description,
    this.address,
    this.phone,
    this.website,
    this.openingHours,
    this.price,
    this.currency,
    this.startTime,
    this.endTime,
  });

  /// 获取 LatLng 对象
  LatLng get latLng => LatLng(lat, lng);

  /// 获取类型颜色
  String get typeColor {
    switch (type) {
      case LocationType.place:
        return '#F44336'; // 红色
      case LocationType.activity:
        return '#4CAF50'; // 绿色
      case LocationType.event:
        return '#9C27B0'; // 紫色
    }
  }

  /// 获取类型图标
  String get typeIcon {
    switch (type) {
      case LocationType.place:
        return 'place';
      case LocationType.activity:
        return 'local_activity';
      case LocationType.event:
        return 'event';
    }
  }

  /// 获取类型标签
  String get typeLabel {
    switch (type) {
      case LocationType.place:
        return '景点';
      case LocationType.activity:
        return '活动';
      case LocationType.event:
        return '事件';
    }
  }

  /// 从 JSON 创建对象
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      type: LocationType.values.firstWhere(
        (e) => e.toString() == 'LocationType.${json['type']}',
        orElse: () => LocationType.place,
      ),
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      openingHours: json['openingHours'] != null
          ? List<String>.from(json['openingHours'])
          : null,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      currency: json['currency'] as String?,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : null,
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : null,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
      'lat': lat,
      'lng': lng,
      'type': type.toString().split('.').last,
      'category': category,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
      'address': address,
      'phone': phone,
      'website': website,
      'openingHours': openingHours,
      'price': price,
      'currency': currency,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
    };
  }

  /// 复制并修改
  LocationModel copyWith({
    String? id,
    String? name,
    String? nameEn,
    double? lat,
    double? lng,
    LocationType? type,
    String? category,
    double? rating,
    String? imageUrl,
    String? description,
    String? address,
    String? phone,
    String? website,
    List<String>? openingHours,
    double? price,
    String? currency,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      type: type ?? this.type,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      openingHours: openingHours ?? this.openingHours,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

/// 位置筛选条件
class LocationFilter {
  final String? type;
  final String? category;
  final double? minRating;
  final double? maxPrice;
  final LatLngBounds? bounds;

  LocationFilter({
    this.type,
    this.category,
    this.minRating,
    this.maxPrice,
    this.bounds,
  });

  bool matches(LocationModel location) {
    if (type != null && location.type.toString().split('.').last != type) {
      return false;
    }
    if (category != null && location.category != category) {
      return false;
    }
    if (minRating != null && location.rating < minRating!) {
      return false;
    }
    if (maxPrice != null && (location.price == null || location.price! > maxPrice!)) {
      return false;
    }
    if (bounds != null) {
      if (!bounds!.contains(location.latLng)) {
        return false;
      }
    }
    return true;
  }
}
