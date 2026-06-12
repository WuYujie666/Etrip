import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/features/places/data/models/place_model.dart';
import 'package:etrip/features/places/data/places_api_service.dart';
import 'package:flutter/material.dart';
import 'package:etrip/features/home/presentation/views/widgets/feature_slider.dart';
import 'package:etrip/features/home/presentation/views/widgets/feature_section.dart';
import 'package:etrip/core/utils/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:etrip/core/utils/app_router.dart';

List<Map<String, String>> sections(String lang) => [
  {
    'cacheKey': 'cultural',
    'title': "  ${Translations.tr('cultural', lang)}",
    'apiTitle': "Cultural and Historical Attractions",
    'emptyText': Translations.tr('no_cultural', lang),
    'failText': Translations.tr('fail_cultural', lang),
  },
  {
    'cacheKey': 'natural',
    'title': "  ${Translations.tr('natural', lang)}",
    'apiTitle': 'Natural Attractions',
    'emptyText': Translations.tr('no_natural', lang),
    'failText': Translations.tr('fail_natural', lang),
  },
  {
    'cacheKey': 'entertainment',
    'title': "  ${Translations.tr('entertainment', lang)}",
    'apiTitle': 'Entertainment and Modern Attractions',
    'emptyText': Translations.tr('no_entertainment', lang),
    'failText': Translations.tr('fail_entertainment', lang),
  },
];

class BuildHomeSection extends StatelessWidget {
  final String cacheKey;
  final String title;
  final String apiTitle;
  final String emptyText;
  final String failText;
  final Future<List<PlaceModel>> Function(
      {required String cacheKey,
      required Future<List<PlaceModel>> Function() fetcher}) getOrFetch;
  final PlacesApiService apiService;

  const BuildHomeSection({
    super.key,
    required this.cacheKey,
    required this.title,
    required this.apiTitle,
    required this.emptyText,
    required this.failText,
    required this.getOrFetch,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PlaceModel>>(
      future: getOrFetch(
        cacheKey: cacheKey,
        fetcher: () => apiService.fetchPlacesByTourismType(apiTitle),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(failText));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(emptyText));
        }
        return FeatureSection(
          title: title,
          onSeeAll: () {
            context.push(AppRouter.kPlaces, extra: {
              'tourism_type': apiTitle,
            });
          },
          slider: Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.defaultSize!),
            child: FeatureSlider(
              places: snapshot.data!,
              width: SizeConfig.screenWidth! * 0.4,
              onTap: (place) {
                if (place != null) {
                  context.push(AppRouter.kPlaceDetails, extra: place);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
