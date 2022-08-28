import 'dart:convert';

import 'package:amazonclone/constants/error_handling.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/constants/utils.dart';
import 'package:amazonclone/models/user.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //Sign up user

  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
          email: email,
          address: "",
          id: "",
          name: name,
          password: password,
          token: "",
          type: "",
          cart: []);

      final response = await http.post(Uri.parse("$urlApi/api/signup"),
          body: user.toJson,
          headers: {"Content-Type": "application/json; charset=UTF-8"});
      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Success create account");
          });
    } catch (e) {
      showSnackBar(context, "Error $e");
    }
  }

  // sign in user
  void signIngUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(Uri.parse("$urlApi/api/signin"),
          body: jsonEncode({
            "email": email,
            "password": password,
          }),
          headers: {"Content-Type": "application/json; charset=UTF-8"});
      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          final prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.body);
          await prefs.setString(
              "x-auth-token", jsonDecode(response.body)["token"]);
          Navigator.pushNamedAndRemoveUntil(
              context, actualHome, (route) => false);
        },
      );
    } catch (e) {
      showSnackBar(context, "Error $e");
    }
  }

  //Get user data
  void getUserData({
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");
      if (token == null) {
        prefs.setString("x-auth-token", "");
      }
      final tokenRes = await http.post(Uri.parse("$urlApi/api/tokenIsValid"),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token ?? ""
          });

      final response = jsonDecode(tokenRes.body);
      if (response["status"] == "success") {
        //get user data
        final userRes = await http.get(Uri.parse("$urlApi/api/getUserData"),
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
              "x-auth-token": token ?? ""
            });
        if (userRes.statusCode == 200) {
          Provider.of<UserProvider>(context, listen: false)
              .setUser(userRes.body);
        }
      }
    } catch (e) {
      showSnackBar(context, "Error $e");
    }
  }
}
