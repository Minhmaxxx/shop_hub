class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final int reviewCount;
  final String category;
  final String description;
  final List<String>? images; // Multiple images
  final bool inStock;
  final int? stock;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.description,
    this.images,
    this.inStock = true,
    this.stock,
  });

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'description': description,
      'images': images,
      'inStock': inStock,
      'stock': stock,
    };
  }

  // Create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      inStock: json['inStock'] ?? true,
      stock: json['stock'],
    );
  }

  // Create Product from Firestore Document
  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      images: data['images'] != null
          ? List<String>.from(data['images'])
          : null,
      inStock: data['inStock'] ?? true,
      stock: data['stock'],
    );
  }

  // Copy with method for updating properties
  Product copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    double? rating,
    int? reviewCount,
    String? category,
    String? description,
    List<String>? images,
    bool? inStock,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      description: description ?? this.description,
      images: images ?? this.images,
      inStock: inStock ?? this.inStock,
      stock: stock ?? this.stock,
    );
  }

  // Format price to Vietnamese currency
  String get formattedPrice {
    return '${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}đ';
  }

  // Get discount percentage (if needed later)
  int? getDiscountPercentage(double? originalPrice) {
    if (originalPrice == null || originalPrice <= price) {
      return null;
    }
    return (((originalPrice - price) / originalPrice) * 100).round();
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}