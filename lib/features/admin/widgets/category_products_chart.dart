import 'package:amazonclone/features/admin/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CategoryProductsChart extends StatelessWidget {
  const CategoryProductsChart({super.key, required this.seriesList});
  final List<charts.Series<Sales, String>> seriesList;
  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}
