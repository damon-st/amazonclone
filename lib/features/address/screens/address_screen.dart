import 'package:amazonclone/common/widgets/custom_texfield.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/constants/utils.dart';
import 'package:amazonclone/features/address/services/address_service.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key, required this.totalAmount});

  final String totalAmount;
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final flatBuildingController = TextEditingController();
  final areaController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();

  final _addressFormKey = GlobalKey<FormState>();

  final List<PaymentItem> paymentItems = [];
  String addressToBeUse = "";

  final AddressService addressService = AddressService();

  @override
  void initState() {
    super.initState();
    paymentItems.add(PaymentItem(
        label: "Total Amount",
        status: PaymentItemStatus.final_price,
        amount: widget.totalAmount));
  }

  @override
  void dispose() {
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void onPaymentResult(Map<String, dynamic> result) {
    final address =
        Provider.of<UserProvider>(context, listen: false).user.address;
    if (address.isEmpty) {
      addressService.saveUserAddress(context: context, address: address);
    }
    addressService.placeOrder(
      context: context,
      address: address,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void onGooglePaymentResult(Map<String, dynamic> result) {
    final address =
        Provider.of<UserProvider>(context, listen: false).user.address;
    if (address.isEmpty) {
      addressService.saveUserAddress(context: context, address: address);
    }
    addressService.placeOrder(
      context: context,
      address: address,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUse = "";
    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUse = "${flatBuildingController.text}, "
            "${areaController.text}, "
            "${cityController.text} - "
            "${pincodeController.text}";
        // addressService.placeOrder(
        //   context: context,
        //   address: addressToBeUse,
        //   totalSum: double.parse(widget.totalAmount),
        // );
      } else {
        throw Exception("Please enter all values!");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUse = addressFromProvider;
    } else {
      showSnackBar(context, "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              address.address.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Text(
                            address.address,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "OR",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    )
                  : const SizedBox(),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      hintText: "Flat, House no, Building",
                      controller: flatBuildingController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      hintText: "Area, Street",
                      controller: areaController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      hintText: "Pincode",
                      controller: pincodeController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      hintText: "Town/City",
                      controller: cityController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              ApplePayButton(
                onPressed: () {
                  payPressed(address.address);
                },
                width: double.infinity,
                height: 50,
                style: ApplePayButtonStyle.whiteOutline,
                type: ApplePayButtonType.buy,
                paymentConfigurationAsset: "applepay.json",
                onPaymentResult: onPaymentResult,
                paymentItems: paymentItems,
                margin: const EdgeInsets.only(top: 15),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GooglePayButton(
                onPressed: () {
                  payPressed(address.address);
                },
                width: double.infinity,
                height: 50,
                style: GooglePayButtonStyle.black,
                type: GooglePayButtonType.buy,
                paymentConfigurationAsset: "gpay.json",
                onPaymentResult: onGooglePaymentResult,
                paymentItems: paymentItems,
                margin: const EdgeInsets.only(top: 15),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
