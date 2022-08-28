import 'package:amazonclone/common/widgets/loader.dart';
import 'package:amazonclone/features/admin/models/sales.dart';
import 'package:amazonclone/features/admin/services/admin_services.dart';
import 'package:amazonclone/features/admin/widgets/category_products_chart.dart';
import 'package:charts_flutter/flutter.dart' as chatrs;
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int totalSales = 0;
  List<Sales> earnings = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  void getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData["totalEarnings"];
    earnings = earningData["sales"];
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loader()
        : Column(
            children: [
              Text(
                "\$$totalSales",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 250,
                child: CategoryProductsChart(seriesList: [
                  chatrs.Series(
                      id: "Sales",
                      data: earnings,
                      domainFn: (sales, int) {
                        return sales.label;
                      },
                      measureFn: (sale, int) {
                        return sale.earning;
                      })
                ]),
              )
            ],
          );
  }
}
