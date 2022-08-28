import 'dart:convert';

import 'package:amazonclone/constants/error_handling.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/constants/utils.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressService {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.post(
        Uri.parse("$urlApi/api/save-user-address"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token
        },
        body: jsonEncode({
          "address": address,
        }),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            final user = userProvider.user
                .copyWith(address: jsonDecode(response.body)["address"]);
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await http.post(
        Uri.parse("$urlApi/api/order"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.user.token
        },
        body: jsonEncode({
          "cart": userProvider.user.cart,
          "address": address,
          "totalPrice": totalSum,
        }),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Your order has been placed!");
            final user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromModel(user);
          });
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }
}
