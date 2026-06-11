import 'package:flutter/material.dart';
import 'package:etrip/features/Itinerary/data/itinerary_api_service.dart';
import 'package:etrip/features/auth/data/services/local_storage_service.dart';
import 'package:etrip/features/Itinerary/data/models/itinerary_response.dart';
import 'package:etrip/features/Itinerary/presentation/views/itinerary_step_one.dart';
import 'package:etrip/features/Itinerary/presentation/views/itinerary_step_two.dart';
import 'package:etrip/features/Itinerary/presentation/views/itinerary_result_view.dart';

class ItineraryGate extends StatefulWidget {
  const ItineraryGate({super.key});

  @override
  State<ItineraryGate> createState() => _ItineraryGateState();
}

class _ItineraryGateState extends State<ItineraryGate> {
  Future<ItineraryResponse?>? futureLatestItinerary;

  // 0=step one, 1=step two, 2=result
  int itineraryStep = 0;
  Map<String, dynamic>? collectedArgs;

  @override
  void initState() {
    super.initState();
    _loadItinerary();
  }

  void _loadItinerary() {
    final uid = LocalStorageService().currentUid;
    if (uid != null) {
      setState(() {
        futureLatestItinerary = ItineraryService().getLatestItinerary(uid);
        itineraryStep = 2;
      });
    } else {
      setState(() {
        futureLatestItinerary = Future.value(null);
        itineraryStep = 0;
      });
    }
  }

  void _startNewItinerary() {
    setState(() {
      itineraryStep = 0;
      collectedArgs = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (itineraryStep == 2) {
      // If we have collected args from step two, show result directly
      if (collectedArgs != null) {
        return ItineraryResultView(
          args: collectedArgs!,
          onStartNew: _startNewItinerary,
        );
      }

      // Otherwise try loading existing itinerary
      return FutureBuilder<ItineraryResponse?>(
        future: futureLatestItinerary,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return ItineraryStepOne(
              onStepTwo: (args) {
                setState(() {
                  collectedArgs = args;
                  itineraryStep = 1;
                });
              },
            );
          }
          final itinerary = snapshot.data!;
          final args = {
            'noOfDays': itinerary.noOfDays,
            'categoryWeights': itinerary.plan.values
                .expand((places) => places.map((e) => e.category))
                .toSet()
                .toList(),
            'tourismTypeWeights': itinerary.plan.values
                .expand((places) => places.map((e) => e.tourismType))
                .toSet()
                .toList(),
            'budget': itinerary.description,
            'popularity': '',
            'withWho': '',
          };
          return ItineraryResultView(
            args: args,
            onStartNew: _startNewItinerary,
          );
        },
      );
    } else if (itineraryStep == 1) {
      return ItineraryStepTwo(
        noOfDays: collectedArgs!["noOfDays"],
        budget: collectedArgs!["budget"],
        popularity: collectedArgs!["popularity"],
        withWho: collectedArgs!["withWho"],
        tourismTypeWeights:
            List<String>.from(collectedArgs!["tourismTypeWeights"]),
        onItineraryCreated: (stepTwoArgs) {
          setState(() {
            collectedArgs = Map<String, dynamic>.from(stepTwoArgs);
            itineraryStep = 2;
          });
        },
      );
    } else {
      return ItineraryStepOne(
        onStepTwo: (stepOneArgs) {
          setState(() {
            collectedArgs = stepOneArgs;
            itineraryStep = 1;
          });
        },
      );
    }
  }
}
