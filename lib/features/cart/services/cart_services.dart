import 'dart:convert';

import 'package:amazonclone/constants/error_handling.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/constants/utils.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/models/user.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final response = await http.delete(
        Uri.parse("$urlApi/api/remove-from-cart/${product.id}"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token
        },
      );
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            User user = userProvider.user
                .copyWith(cart: jsonDecode(response.body)["user"]["cart"]);
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }
}
