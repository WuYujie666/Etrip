import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/search/presentation/widgets/search_result_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:egyptopia/features/search/data/search_item.dart';
import 'package:egyptopia/features/search/data/unified_search_service.dart';
import 'package:egyptopia/features/places/data/models/place_model.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';

class UnifiedSearchScreen extends StatefulWidget {
  final Future<List<PlaceModel>> Function() fetchPlaces;
  final Future<List<Map<String, dynamic>>> Function() fetchEvents;
  final Future<List<Map<String, dynamic>>> Function() fetchActivities;

  const UnifiedSearchScreen({
    super.key,
    required this.fetchPlaces,
    required this.fetchEvents,
    required this.fetchActivities,
  });

  @override
  State<UnifiedSearchScreen> createState() => _UnifiedSearchScreenState();
}

class _UnifiedSearchScreenState extends State<UnifiedSearchScreen> {
  List<PlaceModel>? _places;
  List<Map<String, dynamic>>? _events;
  List<Map<String, dynamic>>? _activities;

  bool _loading = true;
  bool _error = false;

  String _query = '';
  Map<String, List<SearchItem>> _results = {
    "places": [],
    "events": [],
    "activities": []
  };

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final results = await Future.wait([
        widget.fetchPlaces(),
        widget.fetchEvents(),
        widget.fetchActivities(),
      ]);
      setState(() {
        _places = results[0] as List<PlaceModel>;
        _events = results[1] as List<Map<String, dynamic>>;
        _activities = results[2] as List<Map<String, dynamic>>;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  void _onQueryChanged(String val) {
    setState(() {
      _query = val;
      if (_places != null && _events != null && _activities != null) {
        _results = UnifiedSearchService.search(
          query: _query,
          places: _places!,
          events: _events!,
          activities: _activities!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReusableScreen(
      showBackButton: true,
      backgroundColor: kSecondaryColor,
      gradientStops: const [0.1, 0.7],
      imageColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onChanged: _onQueryChanged,
                  style: GoogleFonts.lato(fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: "Search Places, Events, Activities...",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_error) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Error loading data"),
                          TextButton(
                            onPressed: _fetchAllData,
                            child: const Text("Retry"),
                          )
                        ],
                      ),
                    );
                  }
                  if (_query.isEmpty) {
                    return const Center(
                      child: Text(
                        "Start typing to search...",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    );
                  }

                  final nothingFound = (_results["places"]?.isEmpty ?? true) &&
                      (_results["events"]?.isEmpty ?? true) &&
                      (_results["activities"]?.isEmpty ?? true);

                  if (nothingFound) {
                    return const Center(
                      child: Text(
                        "No Results Found",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.only(
                        top: 12, left: 4, right: 4, bottom: 8),
                    children: [
                      if (_results["places"] != null &&
                          _results["places"]!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, bottom: 4, top: 12),
                          child: Text(
                            "Places",
                            style: GoogleFonts.merriweather(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: .7,
                            ),
                          ),
                        ),
                        ..._results["places"]!.map(
                          (item) => SearchResultCard(
                            item: item,
                            places: _places,
                            events: _events,
                            activities: _activities,
                          ),
                        ),
                        const VerticalSpace(1),
                      ],
                      if (_results["events"] != null &&
                          _results["events"]!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, bottom: 4, top: 12),
                          child: Text(
                            "Events",
                            style: GoogleFonts.merriweather(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: .7,
                            ),
                          ),
                        ),
                        ..._results["events"]!.map(
                          (item) => SearchResultCard(
                            item: item,
                            places: _places,
                            events: _events,
                            activities: _activities,
                          ),
                        ),
                        const VerticalSpace(1),
                      ],
                      if (_results["activities"] != null &&
                          _results["activities"]!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, bottom: 4, top: 12),
                          child: Text(
                            "Activities",
                            style: GoogleFonts.merriweather(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: .7,
                            ),
                          ),
                        ),
                        ..._results["activities"]!.map(
                          (item) => SearchResultCard(
                            item: item,
                            places: _places,
                            events: _events,
                            activities: _activities,
                          ),
                        ),
                      ],
                      const VerticalSpace(1),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
