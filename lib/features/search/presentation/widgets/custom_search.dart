import 'package:egyptopia/features/places/data/models/place_model.dart';
import 'package:egyptopia/features/search/presentation/unified_search_screen.dart';
import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {
  final Future<List<PlaceModel>> Function() fetchPlaces;
  final Future<List<Map<String, dynamic>>> Function() fetchEvents;
  final Future<List<Map<String, dynamic>>> Function() fetchActivities;

  const CustomSearch({
    required this.fetchPlaces,
    required this.fetchEvents,
    required this.fetchActivities,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UnifiedSearchScreen(
            fetchPlaces: fetchPlaces,
            fetchEvents: fetchEvents,
            fetchActivities: fetchActivities,
          ),
        ));
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: const Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search Places, Activities...',
                style: TextStyle(
                  color: Color(0xFF7D848D),
                  fontSize: 16
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}