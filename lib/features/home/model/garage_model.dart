class GarageModel {
  final String name;
  final double rating;
  final int reviews;
  final double distance;
  final String status;
  final List<String> tags;
  final String imageUrl;

  GarageModel({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.distance,
    required this.status,
    required this.tags,
    required this.imageUrl,
  });
}
