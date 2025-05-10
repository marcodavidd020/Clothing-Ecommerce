class ProductItemModel {
  final String id;
  final String imageUrl;
  final String name;
  final double price;
  final double? originalPrice;
  final bool isFavorite;
  final double averageRating;
  final int? reviewCount;

  ProductItemModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.originalPrice,
    this.isFavorite = false,
    this.averageRating = 0.0,
    this.reviewCount,
  });
}
