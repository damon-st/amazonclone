// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id, email, name, password, address, type, token;

  final List<dynamic> cart;
  User(
      {required this.address,
      required this.id,
      required this.name,
      required this.password,
      required this.token,
      required this.type,
      required this.email,
      required this.cart});

  factory User.fromMap(Map data) {
    return User(
        cart: List<Map<String, dynamic>>.from(
          data["cart"]?.map(
            (x) => Map<String, dynamic>.from(x),
          ),
        ),
        email: data["email"] ?? "",
        address: data["address"] ?? "",
        id: data["_id"] ?? "",
        name: data["name"] ?? "",
        password: data["password"] ?? "",
        token: data["token"] ?? "",
        type: data["type"] ?? "");
  }

  factory User.fromJson(String source) {
    return User.fromMap(jsonDecode(source));
  }

  Map<String, dynamic> get toMap => {
        "email": email,
        "address": address,
        "id": id,
        "name": name,
        "password": password,
        "token": token,
        "type": type,
        "cart": cart,
      };
  String get toJson => jsonEncode(toMap);

  User copyWith({
    String? id,
    email,
    name,
    password,
    address,
    type,
    token,
    List<dynamic>? cart,
  }) {
    return User(
        email: email ?? this.email,
        address: address ?? this.address,
        cart: cart ?? this.cart,
        id: id ?? this.id,
        name: name ?? this.name,
        password: password ?? this.password,
        token: token ?? this.token,
        type: type ?? this.type);
  }
}
