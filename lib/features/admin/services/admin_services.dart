import 'dart:convert';
import 'dart:io';

import 'package:amazonclone/constants/error_handling.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/constants/utils.dart';
import 'package:amazonclone/features/admin/models/sales.dart';
import 'package:amazonclone/models/order.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quanity,
    required String category,
    required List<File> images,
  }) async {
    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      final cloudinary = CloudinaryPublic("variedadesjastho-com", "w4zxubqz");
      List<String> imagesUrls = [];
      for (var i = 0; i < images.length; i++) {
        final res = await cloudinary
            .uploadFile(CloudinaryFile.fromFile(images[i].path, folder: name));
        imagesUrls.add(res.secureUrl);
      }
      final prodocut = Product(
          name: name,
          description: description,
          category: category,
          quantity: quanity,
          price: price,
          images: imagesUrls);
      final response = await http.post(
        Uri.parse("$urlApi/api/admin/add-product"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.token
        },
        body: prodocut.toJson(),
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Product created succefully");
            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }

  Future<List<Product>> fetchAllProducs(BuildContext context) async {
    List<Product> producList = [];
    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse("$urlApi/api/admin/get-products"),
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

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSucces,
  }) async {
    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;

      final response = await http.delete(
        Uri.parse("$urlApi/api/admin/delete-product"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.token
        },
        body: jsonEncode({
          "id": product.id,
        }),
      );

      httpErrorHandle(
          response: response, context: context, onSuccess: onSucces);
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    List<Order> orerderList = [];
    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse("$urlApi/api/admin/get-orders"),
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
              orerderList.add(Order.fromMap(Map.from(element as Map)));
            });
          });
    } catch (e) {
      showSnackBar(context, "$e");
    }
    return orerderList;
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse("$urlApi/api/admin/analytics"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.token
        },
      );

      httpErrorHandle(
          response: response,
          context: context,
          onSuccess: () async {
            var res = jsonDecode(response.body);
            totalEarning = res["earnings"]["totalEarnings"];
            sales = [
              Sales("Mobiles", res["earnings"]["mobilesEarnings"]),
              Sales("Essentials", res["earnings"]["essentialsEarnings"]),
              Sales("Appliances", res["earnings"]["appliancesEarnings"]),
              Sales("Books", res["earnings"]["booksEarnings"]),
              Sales("Fashion", res["earnings"]["fashionEarnings"]),
            ];
          });
    } catch (e) {
      showSnackBar(context, "$e");
    }
    return {
      "sales": sales,
      "totalEarnings": totalEarning,
    };
  }

  void chageOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    try {
      final userProvider =
          Provider.of<UserProvider>(context, listen: false).user;

      final response = await http.post(
        Uri.parse("$urlApi/api/admin/change-order-status"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": userProvider.token
        },
        body: jsonEncode({
          "id": order.id,
          "status": status,
        }),
      );

      httpErrorHandle(
          response: response, context: context, onSuccess: onSuccess);
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }
}
