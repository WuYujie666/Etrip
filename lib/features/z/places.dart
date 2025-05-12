import 'dart:convert';
import 'package:egyptopia/core/utils/app_router.dart';
import 'package:egyptopia/core/widgets/custom_buttons.dart';
import 'package:egyptopia/core/widgets/reusable_screen.dart';
import 'package:egyptopia/core/widgets/space_widget.dart';
import 'package:egyptopia/features/wishlist/data/model/favorite_model.dart';
import 'package:egyptopia/features/wishlist/presentation/views/widgets/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:egyptopia/core/constants.dart';
import 'package:egyptopia/core/utils/size_config.dart';

class Places extends StatefulWidget {
  const Places({super.key});

  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  late Future<List<dynamic>> eventsFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Filter variables
  String? selectedCity;
  String? selectedTourismType;
  String? selectedPopularity;
  String? selectedCategory;

  // Lists for filter options
  List<String> cities = [];
  List<String> tourismTypes = [];
  List<String> categories = [];
  List<String> popularityOptions = [];

  // Future for fetching filter options
  Future<void>? filterOptionsFuture;
  late List<dynamic> allPlaces = []; // Store all fetched places
  late List<dynamic> displayedPlaces =
      []; // Store filtered or unfiltered places

  @override
  void initState() {
    super.initState();
    filterOptionsFuture = fetchFilterOptions();
    eventsFuture = fetchEvents();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    final extra = state.extra as Map<String, dynamic>?;
    if (extra != null &&
        extra['tourism_type'] != null &&
        selectedTourismType == null) {
      selectedTourismType = extra['tourism_type'] as String;
      setState(() {
        eventsFuture = fetchEvents();
      });
    }
  }

