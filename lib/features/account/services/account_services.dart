import 'dart:convert';

import 'package:amazonclone/constants/error_handling.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/constants/utils.dart';
import 'package:amazonclone/models/order.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fethcMyOrders({required BuildContext context}) async {
    List<Order> oderList = [];
    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse("$urlApi/api/orders/me"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.token
        },
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            await Future.forEach(jsonDecode(response.body)["orders"],
                (element) {
              oderList.add(Order.fromMap(Map.from(element as Map)));
            });
          });
    } catch (e) {
      showSnackBar(context, "$e");
    }
    return oderList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      await sharedPreferences.setString("x-auth-token", "");

      Navigator.pushNamedAndRemoveUntil(context, authScreen, (route) => false);
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }
}
