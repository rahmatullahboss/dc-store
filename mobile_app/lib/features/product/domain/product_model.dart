class Product {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final double? compareAtPrice;
  final String? featuredImage;
  final List<String> images;
  final String? categoryId;
  final bool isFeatured;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.price,
    this.compareAtPrice,
    this.featuredImage,
    this.images = const [],
    this.categoryId,
    this.isFeatured = false,
    this.stock = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      compareAtPrice: json['compareAtPrice'] != null
          ? (json['compareAtPrice'] as num).toDouble()
          : null,
      featuredImage: json['featuredImage'] as String?,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      categoryId: json['categoryId'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      stock: json['stock'] as int? ?? 0,
    );
  }
}
