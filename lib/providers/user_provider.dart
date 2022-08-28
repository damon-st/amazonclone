import 'package:amazonclone/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
      address: "",
      id: "",
      name: "",
      password: "",
      token: "",
      type: "",
      email: "",
      cart: []);

  User get user => _user;

  void setUser(String body) {
    _user = User.fromJson(body);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
