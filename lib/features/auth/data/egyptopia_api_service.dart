import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:egyptopia/features/auth/data/models/egyptopia_user.dart';
import 'package:image_picker/image_picker.dart';

class EgyptopiaApiService {
  static const String _baseUrl = 'http://192.168.1.12:8000/api/users';
  static const String _preferencesBaseUrl =
      'http://192.168.1.12:8000/api/preferences';
  static const String _placesBaseUrl = 'http://192.168.1.12:8000/api/places';

  // Existing user-related methods
  Future<bool> userExists(String id) async {
    final uri = Uri.parse('$_baseUrl/$id/');
    final response = await http.get(uri);
    return response.statusCode == 200;
  }

  Future<void> createUser(EgyptopiaUser user) async {
    final uri = Uri.parse('$_baseUrl/create/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toMap()),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to create user: ${response.body}");
    }
  }

  Future<EgyptopiaUser?> getUserById(String id) async {
    final uri = Uri.parse('$_baseUrl/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return EgyptopiaUser.fromMap(json.decode(response.body));
    }
    return null;
  }

  Future<void> updateUser(EgyptopiaUser user) async {
    final uri = Uri.parse('$_baseUrl/${user.id}/update/');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toMap()),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update user: ${response.body}");
    }
  }

  Future<void> updateUserProfileImage({
    required String userId,
    required XFile image,
  }) async {
    final uri = Uri.parse('$_baseUrl/$userId/update/');
    var request = http.MultipartRequest('PATCH', uri);
    request.files
        .add(await http.MultipartFile.fromPath('profile_img', image.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception("Failed to update image: ${response.body}");
    }
  }

  // Preferences-related methods
  Future<Map<String, dynamic>?> getUserPreferences(String userId) async {
    final uri = Uri.parse('$_preferencesBaseUrl/$userId/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  Future<void> createUserPreferences({
    required String userId,
    required List<String> preferredCategories,
    required List<String> preferredTourismTypes,
    required List<String> preferredCities,
  }) async {
    final uri = Uri.parse('$_preferencesBaseUrl/create/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user': userId,
        'category': preferredCategories,
        'tourism_type': preferredTourismTypes,
        'city': preferredCities,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to create preferences: ${response.body}");
    }
  }

  Future<void> updateUserPreferences({
    required String userId,
    required List<String> preferredCategories,
    required List<String> preferredTourismTypes,
    required List<String> preferredCities,
  }) async {
    final uri = Uri.parse('$_preferencesBaseUrl/$userId/');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user': userId,
        'category': preferredCategories,
        'tourism_type': preferredTourismTypes,
        'city': preferredCities,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update preferences: ${response.body}");
    }
  }

  // Fetch places by tourism type
  Future<List<Map<String, dynamic>>> fetchPlacesByTourismType(
      String tourismType) async {
    final uri = Uri.parse('$_placesBaseUrl/$tourismType/');
    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception(
          'Failed to load places for tourism type: $tourismType, Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // Fetch nearby places
  Future<List<Map<String, dynamic>>> fetchNearbyPlaces(String placeId) async {
    final url = Uri.parse('$_placesBaseUrl/$placeId/nearby/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      List<dynamic> data;
      if (decodedResponse is List) {
        data = decodedResponse;
      } else if (decodedResponse is Map<String, dynamic>) {
        final nearbyPlaces = decodedResponse['nearby_places'];
        if (nearbyPlaces is List) {
          data = nearbyPlaces;
        } else {
          data = [];
        }
      } else {
        data = [];
      }

      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load nearby places for place ID: $placeId');
    }
  }

  // Fetch recommended places based on user ID
  Future<List<Map<String, dynamic>>> fetchRecommendedPlaces(
      String userId) async {
    final url = Uri.parse('$_placesBaseUrl/recommend/$userId/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      List<dynamic> data;
      if (decodedResponse is List) {
        data = decodedResponse;
      } else if (decodedResponse is Map<String, dynamic>) {
        final places = decodedResponse['recommendations'] ??
            decodedResponse['places'] ??
            decodedResponse['data'] ??
            [];
        data = places is List ? places : [];
      } else {
        data = [];
      }

      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load recommended places for user ID: $userId');
    }
  }

  // Fetch rated places for non-logged-in users
  Future<List<Map<String, dynamic>>> fetchPlacesRated() async {
    final url = Uri.parse('http://192.168.1.12:8000/api/places/rated');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      List<dynamic> data;
      if (decodedResponse is List) {
        data = decodedResponse; // Use the list directly
      } else if (decodedResponse is Map<String, dynamic>) {
        data = decodedResponse['places'] ??
            decodedResponse['data'] ??
            decodedResponse['rated'] ??
            [];
      } else {
        data = [];
      }

      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception(
          'Failed to load rated places: Status ${response.statusCode}, Body: ${response.body}');
    }
  }
}
