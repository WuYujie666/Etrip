import 'package:egyptopia/core/mock_data.dart';
import 'models/place_model.dart';

class PlacesApiService {
  // ----------------- Get all places -----------------

  Future<List<PlaceModel>> fetchAllPlaces() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockPlaces;
  }

  // ----------------- Filter Options (cities, types, ... etc.) -----------------

  Future<Map<String, List<String>>> fetchFilterOptions() async {
    await Future.delayed(const Duration(milliseconds: 200));

    final cities = mockPlaces.map((e) => e.cityName).toSet().toList()..sort();
    final tourismTypes =
        mockPlaces.map((e) => e.tourismType).toSet().toList()..sort();
    final categories =
        mockPlaces.map((e) => e.category).toSet().toList()..sort();
    final popularity = <String>['All', 'low', 'medium', 'high'];

    return {
      'cities': cities,
      'tourismTypes': tourismTypes,
      'categories': categories,
      'popularity': popularity,
    };
  }

  // ----------------- Get places by tourism type -----------------

  Future<List<PlaceModel>> fetchPlacesByTourismType(String tourismType) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return mockPlaces
        .where((p) => p.tourismType == tourismType)
        .toList();
  }

  // ----------------- Get nearby places -----------------

  Future<List<PlaceModel>> fetchNearbyPlaces(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = mockPlaces.indexWhere((p) => p.id == placeId);
    if (index < 0 || index >= mockPlaces.length - 1) {
      return mockPlaces.take(3).toList();
    }
    final start = (index + 1) % mockPlaces.length;
    return mockPlaces.sublist(start, (start + 3).clamp(0, mockPlaces.length));
  }

  // ----------------- Get recommended places by user -----------------

  Future<List<PlaceModel>> fetchRecommendedPlaces(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return mockPlaces.take(5).toList();
  }

  // ----------------- Get rated places (for guests) -----------------

  Future<List<PlaceModel>> fetchPlacesRated() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [...mockPlaces]..sort((a, b) => b.rate.compareTo(a.rate));
  }
}
