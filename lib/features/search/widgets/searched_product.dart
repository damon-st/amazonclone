import 'package:amazonclone/common/widgets/starts.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchedProduct extends StatelessWidget {
  const SearchedProduct({super.key, required this.product});
  final Product product;

  Future<Map<String, dynamic>> rating(BuildContext context) async {
    double totalRating = 0;
    double avgRating = 0;
    double myRating = 0;
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    if (product.ratings != null) {
      await Future.forEach(product.ratings!, (Rating r) {
        totalRating += r.rating;
        if (r.userId == userProvider.id) {
          myRating = r.rating;
        }
      });
      if (totalRating != 0) {
        avgRating = totalRating / product.ratings!.length;
      }
    }
    return {
      "avgRating": double.parse(avgRating.toString()),
      "myRating": myRating
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 5,
                    ),
                    child: Text(
                      product.name,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 5,
                    ),
                    child: FutureBuilder<Map>(
                        initialData: const {"avgRating": 0.0, "myRating": 0.0},
                        future: rating(context),
                        builder: (c, s) {
                          return Stars(rating: s.data!["avgRating"]);
                        }),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 5,
                    ),
                    child: Text(
                      "\$${product.price}",
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    child: const Text(
                      "Eligible for FREE shiping",
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: const Text(
                      "In stock",
                      style: TextStyle(
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
