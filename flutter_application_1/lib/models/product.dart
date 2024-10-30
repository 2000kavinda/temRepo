class Product {
  final String id;
  final String imageUrl;
  final String name;
  final String price;
  final double rating;
  final String description;

  Product({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      imageUrl: json['images'],
      name: json['title'],
      price: json['price'],
      rating: json['rating'],
      description: json['description'],
    );
  }
}
