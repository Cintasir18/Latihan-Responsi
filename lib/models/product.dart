class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final String brand;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String thumbnail;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.brand,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final List<dynamic> imageData = json['images'] is List
        ? json['images'] as List<dynamic>
        : <dynamic>[];

    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '-',
      description: json['description']?.toString() ?? '-',
      category: json['category']?.toString() ?? '-',
      brand: json['brand']?.toString() ?? '-',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      thumbnail: json['thumbnail']?.toString() ?? '',
      images: imageData.map((item) => item.toString()).toList(),
    );
  }
}
