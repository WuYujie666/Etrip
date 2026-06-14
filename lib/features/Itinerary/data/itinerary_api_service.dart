import 'package:etrip/core/mock_data.dart';
import 'package:etrip/features/Itinerary/data/models/itinerary_request.dart';
import 'package:etrip/features/Itinerary/data/models/itinerary_response.dart';

class ItineraryService {
  Future<ItineraryResponse> getItinerary({
    required String userId,
    required ItineraryRequest request,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final tourismTypes = request.tourismTypeWeights.keys.toList();
    return ItineraryResponse(
      noOfDays: request.noOfDays,
      plan: getMockItineraryPlan(
        request.noOfDays,
        city: request.city.isNotEmpty ? request.city : null,
        tourismTypes: tourismTypes.isNotEmpty ? tourismTypes : null,
      ),
      description: '',
    );
  }

  Future<ItineraryResponse?> getLatestItinerary(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null; // Return null so the app shows the itinerary creation flow
  }
}
