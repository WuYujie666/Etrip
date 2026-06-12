import 'package:etrip/core/constants.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/search/presentation/widgets/search_result_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:etrip/features/search/data/search_item.dart';
import 'package:etrip/features/search/data/unified_search_service.dart';
import 'package:etrip/features/places/data/models/place_model.dart';
import 'package:etrip/core/widgets/reusable_screen.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnifiedSearchScreen extends StatefulWidget {
  final Future<List<PlaceModel>> Function() fetchPlaces;

  const UnifiedSearchScreen({
    super.key,
    required this.fetchPlaces,
  });

  @override
  State<UnifiedSearchScreen> createState() => _UnifiedSearchScreenState();
}

class _UnifiedSearchScreenState extends State<UnifiedSearchScreen> {
  List<PlaceModel>? _places;

  bool _loading = true;
  bool _error = false;

  String _query = '';
  List<SearchItem> _results = [];

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
      final places = await widget.fetchPlaces();
      setState(() {
        _places = places;
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
      if (_places != null) {
        _results = UnifiedSearchService.search(
          query: _query,
          places: _places!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
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
                  style: GoogleFonts.lato(fontSize: 16),
                  decoration: InputDecoration(
                    hintStyle: GoogleFonts.imFellFrenchCanonSc(
                      color: const Color(0xFF7D848D),
                    ),
                    hintText: Translations.tr('search_hint', lang),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 13),
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
                          Text(Translations.tr('error_loading_data', lang)),
                          TextButton(
                            onPressed: _fetchAllData,
                            child: Text(Translations.tr('retry', lang)),
                          )
                        ],
                      ),
                    );
                  }
                  if (_query.isEmpty) {
                    return Center(
                      child: Text(
                        Translations.tr('start_typing', lang),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    );
                  }

                  if (_results.isEmpty) {
                    return Center(
                      child: Text(
                        Translations.tr('no_results', lang),
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.only(
                        top: 12, left: 4, right: 4, bottom: 8),
                    children: [
                      if (_results.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, bottom: 4, top: 12),
                          child: Text(
                            Translations.tr('places_section', lang),
                            style: GoogleFonts.merriweather(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: .7,
                            ),
                          ),
                        ),
                        ..._results.map(
                          (item) => SearchResultCard(
                            item: item,
                            places: _places,
                          ),
                        ),
                        const VerticalSpace(1),
                      ],
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