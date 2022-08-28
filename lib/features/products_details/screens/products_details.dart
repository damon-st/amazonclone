import 'package:amazonclone/common/widgets/custom_button.dart';
import 'package:amazonclone/common/widgets/starts.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/features/products_details/services/product_details_service.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final Product product;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  double avgRating = 0;
  double myRating = 0;

  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    double totalRating = 0;
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    if (widget.product.ratings != null) {
      await Future.forEach(widget.product.ratings!, (Rating r) {
        totalRating += r.rating;
        if (r.userId == userProvider.id) {
          myRating = r.rating;
        }
      });
      if (totalRating != 0) {
        avgRating = totalRating / widget.product.ratings!.length;
      }
    }
    setState(() {});
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, searchScreen, arguments: query);
  }

  void addToCart() {
    productDetailsServices.addToCart(context: context, product: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(
                    left: 15,
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(
                      7,
                    ),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                          prefixIcon: InkWell(
                            onTap: () {},
                            child: const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 23,
                              ),
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                            top: 10,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                7,
                              ),
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                7,
                              ),
                            ),
                          ),
                          hintText: "Search Amazon.in",
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.product.id}",
                  ),
                  Stars(
                    rating: avgRating,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            CarouselSlider.builder(
              itemCount: widget.product.images.length,
              itemBuilder: (c, index, realIndex) {
                return Image.network(
                  widget.product.images[index],
                  height: 200,
                  fit: BoxFit.contain,
                );
              },
              options: CarouselOptions(
                viewportFraction: 1,
                height: 200,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: RichText(
                  text: TextSpan(
                      text: "Deal Price: ",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                    TextSpan(
                      text: "\$${widget.product.price}",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.description,
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                text: "Buy now",
                onTap: () {},
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                colorBtn: const Color.fromRGBO(254, 216, 19, 1),
                text: "Add to cart",
                onTap: addToCart,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                "Rate The Product",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RatingBar.builder(
                initialRating: myRating,
                minRating: 1,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemBuilder: (c, index) {
                  return const Icon(
                    Icons.star,
                    color: GlobalVariables.secondaryColor,
                  );
                },
                onRatingUpdate: (r) {
                  productDetailsServices.rateProduct(
                      context: context, product: widget.product, rating: r);
                })
          ],
        ),
      ),
    );
  }
}
