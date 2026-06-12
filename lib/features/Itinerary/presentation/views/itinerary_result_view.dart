import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/features/Itinerary/data/itinerary_api_service.dart';
import 'package:etrip/features/Itinerary/data/models/itinerary_request.dart';
import 'package:etrip/features/Itinerary/data/models/itinerary_response.dart';
import 'package:etrip/features/Itinerary/data/models/saved_itinerary.dart';
import 'package:etrip/features/Itinerary/data/services/itinerary_storage_service.dart';
import 'package:etrip/features/places/data/models/place_model.dart';
import 'package:etrip/features/places/presentation/widgets/place_card.dart';
import 'package:flutter/material.dart';
import 'package:etrip/features/auth/data/services/local_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ItineraryResultView extends StatefulWidget {
  final Map<String, dynamic> args;
  final VoidCallback? onStartNew;
  const ItineraryResultView({super.key, required this.args, this.onStartNew});

  @override
  State<ItineraryResultView> createState() => _ItineraryResultViewState();
}

class _ItineraryResultViewState extends State<ItineraryResultView> {
  late Future<ItineraryResponse> futureItinerary;
  bool _saved = false;

  @override
  void initState() {
    super.initState();

    // Check if viewing a saved itinerary (has _savedPlaces)
    if (widget.args.containsKey('_savedPlaces')) {
      final places = widget.args['_savedPlaces'] as List<PlaceModel>;
      final noOfDays = widget.args['noOfDays'] as int;
      final plan = <int, List<PlaceModel>>{};
      for (int day = 1; day <= noOfDays; day++) {
        final start = (day - 1) * 2;
        final end = start + 2;
        plan[day] = start < places.length
            ? places.sublist(start, end.clamp(0, places.length))
            : [];
      }
      futureItinerary = Future.value(ItineraryResponse(
        noOfDays: noOfDays,
        plan: plan,
        description: '',
      ));
      _saved = true;
    } else {
      final req = ItineraryRequest(
        noOfDays: widget.args['noOfDays'],
        categoryWeights: {for (var e in widget.args['categoryWeights']) e: 1},
        tourismTypeWeights: {
          for (var e in widget.args['tourismTypeWeights']) e: 1
        },
        budget: widget.args['budget'],
        popularity: widget.args['popularity'],
        withWho: widget.args['withWho'],
        city: widget.args['city'] ?? '',
      );
      final uid = LocalStorageService().currentUid ?? '';
      futureItinerary = ItineraryService()
          .getItinerary(userId: uid, request: req)
          .then((resp) {
        _saveItinerary(resp, uid);
        return resp;
      });
    }
  }

  void _saveItinerary(ItineraryResponse resp, String uid) {
    if (_saved || uid.isEmpty) return;
    final allPlaces = resp.plan.values.expand((l) => l).toList();
    final itinerary = SavedItinerary(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: uid,
      createdAt: DateTime.now(),
      noOfDays: resp.noOfDays,
      city: widget.args['city'] ?? '',
      budget: widget.args['budget'] ?? '',
      withWho: widget.args['withWho'] ?? '',
      tourismTypes:
          List<String>.from(widget.args['tourismTypeWeights'] ?? []),
      placeIds: allPlaces.map((p) => p.id).toList(),
    );
    ItineraryStorageService.save(itinerary);
    _saved = true;
  }

  void _goBack() {
    widget.onStartNew?.call();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 200) {
            _goBack();
          }
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 237, 239, 241), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                AppBar(
                  title: Text(
                    '${Translations.tr('day', lang)} 1-${widget.args['noOfDays']}',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: _goBack,
                  ),
                ),
                Expanded(
                  child: FutureBuilder<ItineraryResponse>(
                    future: futureItinerary,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                "${Translations.tr('error', lang)}: ${snapshot.error}"));
                      }
                      final resp = snapshot.data!;
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (resp.description.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                resp.description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ...resp.plan.entries.expand((entry) => [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "${Translations.tr('day', lang)} ${entry.key}",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1F2544)),
                                  ),
                                ),
                                ...entry.value.map((place) => PlaceCard(
                                      place: place,
                                      onTap: () {
                                        context.push(AppRouter.kPlaceDetails,
                                            extra: place);
                                      },
                                    )),
                                const Divider(),
                              ]),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
