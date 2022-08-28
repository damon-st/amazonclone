import 'package:amazonclone/common/widgets/loader.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/features/account/services/account_services.dart';
import 'package:amazonclone/features/account/widgets/single_product.dart';
import 'package:amazonclone/models/order.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  //Tempory list
  List<Order> orders = [];
  bool loading = true;
  final AccountServices services = AccountServices();
  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await services.fethcMyOrders(context: context);
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: const Text(
                      "Your Orders",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: GlobalVariables.selectedNavBarColor,
                      ),
                    ),
                  ),
                ],
              ),
              //display Orders
              Container(
                width: double.infinity,
                height: 170,
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 20,
                  right: 0,
                ),
                child: ListView.builder(
                    itemCount: orders.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c, index) {
                      final order = orders[index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, orderDetails,
                                arguments: order);
                          },
                          child: SingleProduct(
                              image: order.products[0].images[0]));
                    }),
              ),
            ],
          );
  }
}
