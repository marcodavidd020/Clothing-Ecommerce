class ProductItemModel {
  final String id;
  final String imageUrl;
  final String name;
  final double price;
  final double? originalPrice;
  final bool isFavorite;

  ProductItemModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.originalPrice,
    this.isFavorite = false,
  });
}
