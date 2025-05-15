import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/widgets/build_category_icon.dart';
import 'package:egyptopia/core/widgets/custom_search.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/Profile/bloc/user_state.dart';
import 'package:egyptopia/features/home/presentation/views/widgets/build_home_section.dart';
import 'package:egyptopia/features/places/data/models/place_model.dart';
import 'package:egyptopia/features/places/data/places_api_service.dart';
import 'package:egyptopia/features/home/presentation/views/widgets/feature_slider.dart'; 
import 'package:egyptopia/features/Profile/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined,
                  size: 27.5, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        const VerticalSpace(2),
        const CustomSearch(),
        const VerticalSpace(1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userId != null ? "  Recommended For You" : "  Top Places",
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
                "All Places",
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
          :getOrFetch(
            cacheKey: 'top_places',
            fetcher: () =>  apiService.fetchPlacesRated(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No recommended places found'));
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BuildCategoryIcon(
              icon: Icons.place,
              label: "Places",
              route: AppRouter.kPlaces,
            ),
            BuildCategoryIcon(
              icon: Icons.event,
              label: "Events",
              route: AppRouter.kEvents,
            ),
            BuildCategoryIcon(
                icon: Icons.restaurant_menu,
                label: "Food",
                route: AppRouter.kFoodStart),
            BuildCategoryIcon(
                icon: Icons.directions_walk,
                label: "Activities",
                route: AppRouter.kActivities),
            BuildCategoryIcon(
                icon: Icons.thunderstorm_outlined,
                label: "Weather",
                route: AppRouter.kWeather),
            BuildCategoryIcon(
                icon: FontAwesomeIcons.redditAlien,
                label: "ChatBot",
                route: AppRouter.kChatbot),
            BuildCategoryIcon(
                icon: Icons.extension,
                label: "Quizzes",
                route: AppRouter.kQuizStart),
          ],
        ),
        const VerticalSpace(1),

        ...sections.map((section) => BuildHomeSection(
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