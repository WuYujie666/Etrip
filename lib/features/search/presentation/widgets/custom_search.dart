import 'package:etrip/features/places/data/models/place_model.dart';
import 'package:etrip/features/search/presentation/unified_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:etrip/core/localization/translations.dart';
import 'package:etrip/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSearch extends StatelessWidget {
  final Future<List<PlaceModel>> Function() fetchPlaces;

  const CustomSearch({
    required this.fetchPlaces,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleCubit>().state.languageCode;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => UnifiedSearchScreen(
            fetchPlaces: fetchPlaces,
          ),
        ));
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                Translations.tr('search_placeholder', lang),
                style: const TextStyle(
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