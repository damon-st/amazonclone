import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  final String name;
  final String description;
  final String category;
  final double quantity;
  final double price;
  final List<String> images;
  String? id;
  String? userId;
  final List<Rating>? ratings;
  Product({
    required this.name,
    required this.description,
    required this.category,
    required this.quantity,
    required this.price,
    required this.images,
    this.id,
    this.userId,
    this.ratings,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'category': category,
      'quantity': quantity,
      'price': price,
      'images': images,
      'id': id,
      'userId': userId,
      "rating": ratings?.map((e) => e.toMap()).toList(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        ratings: map["ratings"] != null ? formatRating(map["ratings"]) : null,
        userId: map['userId'] != null ? map['userId'] as String : null,
        id: map['_id'] != null ? map['_id'] as String : null,
        name: map['name'] as String,
        description: map['description'] as String,
        category: map['category'] as String,
        quantity: double.parse(map['quantity'].toString()),
        price: double.parse(map['price'].toString()),
        images: List<String>.from(
          (map['images'] as List<dynamic>),
        ));
  }

  static List<Rating> formatRating(List r) {
    List<Rating> t = [];
    for (var element in r) {
      t.add(Rating.fromMap(element));
    }
    return t;
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Rating {
  final String userId;
  final double rating;
  Rating({
    required this.userId,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'rating': rating,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      userId: map['userId'] as String,
      rating: double.parse(map["rating"].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) =>
      Rating.fromMap(json.decode(source) as Map<String, dynamic>);
}
