import 'dart:convert';

import 'package:amazonclone/constants/error_handling.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/constants/utils.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchService {
  Future<List<Product>> fetchSearchProducts(
      {required BuildContext context, required String searchQuery}) async {
    List<Product> producList = [];
    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse("$urlApi/api/products/search/$searchQuery"),
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
}
