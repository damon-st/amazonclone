import 'dart:convert';

import 'package:amazonclone/constants/error_handling.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/constants/utils.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts(
      {required BuildContext context, required String category}) async {
    List<Product> producList = [];
    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse("$urlApi/api/products?category=$category"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.token
        },
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            await Future.forEach(jsonDecode(response.body)["products"],
                (element) {
              producList.add(Product.fromMap(Map.from(element as Map)));
            });
          });
    } catch (e) {
      showSnackBar(context, "$e");
    }
    return producList;
  }

  Future<Product> fetchDealOfDay({required BuildContext context}) async {
    Product product = Product(
        name: "",
        description: "",
        category: "",
        quantity: 0,
        price: 0,
        images: []);

    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse("$urlApi/api/deal-of-day"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.token
        },
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            product = Product.fromMap(jsonDecode(response.body)["product"]);
          });
    } catch (e) {
      showSnackBar(context, "$e");
    }
    return product;
  }
}
