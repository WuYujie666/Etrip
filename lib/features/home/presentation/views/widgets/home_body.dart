import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/mock_data.dart';
import 'package:etrip/core/utils/app_router.dart';
import 'package:etrip/core/utils/assets.dart';
import 'package:etrip/core/widgets/build_category_icon.dart';
import 'package:etrip/features/search/presentation/widgets/custom_search.dart';
import 'package:etrip/core/widgets/space_widget.dart';
import 'package:etrip/features/Profile/bloc/user_state.dart';
import 'package:etrip/features/home/presentation/views/widgets/build_home_section.dart';
import 'package:etrip/features/places/data/models/place_model.dart';
import 'package:etrip/features/places/data/places_api_service.dart';
import 'package:etrip/features/home/presentation/views/widgets/feature_slider.dart';
import 'package:etrip/features/Profile/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final PlacesApiService apiService = PlacesApiService();

  static final Map<String, List<PlaceModel>> _placesCache = {};

  Future<List<PlaceModel>> getOrFetch({
    required String cacheKey,
    required Future<List<PlaceModel>> Function() fetcher,
  }) async {
    if (_placesCache.containsKey(cacheKey)) {
      return _placesCache[cacheKey]!;
    } else {
      final data = await fetcher();
      _placesCache[cacheKey] = data;
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserBloc>().state;
    final lang = context.watch<LocaleCubit>().state.languageCode;
    String? userId;
    if (userState is UserLoaded) {
      userId = userState.user.id;
    }
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        const VerticalSpace(2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              AssetsData.fixedLogo,
            ),
          ],
        ),
        const VerticalSpace(2),
        CustomSearch(
          fetchPlaces: () => apiService.fetchAllPlaces(),
          fetchEvents: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            return mockEvents;
          },
          fetchActivities: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            return mockActivities;
          },
        ),
        const VerticalSpace(1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userId != null
                  ? Translations.tr('recommended_for_you', lang)
                  : Translations.tr('top_places', lang),
              style: GoogleFonts.merriweather(
                color: const Color(0xFF1F2544),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push(AppRouter.kPlaces, extra: {
                  if (userId != null) 'user_id': userId,
                  'is_recommended': userId != null,
                });
              },
              child: Text(
                Translations.tr('all_places', lang),
                style: GoogleFonts.merriweather(
                  color: Colors.black,
                  shadows: [
                    const Shadow(
                      color: Colors.white,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        FutureBuilder<List<PlaceModel>>(
          future: userId != null
              ? apiService.fetchRecommendedPlaces(userId)
              : getOrFetch(
                  cacheKey: 'top_places',
                  fetcher: () => apiService.fetchPlacesRated(),
                ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('${Translations.tr('error', lang)}: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(Translations.tr('no_recommended', lang)));
            }
            return FeatureSlider(
              places: snapshot.data!,
              width: 300,
              onTap: (place) {
                if (place != null) {
                  context.push(AppRouter.kPlaceDetails, extra: place);
                }
              },
            );
          },
        ),
        const VerticalSpace(2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BuildCategoryIcon(
              icon: Icons.place,
              label: Translations.tr('places', lang),
              route: AppRouter.kPlaces,
            ),
            BuildCategoryIcon(
              icon: Icons.event,
              label: Translations.tr('events', lang),
              route: AppRouter.kEvents,
            ),
            BuildCategoryIcon(
              icon: Icons.directions_walk,
              label: Translations.tr('activities', lang),
              onTap: () {
                final userState = context.read<UserBloc>().state;
                if (userState is! UserLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          Translations.tr('login_required_activities', lang)),
                      backgroundColor: Colors.black87,
                    ),
                  );
                } else {
                  context.push(AppRouter.kActivities);
                }
              },
            ),
            BuildCategoryIcon(
              icon: Icons.thunderstorm_outlined,
              label: Translations.tr('weather', lang),
              onTap: () {
                final userState = context.read<UserBloc>().state;
                if (userState is! UserLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          Translations.tr('login_required_weather', lang)),
                      backgroundColor: Colors.black87,
                    ),
                  );
                } else {
                  context.push(AppRouter.kWeather);
                }
              },
            ),
            BuildCategoryIcon(
              icon: Icons.smart_toy_outlined,
              label: Translations.tr('chatbot', lang),
              onTap: () {
                final userState = context.read<UserBloc>().state;
                if (userState is! UserLoaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          Translations.tr('login_required_chatbot', lang)),
                      backgroundColor: Colors.black87,
                    ),
                  );
                } else {
                  context.push(AppRouter.kChatbot);
                }
              },
            ),
          ],
        ),
        const VerticalSpace(1),
        ...sections(lang).map((section) => BuildHomeSection(
              cacheKey: section['cacheKey']!,
              title: section['title']!,
              apiTitle: section['apiTitle']!,
              emptyText: section['emptyText']!,
              failText: section['failText']!,
              getOrFetch: getOrFetch,
              apiService: apiService,
            )),
      ],
    );
  }
}
