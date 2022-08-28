// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazonclone/models/product.dart';

class Order {
  final String id;
  final List<Product> products;
  final List<int> quantity;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;
  final double totalPrice;
  Order({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      "totalPrice": totalPrice,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      totalPrice: map["totalPrice"].toDouble() ?? "0.0",
      id: map['_id'] as String,
      products: List<Product>.from(
          map["products"]?.map((x) => Product.fromMap(x["product"]))),
      quantity: List<int>.from(
        map["products"]?.map(
          (x) => x["quantity"],
        ),
      ),
      address: map['address'] as String,
      userId: map['userId'] as String,
      orderedAt: map['orderedAt'] as int,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
