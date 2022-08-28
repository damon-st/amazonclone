import 'package:amazonclone/common/widgets/loader.dart';
import 'package:amazonclone/features/account/widgets/single_product.dart';
import 'package:amazonclone/features/admin/services/admin_services.dart';
import 'package:amazonclone/models/product.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final adminServece = AdminServices();
  List<Product> productList = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  void fetchAllProducts() async {
    productList = await adminServece.fetchAllProducs(context);
    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  void navigateToAddProduct() async {
    Navigator.pushNamed(context, addProduct);
  }

  void deleteProduct(Product product, int index) async {
    adminServece.deleteProduct(
        context: context,
        product: product,
        onSucces: () {
          productList.removeAt(index);
          if (!mounted) return;
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Loader()
          : GridView.builder(
              itemCount: productList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (c, index) {
                final product = productList[index];
                return _ProductItem(
                    onTapDelete: () {
                      deleteProduct(product, index);
                    },
                    product: product);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddProduct,
        tooltip: "Add a Product",
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem(
      {Key? key, required this.product, required this.onTapDelete})
      : super(key: key);
  final Product product;
  final VoidCallback onTapDelete;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: SingleProduct(
            image: product.images[0],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                product.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            IconButton(
                onPressed: onTapDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.black,
                ))
          ],
        )
      ],
    );
  }
}
