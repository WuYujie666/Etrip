import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/utils/assets.dart';
import 'package:egyptopia/core/utils/size_config.dart';
import 'package:egyptopia/core/widgets/build_category_icon.dart';
import 'package:egyptopia/core/widgets/custom_search.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/Profile/bloc/user_state.dart';
import 'package:egyptopia/features/auth/data/egyptopia_api_service.dart';
import 'package:egyptopia/features/home/presentation/views/widgets/feature_section.dart';
import 'package:egyptopia/features/home/presentation/views/widgets/feature_slider.dart';
import 'package:egyptopia/features/Profile/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = EgyptopiaApiService();

    final userState = context.watch<UserBloc>().state;
    String? userId;
    if (userState is UserLoaded) {
      userId = userState.user.id;
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        const VerticalSpace(2),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Image.asset(
            AssetsData.fixedLogo,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined,
                size: 27.5, color: Colors.white),
            onPressed: () {},
          ),
        ]),
        const VerticalSpace(2),
        const CustomSearch(),
        const VerticalSpace(1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              userId != null ? "  Recommended For You" : "  Top Places",
              style: GoogleFonts.montserrat(
                  color: const Color(0xFF1F2544),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
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
                style: GoogleFonts.inter(
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
        FutureBuilder<List<Map<String, dynamic>>>(
          future: userId != null
              ? apiService.fetchRecommendedPlaces(userId)
              : apiService.fetchPlacesRated(),
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
        FutureBuilder<List<Map<String, dynamic>>>(
          future: apiService
              .fetchPlacesByTourismType("Cultural and Historical Attractions"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text(
                      'Failed to load Cultural and Historical Attractions'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No Cultural and Historical Attractions found'));
            }
            return FeatureSection(
              title: "  Cultural and Historical",
              titleStyle: GoogleFonts.montserrat(
                color: const Color(0xFF1F2544),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onSeeAll: () {
                context.push(AppRouter.kPlaces, extra: {
                  'tourism_type': 'Cultural and Historical Attractions',
                });
              },
              slider: FeatureSlider(
                places: snapshot.data!,
                width: SizeConfig.screenWidth! * 0.4,
                onTap: (place) {
                  if (place != null) {
                    context.push(AppRouter.kPlaceDetails, extra: place);
                  }
                },
              ),
            );
          },
        ),
        const VerticalSpace(1),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: apiService
              .fetchPlacesByTourismType("Religious and Spiritual Attractions"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text(
                      'Failed to load Religious and Spiritual Attractions'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No Religious and Spiritual Attractions found'));
            }
            return FeatureSection(
              title: "  Religious and Spiritual",
              titleStyle: GoogleFonts.montserrat(
                color: const Color(0xFF1F2544),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onSeeAll: () {
                context.push(AppRouter.kPlaces, extra: {
                  'tourism_type': 'Religious and Spiritual Attractions',
                });
              },
              slider: FeatureSlider(
                places: snapshot.data!,
                width: SizeConfig.screenWidth! * 0.4,
                onTap: (place) {
                  if (place != null) {
                    context.push(AppRouter.kPlaceDetails, extra: place);
                  }
                },
              ),
            );
          },
        ),
        const VerticalSpace(1),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: apiService.fetchPlacesByTourismType("Natural Attractions"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Failed to load Natural Attractions'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Natural Attractions found'));
            }
            return FeatureSection(
              title: "  Natural Attractions",
              titleStyle: GoogleFonts.montserrat(
                color: const Color(0xFF1F2544),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onSeeAll: () {
                context.push(AppRouter.kPlaces, extra: {
                  'tourism_type': 'Natural Attractions',
                });
              },
              slider: FeatureSlider(
                places: snapshot.data!,
                width: SizeConfig.screenWidth! * 0.4,
                onTap: (place) {
                  if (place != null) {
                    context.push(AppRouter.kPlaceDetails, extra: place);
                  }
                },
              ),
            );
          },
        ),
        const VerticalSpace(1),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: apiService
              .fetchPlacesByTourismType("Entertainment and Modern Attractions"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text(
                      'Failed to load Entertainment and Modern Attractions'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('No Entertainment and Modern Attractions found'));
            }
            return FeatureSection(
              title: "  Entertainment and Modern",
              titleStyle: GoogleFonts.montserrat(
                color: const Color(0xFF1F2544),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onSeeAll: () {
                context.push(AppRouter.kPlaces, extra: {
                  'tourism_type': 'Entertainment and Modern Attractions',
                });
              },
              slider: FeatureSlider(
                places: snapshot.data!,
                width: SizeConfig.screenWidth! * 0.4,
                onTap: (place) {
                  if (place != null) {
                    context.push(AppRouter.kPlaceDetails, extra: place);
                  }
                },
              ),
            );
          },
        ),
        const VerticalSpace(1),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: apiService.fetchPlacesByTourismType("Medical Attractions"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Failed to load Medical Attractions'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Medical Attractions found'));
            }
            return FeatureSection(
              title: "  Medical Attractions",
              titleStyle: GoogleFonts.montserrat(
                color: const Color(0xFF1F2544),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onSeeAll: () {
                context.push(AppRouter.kPlaces, extra: {
                  'tourism_type': 'Medical Attractions',
                });
              },
              slider: FeatureSlider(
                places: snapshot.data!,
                width: SizeConfig.screenWidth! * 0.4,
                onTap: (place) {
                  if (place != null) {
                    context.push(AppRouter.kPlaceDetails, extra: place);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
