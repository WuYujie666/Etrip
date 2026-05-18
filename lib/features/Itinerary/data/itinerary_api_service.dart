import 'package:egyptopia/core/mock_data.dart';
import 'package:egyptopia/features/Itinerary/data/models/itinerary_request.dart';
import 'package:egyptopia/features/Itinerary/data/models/itinerary_response.dart';

class ItineraryService {
  Future<ItineraryResponse> getItinerary({
    required String userId,
    required ItineraryRequest request,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return ItineraryResponse(
      noOfDays: request.noOfDays,
      plan: getMockItineraryPlan(request.noOfDays),
      description: 'A wonderful trip through Egypt exploring cultural and natural highlights.',
    );
  }

  Future<ItineraryResponse?> getLatestItinerary(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null; // Return null so the app shows the itinerary creation flow
  }
}
