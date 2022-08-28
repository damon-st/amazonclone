import 'package:amazonclone/common/widgets/loader.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/features/home/services/home_services.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/material.dart';

class CategoryDealsScreen extends StatefulWidget {
  const CategoryDealsScreen({super.key, required this.category});
  final String category;
  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product> productsList = [];
  final HomeServices homeServices = HomeServices();
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  void fetchCategoryProducts() async {
    productsList = await homeServices.fetchCategoryProducts(
        context: context, category: widget.category);

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Text(
            widget.category,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: loading
          ? const Loader()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Keep shopping for "
                    "${widget.category}",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: GridView.builder(
                      padding: const EdgeInsets.only(
                        left: 15,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: productsList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 1.4,
                              mainAxisSpacing: 10),
                      itemBuilder: (c, index) {
                        final product = productsList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, productDetails,
                                arguments: product);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 130,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 0.5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      product.images[0],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(
                                  left: 0,
                                  top: 5,
                                  right: 15,
                                ),
                                child: Text(
                                  product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
    );
  }
}
