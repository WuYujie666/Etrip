class SearchItem {
  final String id;
  final String type; 
  final String title;
  final String imageUrl;
  final String city;
  final String? rating;
  final String? info;

  SearchItem({
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    required this.city,
    this.rating,
    this.info,
  });
}