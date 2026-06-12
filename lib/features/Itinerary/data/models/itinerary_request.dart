class ItineraryRequest {
  final int noOfDays;
  final Map<String, int> categoryWeights;
  final Map<String, int> tourismTypeWeights;
  final String budget;
  final String popularity;
  final String withWho;
  final String city;

  ItineraryRequest({
    required this.noOfDays,
    required this.categoryWeights,
    required this.tourismTypeWeights,
    required this.budget,
    required this.popularity,
    required this.withWho,
    this.city = '',
  });

  Map<String, dynamic> toJson() => {
        'no_of_days': noOfDays,
        'category_weights': categoryWeights,
        'tourism_type_weights': tourismTypeWeights,
        'budget': budget,
        'popularity': popularity,
        'with_who': withWho,
        'city': city,
      };
}