  Future<void> fetchFilterOptions() async {
    try {
      final url = Uri.parse('http://192.168.1.12:8000/api/places');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final placesData =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

        // Extract unique cities
        cities = placesData
            .map((place) => place['city_name'].toString())
            .toSet()
            .toList()
          ..sort();

        // Extract unique tourism types
        tourismTypes = placesData
            .map((place) => place['tourism_type'].toString())
            .toSet()
            .toList()
          ..sort();

        // Extract unique categories
        categories = placesData
            .map((place) => place['category'].toString())
            .toSet()
            .toList()
          ..sort();

        // Extract unique popularity options
        popularityOptions = placesData
            .map((place) => place['popularity'].toString())
            .toSet()
            .toList()
          ..sort();

        // Add "All" option for popularity if not already present
        if (!popularityOptions.contains('All')) {
          popularityOptions.insert(0, 'All');
        }

        setState(() {});
      } else {
        throw Exception(
            'Failed to load filter options: Status ${response.statusCode}');
      }
    } catch (e) {
      return;
    }
  }

  Future<List<dynamic>> fetchEvents() async {
    final url = Uri.parse('http://192.168.1.12:8000/api/places');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      allPlaces = data; // Store all places
      // Apply all filters
      displayedPlaces = filterPlaces(allPlaces);
      return data;
    } else {
      throw Exception('Failed to load events: Status ${response.statusCode}');
    }
  }

  List<dynamic> filterPlaces(List<dynamic> allPlaces) {
    final filtered = allPlaces.where((place) {
      final String city = place['city_name'].toString();
      final String tourismType = place['tourism_type'].toString();
      final String category = place['category'].toString();
      final String popularity = place['popularity'].toString();
      final bool matchesCity = selectedCity == null || city == selectedCity;
      final bool matchesTourismType =
          selectedTourismType == null || tourismType == selectedTourismType;
      final bool matchesCategory =
          selectedCategory == null || category == selectedCategory;
      final bool matchesPopularity = selectedPopularity == null ||
          selectedPopularity == 'All' ||
          popularity == selectedPopularity;
      return matchesCity &&
          matchesTourismType &&
          matchesCategory &&
          matchesPopularity;
    }).toList();
    return filtered;
  }

  void applyFilters() {
    setState(() {
      displayedPlaces =
          filterPlaces(allPlaces); // Apply filters to displayed list
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  void clearFilters() {
    setState(() {
      selectedCity = null;
      selectedTourismType = null;
      selectedCategory = null;
      selectedPopularity = null;
      displayedPlaces = List.from(allPlaces); // Reset to all places
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: FutureBuilder<void>(
          future: filterOptionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading filters: ${snapshot.error}'));
            }

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Filter By',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // City Filter
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCity,
                      items: cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(
                            city,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tourism Type Filter
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Tourism Type',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedTourismType,
                      items: tourismTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTourismType = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Category Filter
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategory,
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Popularity Filter
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Popularity',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedPopularity,
                      items: popularityOptions.map((popularity) {
                        return DropdownMenuItem(
                          value: popularity,
                          child: Text(
                            popularity,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPopularity = value;
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomJoinButton(
                        text: "Clear",
                        onTap: clearFilters,
                        fontSize: 18,
                      ),
                      CustomJoinButton(
                        text: "Apply",
                        onTap: applyFilters,
                        fontSize: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
      body: ReusableScreen(
        showBackButton: true,
        backgroundColor: kSecondaryColor,
        gradientStops: const [0.1, 0.7],
        imageColor: Colors.black,
        child: Padding(
          padding: EdgeInsets.only(top: SizeConfig.defaultSize! * 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Places',
                      style: TextStyle(
                        fontSize: SizeConfig.defaultSize! * 3.25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            offset: Offset(3, 3),
                            blurRadius: 4,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: eventsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    // Use displayedPlaces for rendering
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: displayedPlaces.length,
                      itemBuilder: (context, index) {
                        final place = displayedPlaces[index];
                        return GestureDetector(
                          onTap: () {
                            context.push(AppRouter.kPlaceDetails, extra: place);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 4,
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Image.network(
                                        place['profile_image'],
                                        width: double.infinity,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 12,
                                        left: 12,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            place['category'],
                                            style: GoogleFonts.inter(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromARGB(
                                                  255, 99, 99, 99),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white12,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: FavoriteIcon(
                                            iconSize: 30,
                                            id: place['place_id'].toString(),
                                            type: FavoriteType.place,
                                            title: place['name'],
                                            imageUrl: place['profile_image'],
                                            city: place['city_name'],
                                            category: place['category'],
                                            rate: place['rate'].toString(),
                                            tourismType: place['tourism_type'],
                                            description: place['description']
                                                    ?.toString() ??
                                                '',
                                            googleMapsLink:
                                                place['google_maps_link']
                                                        ?.toString() ??
                                                    '',
                                            totalRates:
                                                place['total_rates'] ?? 0,
                                            carousel: place['carousel'] ?? [],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          place['name'],
                                          style: GoogleFonts.inter(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.travel_explore,
                                              size: 17,
                                              color: Color.fromARGB(
                                                  255, 25, 37, 106),
                                            ),
                                            const HorizantalSpace(0.3),
                                            Text(
                                              place['tourism_type'],
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color.fromARGB(
                                                    255, 119, 119, 119),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.place,
                                                    color: Color.fromARGB(
                                                        255, 25, 37, 106),
                                                    size: 19),
                                                const HorizantalSpace(0.15),
                                                Text(
                                                  place['city_name'],
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color.fromARGB(
                                                        255, 119, 119, 119),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children:
                                                      List.generate(5, (index) {
                                                    double rating =
                                                        double.tryParse(place[
                                                                    'rate']
                                                                .toString()) ??
                                                            0;

                                                    if (rating > 4.5) {
                                                      rating = 5.0;
                                                    } else if (rating > 4.0) {
                                                      rating = 4.5;
                                                    }

                                                    if (rating >= index + 1) {
                                                      return const Icon(
                                                          Icons.star,
                                                          size: 16,
                                                          color: Colors.amber);
                                                    } else if (rating > index &&
                                                        rating < index + 1) {
                                                      return const Icon(
                                                          Icons.star_half,
                                                          size: 16,
                                                          color: Colors.amber);
                                                    } else {
                                                      return const Icon(
                                                          Icons.star_border,
                                                          size: 16,
                                                          color: Colors.amber);
                                                    }
                                                  }),
                                                ),
                                                const HorizantalSpace(0.3),
                                                Text(
                                                  place['rate']
                                                      .toStringAsFixed(1),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        255, 119, 119, 119),
                                                  ),
                                                ),
                                                const HorizantalSpace(0.3),
                                                Text(
                                                  "(${place['total_rates']})"
                                                      .toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(
                                                        255, 119, 119, 119),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
