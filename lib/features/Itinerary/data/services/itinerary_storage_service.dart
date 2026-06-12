import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/saved_itinerary.dart';

class ItineraryStorageService {
  static const String _boxName = 'saved_itineraries';

  static Box<String>? _box;

  static Future<Box<String>> get _boxInstance async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox<String>(_boxName);
    return _box!;
  }

  static String _key(String userId) => 'itineraries_$userId';

  /// Save a new itinerary for a user.
  static Future<void> save(SavedItinerary itinerary) async {
    final box = await _boxInstance;
    final key = _key(itinerary.userId);
    final list = _loadList(box.get(key));
    list.add(itinerary);
    box.put(key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  /// Load all saved itineraries for a user (newest first).
  static Future<List<SavedItinerary>> loadAll(String userId) async {
    final box = await _boxInstance;
    final key = _key(userId);
    final list = _loadList(box.get(key));
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// Delete a saved itinerary by ID.
  static Future<void> delete(String userId, String itineraryId) async {
    final box = await _boxInstance;
    final key = _key(userId);
    final list = _loadList(box.get(key));
    list.removeWhere((i) => i.id == itineraryId);
    box.put(key, jsonEncode(list.map((e) => e.toJson()).toList()));
  }

  static List<SavedItinerary> _loadList(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    final List<dynamic> arr = jsonDecode(raw) as List<dynamic>;
    return arr
        .map((e) => SavedItinerary.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
