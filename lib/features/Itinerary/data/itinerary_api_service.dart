import 'package:egyptopia/core/config.dart';
import 'package:egyptopia/features/Itinerary/data/models/itinerary_request.dart';
import 'package:egyptopia/features/Itinerary/data/models/itinerary_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItineraryService {
  static const String baseUrl = '${AppConfig.apiBaseUrl}/api/itinerary';

  Future<ItineraryResponse> getItinerary({
    required String userId,
    required ItineraryRequest request,
  }) async {
    final url = Uri.parse('$baseUrl/$userId/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );
    if (response.statusCode == 200) {
      return ItineraryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch itinerary');
    }
  }

   Future<ItineraryResponse?> getLatestItinerary(String userId) async {
    final url = Uri.parse('$baseUrl/$userId/');
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      return ItineraryResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch latest itinerary');
    }
  }
}

