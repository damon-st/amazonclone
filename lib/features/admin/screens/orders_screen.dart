import 'package:amazonclone/common/widgets/loader.dart';
import 'package:amazonclone/features/account/widgets/single_product.dart';
import 'package:amazonclone/features/admin/services/admin_services.dart';
import 'package:amazonclone/models/order.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];
  final AdminServices adminServices = AdminServices();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loader()
        : GridView.builder(
            itemCount: orders.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (c, index) {
              final order = orders[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, orderDetails, arguments: order);
                },
                child: SizedBox(
                  height: 140,
                  child: SingleProduct(image: order.products[0].images[0]),
                ),
              );
            });
  }
}
