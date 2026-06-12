import 'dart:convert';

class SavedItinerary {
  final String id;
  final String userId;
  final DateTime createdAt;
  final int noOfDays;
  final String city;
  final String budget;
  final String withWho;
  final List<String> tourismTypes;
  final List<String> placeIds;

  SavedItinerary({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.noOfDays,
    required this.city,
    required this.budget,
    required this.withWho,
    required this.tourismTypes,
    required this.placeIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'createdAt': createdAt.toIso8601String(),
        'noOfDays': noOfDays,
        'city': city,
        'budget': budget,
        'withWho': withWho,
        'tourismTypes': tourismTypes,
        'placeIds': placeIds,
      };

  factory SavedItinerary.fromJson(Map<String, dynamic> json) => SavedItinerary(
        id: json['id'] as String,
        userId: json['userId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        noOfDays: json['noOfDays'] as int,
        city: json['city'] as String,
        budget: json['budget'] as String,
        withWho: json['withWho'] as String,
        tourismTypes: List<String>.from(json['tourismTypes'] as List),
        placeIds: List<String>.from(json['placeIds'] as List),
      );

  String toJsonString() => jsonEncode(toJson());

  static SavedItinerary fromJsonString(String s) =>
      SavedItinerary.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
