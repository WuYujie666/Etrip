import 'dart:convert';
import 'package:egyptopia/core/config.dart';
import 'package:http/http.dart' as http;
import 'models/place_model.dart';

class PlacesApiService {
  static const String _baseUrl = '${AppConfig.apiBaseUrl}/api/places';

  // ----------------- Get all places -----------------

  Future<List<PlaceModel>> fetchAllPlaces() async {
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((place) => PlaceModel.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places: Status ${response.statusCode}');
    }
  }

  // ----------------- Filter Options (cities, types, ... etc.) -----------------

  Future<Map<String, List<String>>> fetchFilterOptions() async {
    // ممكن تعمل optimize في المستقبل وتخليها تجيب الفلاتر فقط من EndPoint خاص، حاليا نفس endpoint الأماكن
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List placesData = jsonDecode(utf8.decode(response.bodyBytes));

      final cities = placesData
          .map((place) => place['city_name'].toString())
          .toSet()
          .toList()
        ..sort();
      final tourismTypes = placesData
          .map((place) => place['tourism_type'].toString())
          .toSet()
          .toList()
        ..sort();
      final categories = placesData
          .map((place) => place['category'].toString())
          .toSet()
          .toList()
        ..sort();
      final popularity = placesData
          .map((place) => place['popularity'].toString())
          .toSet()
          .toList()
        ..sort();

      if (!popularity.contains('All')) popularity.insert(0, 'All');

      return {
        'cities': cities,
        'tourismTypes': tourismTypes,
        'categories': categories,
        'popularity': popularity,
      };
    } else {
      throw Exception('Failed to load filter options');
    }
  }

  // ----------------- Get places by tourism type -----------------
  
  Future<List<PlaceModel>> fetchPlacesByTourismType(String tourismType) async {
    final uri = Uri.parse('$_baseUrl/$tourismType/');
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((place) => PlaceModel.fromJson(place)).toList();
    } else {
      throw Exception(
        'Failed to load places for tourism type: $tourismType, Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }

  // ----------------- Get nearby places -----------------

  Future<List<PlaceModel>> fetchNearbyPlaces(String placeId) async {
    final url = Uri.parse('$_baseUrl/$placeId/nearby/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      List data;
      if (decodedResponse is List) {
        data = decodedResponse;
      } else if (decodedResponse is Map<String, dynamic>) {
        final nearbyPlaces = decodedResponse['nearby_places'];
        data = (nearbyPlaces is List) ? nearbyPlaces : [];
      } else {
        data = [];
      }
      return data.map((place) => PlaceModel.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load nearby places for place ID: $placeId');
    }
  }

  // ----------------- Get recommended places by user -----------------

  Future<List<PlaceModel>> fetchRecommendedPlaces(String userId) async {
    final url = Uri.parse('$_baseUrl/recommend/$userId/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      List data;
      if (decodedResponse is List) {
        data = decodedResponse;
      } else if (decodedResponse is Map<String, dynamic>) {
        final places =
            decodedResponse['recommendations'] ??
            decodedResponse['places'] ??
            decodedResponse['data'] ??
            [];
        data = (places is List) ? places : [];
      } else {
        data = [];
      }
      return data.map((place) => PlaceModel.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load recommended places for user ID: $userId');
    }
  }

  // ----------------- Get rated places (for guests) -----------------

  Future<List<PlaceModel>> fetchPlacesRated() async {
    final url = Uri.parse('$_baseUrl/rated');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      List data;
      if (decodedResponse is List) {
        data = decodedResponse;
      } else if (decodedResponse is Map<String, dynamic>) {
        data =
            decodedResponse['places'] ??
            decodedResponse['data'] ??
            decodedResponse['rated'] ??
            [];
      } else {
        data = [];
      }
      return data.map((place) => PlaceModel.fromJson(place)).toList();
    } else {
      throw Exception(
        'Failed to load rated places: Status ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
}