import 'package:amazonclone/common/widgets/bottom_bar.dart';
import 'package:amazonclone/features/address/screens/address_screen.dart';
import 'package:amazonclone/features/admin/screens/add_product_screen.dart';
import 'package:amazonclone/features/auth/screens/auth_screen.dart';
import 'package:amazonclone/features/home/screens/category_deals_screen.dart';
import 'package:amazonclone/features/home/screens/home_screen.dart';
import 'package:amazonclone/features/orders_details/screens/order_details.dart';
import 'package:amazonclone/features/products_details/screens/products_details.dart';
import 'package:amazonclone/features/search/screens/search_screen.dart';
import 'package:amazonclone/models/order.dart';
import 'package:amazonclone/models/product.dart';
import 'package:flutter/material.dart';

const String authScreen = "/auth-screen";
const String homeScreen = "/home-screen";
const String actualHome = "/actual-home";
const String addProduct = "/addProduct";
const String categoryDeals = "/category-deals";
const String searchScreen = "/search-screen";
const String productDetails = "/product-details";
const String addressScreen = "/address-screen";
const String orderDetails = "/order-details";

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case authScreen:
      return _goPage(const AuthScreen(), routeSettings);
    case homeScreen:
      return _goPage(const HomeScreen(), routeSettings);
    case actualHome:
      return _goPage(const BottomBar(), routeSettings);
    case addProduct:
      return _goPage(const AddProductScreen(), routeSettings);
    case categoryDeals:
      String category = routeSettings.arguments as String;
      return _goPage(CategoryDealsScreen(category: category), routeSettings);
    case searchScreen:
      String search = routeSettings.arguments as String;
      return _goPage(
          SearchScreen(
            searchQuery: search,
          ),
          routeSettings);
    case productDetails:
      Product product = routeSettings.arguments as Product;
      return _goPage(ProductDetailsScreen(product: product), routeSettings);
    case addressScreen:
      String totalAmount = routeSettings.arguments as String;

      return _goPage(
          AddressScreen(
            totalAmount: totalAmount,
          ),
          routeSettings);
    case orderDetails:
      Order order = routeSettings.arguments as Order;

      return _goPage(OderDetails(order: order), routeSettings);
    default:
      return MaterialPageRoute(
        builder: (_) => const Center(
          child: Text("Screen does no exist"),
        ),
      );
  }
}

_goPage(Widget page, RouteSettings settings) {
  return MaterialPageRoute(
      settings: settings,
      builder: (_) {
        return page;
      });
}
