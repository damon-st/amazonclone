import 'dart:io';

import 'package:amazonclone/common/widgets/custom_button.dart';
import 'package:amazonclone/common/widgets/custom_texfield.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/constants/utils.dart';
import 'package:amazonclone/features/admin/services/admin_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final productNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final adminService = AdminServices();
  final _addProductFormKey = GlobalKey<FormState>();
  String category = "Mobiles";
  List<String> productCategories = [
    "Mobiles",
    "Essentials",
    "Appliances",
    "Books",
    "Fashion",
  ];
  List<File> images = [];

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() || images.isNotEmpty) {
      adminService.sellProduct(
          context: context,
          name: productNameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          quanity: double.parse(quantityController.text),
          category: category,
          images: images);
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: const Text(
            "Add product",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                images.isNotEmpty
                    ? CarouselSlider.builder(
                        itemCount: images.length,
                        itemBuilder: (c, index, realIndex) {
                          return Image.file(
                            images[index],
                            height: 200,
                            fit: BoxFit.cover,
                          );
                        },
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ))
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(
                            10,
                          ),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Select Product Images",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: productNameController,
                  hintText: "Product Name",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: "Description ",
                  maxLines: 7,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: priceController,
                  hintText: "Price",
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: quantityController,
                  hintText: "Quantity",
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                      value: category,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      items: productCategories.map((e) {
                        return DropdownMenuItem<String>(
                            value: e, child: Text(e));
                      }).toList(),
                      onChanged: (c) {
                        if (c != null) {
                          setState(() {
                            category = c;
                          });
                        }
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: "Sell",
                  onTap: sellProduct,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
