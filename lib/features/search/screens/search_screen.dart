import 'package:amazonclone/common/widgets/loader.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/features/home/widgets/address_box.dart';
import 'package:amazonclone/features/search/services/search_services.dart';
import 'package:amazonclone/features/search/widgets/searched_product.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.searchQuery});
  final String searchQuery;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> products = [];

  bool loading = true;
  SearchService searchService = SearchService();

  @override
  void initState() {
    super.initState();
    fetchSearchProduct();
  }

  void fetchSearchProduct() async {
    products = await searchService.fetchSearchProducts(
        context: context, searchQuery: widget.searchQuery);

    loading = false;
    setState(() {});
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushReplacementNamed(context, searchScreen, arguments: query);
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
              )
            ],
          ),
        ),
      ),
      body: loading
          ? const Loader()
          : Column(
              children: [
                const AddressBox(),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, productDetails,
                                    arguments: product);
                              },
                              child: SearchedProduct(product: product));
                        }))
              ],
            ),
    );
  }
}
