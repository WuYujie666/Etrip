import 'dart:convert';
import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_model.dart';

/// 位置数据服务
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// 获取示例位置数据（埃及旅游景点）
  List<LocationModel> getSampleLocations() {
    return [
      // ========== 景点 (Places) ==========
      LocationModel(
        id: 'pyramids',
        name: '吉萨金字塔',
        nameEn: 'Giza Pyramids',
        lat: 29.9792,
        lng: 31.1342,
        type: LocationType.place,
        category: '历史遗迹',
        rating: 4.9,
        imageUrl: 'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?w=800',
        description: '世界七大奇迹之一，古埃及文明的象征。吉萨金字塔群包括胡夫金字塔、卡夫拉金字塔和孟卡拉金字塔，是古埃及法老的陵墓。',
        address: 'Al Haram, Giza Governorate',
        phone: '+20 2 3388 3292',
        website: 'https://www.egypt.travel',
        openingHours: ['07:00 - 17:00'],
        price: 200,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'sphinx',
        name: '狮身人面像',
        nameEn: 'Great Sphinx',
        lat: 29.9753,
        lng: 31.1376,
        type: LocationType.place,
        category: '历史遗迹',
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1539650116455-251d9a063595?w=800',
        description: '守护金字塔的神秘雕像，拥有狮子的身体和人的头部，象征着法老的智慧和力量。',
        address: 'Giza Plateau, Giza',
        openingHours: ['08:00 - 16:00'],
        price: 100,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'luxor_temple',
        name: '卢克索神庙',
        nameEn: 'Luxor Temple',
        lat: 25.6995,
        lng: 32.6391,
        type: LocationType.place,
        category: '历史遗迹',
        rating: 4.7,
        imageUrl: 'https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=800',
        description: '古埃及宗教建筑的杰作，建于公元前1400年左右，是献给阿蒙神的圣地。',
        address: 'Luxor City, Luxor Governorate',
        openingHours: ['06:00 - 22:00'],
        price: 160,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'karnak',
        name: '卡尔纳克神庙',
        nameEn: 'Karnak Temple',
        lat: 25.7188,
        lng: 32.6573,
        type: LocationType.place,
        category: '历史遗迹',
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1566125882500-87e10f726cdc?w=800',
        description: '世界上最大的古代宗教建筑群，历经数千年建造，拥有壮观的柱厅和方尖碑。',
        address: 'Karnak, Luxor Governorate',
        openingHours: ['06:00 - 17:30'],
        price: 200,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'abu_simbel',
        name: '阿布辛贝神庙',
        nameEn: 'Abu Simbel',
        lat: 22.3372,
        lng: 31.6258,
        type: LocationType.place,
        category: '历史遗迹',
        rating: 4.9,
        imageUrl: 'https://images.unsplash.com/photo-1539650116455-251d9a063595?w=800',
        description: '拉美西斯二世的宏伟神庙，以其四座巨大的法老雕像而闻名，是努比亚遗址的一部分。',
        address: 'Abu Simbel, Aswan Governorate',
        openingHours: ['05:00 - 18:00'],
        price: 255,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'valley_kings',
        name: '帝王谷',
        nameEn: 'Valley of the Kings',
        lat: 25.7402,
        lng: 32.6014,
        type: LocationType.place,
        category: '历史遗迹',
        rating: 4.7,
        imageUrl: 'https://images.unsplash.com/photo-1545231027-637d2f6210f8?w=800',
        description: '法老们的安息之地，包含63座皇家陵墓，包括著名的图坦卡蒙墓。',
        address: 'Valley of the Kings, Luxor',
        openingHours: ['06:00 - 17:00'],
        price: 260,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'cairo_museum',
        name: '埃及博物馆',
        nameEn: 'Egyptian Museum',
        lat: 30.0478,
        lng: 31.2336,
        type: LocationType.place,
        category: '博物馆',
        rating: 4.6,
        imageUrl: 'https://images.unsplash.com/photo-1566125882500-87e10f726cdc?w=800',
        description: '收藏世界上最丰富的古埃及文物，包括图坦卡蒙的黄金面具。',
        address: 'Tahrir Square, Cairo',
        openingHours: ['09:00 - 17:00'],
        price: 200,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'citadel',
        name: '萨拉丁城堡',
        nameEn: 'Saladin Citadel',
        lat: 30.0287,
        lng: 31.2599,
        type: LocationType.place,
        category: '历史遗迹',
        rating: 4.5,
        imageUrl: 'https://images.unsplash.com/photo-1539650116455-251d9a063595?w=800',
        description: '开罗的地标性城堡，由萨拉丁于12世纪建造，俯瞰整个城市。',
        address: 'Al Abageyah, Cairo Governorate',
        openingHours: ['08:00 - 17:00'],
        price: 180,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'aswan_dam',
        name: '阿斯旺大坝',
        nameEn: 'Aswan High Dam',
        lat: 23.9705,
        lng: 32.8772,
        type: LocationType.place,
        category: '现代建筑',
        rating: 4.3,
        imageUrl: 'https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=800',
        description: '世界七大水坝之一，对埃及的农业和电力供应至关重要。',
        address: 'Aswan Governorate',
        openingHours: ['08:00 - 16:00'],
        price: 0,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'philae_temple',
        name: '菲莱神庙',
        nameEn: 'Philae Temple',
        lat: 24.0253,
        lng: 32.8842,
        type: LocationType.place,
        category: '历史遗迹',
        rating: 4.6,
        imageUrl: 'https://images.unsplash.com/photo-1566125882500-87e10f726cdc?w=800',
        description: '位于尼罗河上的美丽神庙，供奉伊西斯女神，需要乘船前往。',
        address: 'Aswan Governorate',
        openingHours: ['07:00 - 17:00'],
        price: 200,
        currency: 'EGP',
      ),

      // ========== 活动 (Activities) ==========
      LocationModel(
        id: 'nile_cruise',
        name: '尼罗河游轮晚餐',
        nameEn: 'Nile Dinner Cruise',
        lat: 30.0500,
        lng: 31.2333,
        type: LocationType.activity,
        category: '游船',
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1545231027-637d2f6210f8?w=800',
        description: '在尼罗河上享受浪漫晚餐，欣赏开罗夜景和传统表演。',
        address: 'Nile River, Cairo',
        price: 500,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'hot_air_balloon',
        name: '卢克索热气球',
        nameEn: 'Luxor Hot Air Balloon',
        lat: 25.7200,
        lng: 32.6500,
        type: LocationType.activity,
        category: '冒险',
        rating: 4.9,
        imageUrl: 'https://images.unsplash.com/photo-1507608616759-54f48f0af0ee?w=800',
        description: '日出时分乘坐热气球，俯瞰卢克索的壮丽景色和尼罗河。',
        address: 'West Bank, Luxor',
        price: 1200,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'desert_safari',
        name: '撒哈拉沙漠探险',
        nameEn: 'Sahara Desert Safari',
        lat: 29.9800,
        lng: 31.1300,
        type: LocationType.activity,
        category: '冒险',
        rating: 4.7,
        imageUrl: 'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800',
        description: '体验撒哈拉沙漠的刺激，包括四驱车越野、滑沙和贝都因人营地晚餐。',
        address: 'Giza Desert',
        price: 800,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'red_sea_snorkeling',
        name: '红海浮潜',
        nameEn: 'Red Sea Snorkeling',
        lat: 27.2579,
        lng: 33.8116,
        type: LocationType.activity,
        category: '水上运动',
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
        description: '探索红海的绚丽海底世界，观赏珊瑚礁和热带鱼。',
        address: 'Sharm El-Sheikh',
        price: 600,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'camel_ride',
        name: '金字塔骆驼骑行',
        nameEn: 'Pyramid Camel Ride',
        lat: 29.9790,
        lng: 31.1340,
        type: LocationType.activity,
        category: '体验',
        rating: 4.5,
        imageUrl: 'https://images.unsplash.com/photo-1539650116455-251d9a063595?w=800',
        description: '骑着骆驼穿越沙漠，从独特角度欣赏金字塔。',
        address: 'Giza Plateau',
        price: 200,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'felucca_ride',
        name: '三桅帆船巡游',
        nameEn: 'Felucca Ride',
        lat: 24.0889,
        lng: 32.8998,
        type: LocationType.activity,
        category: '游船',
        rating: 4.6,
        imageUrl: 'https://images.unsplash.com/photo-1545231027-637d2f6210f8?w=800',
        description: '乘坐传统的埃及帆船，在尼罗河上悠闲巡游。',
        address: 'Aswan Nile River',
        price: 300,
        currency: 'EGP',
      ),

      // ========== 事件 (Events) ==========
      LocationModel(
        id: 'sound_light_pyramids',
        name: '金字塔声光秀',
        nameEn: 'Pyramids Sound & Light Show',
        lat: 29.9785,
        lng: 31.1345,
        type: LocationType.event,
        category: '表演',
        rating: 4.6,
        imageUrl: 'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?w=800',
        description: '金字塔前的震撼灯光表演，讲述古埃及的历史和传说。',
        address: 'Giza Pyramids',
        openingHours: ['19:00 - 21:00', '20:00 - 22:00'],
        price: 300,
        currency: 'EGP',
      ),
      LocationModel(
        id: 'nile_festival',
        name: '尼罗河节',
        nameEn: 'Nile Festival',
        lat: 30.0444,
        lng: 31.2357,
        type: LocationType.event,
        category: '节日',
        rating: 4.7,
        imageUrl: 'https://images.unsplash.com/photo-1545231027-637d2f6210f8?w=800',
        description: '庆祝尼罗河的年度盛典，包括音乐、舞蹈和传统活动。',
        address: 'Cairo Nile Corniche',
        startTime: DateTime(2024, 8, 15),
        endTime: DateTime(2024, 8, 20),
      ),
      LocationModel(
        id: 'ramadan_lantern',
        name: '斋月灯笼节',
        nameEn: 'Ramadan Lantern Festival',
        lat: 30.0500,
        lng: 31.2600,
        type: LocationType.event,
        category: '节日',
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1545231027-637d2f6210f8?w=800',
        description: '开罗老城区的传统庆祝活动，街道挂满彩色灯笼。',
        address: 'Al-Muizz Street, Cairo',
        startTime: DateTime(2024, 3, 10),
        endTime: DateTime(2024, 4, 9),
      ),
      LocationModel(
        id: 'sun_festival',
        name: '阿布辛贝太阳节',
        nameEn: 'Abu Simbel Sun Festival',
        lat: 22.3372,
        lng: 31.6258,
        type: LocationType.event,
        category: '节日',
        rating: 4.9,
        imageUrl: 'https://images.unsplash.com/photo-1539650116455-251d9a063595?w=800',
        description: '每年两次的奇观，阳光穿透神庙照亮最深处雕像。',
        address: 'Abu Simbel Temple',
        startTime: DateTime(2024, 2, 22),
        endTime: DateTime(2024, 2, 22),
      ),
    ];
  }

  /// 根据筛选条件获取位置
  List<LocationModel> getFilteredLocations(LocationFilter filter) {
    final locations = getSampleLocations();
    return locations.where((loc) => filter.matches(loc)).toList();
  }

  /// 根据类型获取位置
  List<LocationModel> getLocationsByType(LocationType type) {
    return getSampleLocations().where((loc) => loc.type == type).toList();
  }

  /// 搜索位置
  List<LocationModel> searchLocations(String query) {
    if (query.isEmpty) return getSampleLocations();
    
    final lowerQuery = query.toLowerCase();
    return getSampleLocations().where((loc) {
      return loc.name.toLowerCase().contains(lowerQuery) ||
          loc.nameEn.toLowerCase().contains(lowerQuery) ||
          loc.category.toLowerCase().contains(lowerQuery) ||
          loc.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// 根据ID获取位置
  LocationModel? getLocationById(String id) {
    try {
      return getSampleLocations().firstWhere((loc) => loc.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取附近的位置
  List<LocationModel> getNearbyLocations(LatLng center, double radiusInKm) {
    return getSampleLocations().where((loc) {
      final distance = _calculateDistance(
        center.latitude,
        center.longitude,
        loc.lat,
        loc.lng,
      );
      return distance <= radiusInKm;
    }).toList();
  }

  /// 计算两点之间的距离（公里）- Haversine公式
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // 地球半径（公里）
    
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    
    final a = 
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) * math.cos(_toRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
    
    final c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * math.pi / 180;
  }
}


