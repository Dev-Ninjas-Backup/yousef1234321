class ListingModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final double price;
  final double rating;
  final int reviews;
  final bool isActive;
  ListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    this.isActive = true,
  });
}
