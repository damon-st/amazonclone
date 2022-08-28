import 'package:amazonclone/common/widgets/custom_button.dart';
import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/features/admin/screens/admin_screens.dart';
import 'package:amazonclone/features/admin/services/admin_services.dart';
import 'package:amazonclone/models/order.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:amazonclone/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OderDetails extends StatefulWidget {
  final Order order;
  const OderDetails({super.key, required this.order});

  @override
  State<OderDetails> createState() => _OderDetailsState();
}

class _OderDetailsState extends State<OderDetails> {
  int currentStep = 0;
  final AdminServices adminScreen = AdminServices();
  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, searchScreen, arguments: query);
  }

  //ONLY FOR ADMIN!!
  void changedOrderStatus(int status) async {
    adminScreen.chageOrderStatus(
        context: context,
        status: status + 1,
        order: widget.order,
        onSuccess: () {
          setState(() {
            currentStep += 1;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "View Order details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(
                  10,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Date: "
                        "${formatTime(widget.order.orderedAt)}"),
                    Text(
                      "Order ID: "
                      "${widget.order.id}",
                    ),
                    Text("Order Total: \$"
                        "${widget.order.totalPrice}")
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Purchase Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.order.products.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c, index) {
                      final product = widget.order.products[index];
                      return Row(
                        children: [
                          Image.network(
                            product.images[0],
                            height: 120,
                            width: 120,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Qty: ${widget.order.quantity[index]}",
                                style: const TextStyle(),
                              ),
                            ],
                          )
                        ],
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Tracking",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: Column(
                    children: [
                      Stepper(
                          currentStep: currentStep,
                          controlsBuilder: (c, d) {
                            if (user.type == "admin") {
                              return CustomButton(
                                  text: "Done",
                                  onTap: () {
                                    changedOrderStatus(d.currentStep);
                                  });
                            }
                            return const SizedBox();
                          },
                          steps: [
                            Step(
                              isActive: currentStep > 0,
                              state: currentStep > 0
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: const Text("Pending"),
                              content: const Text(
                                "Your "
                                " order is yet to be delivered",
                              ),
                            ),
                            Step(
                              isActive: currentStep > 1,
                              state: currentStep > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: const Text("Complete"),
                              content: const Text(
                                "Your "
                                " order has benn delivered, your yet "
                                "to sign",
                              ),
                            ),
                            Step(
                              isActive: currentStep > 2,
                              state: currentStep > 2
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: const Text("Received"),
                              content: const Text(
                                "Your "
                                " order has benn delivered an signed by you",
                              ),
                            ),
                            Step(
                              isActive: currentStep >= 3,
                              state: currentStep >= 3
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: const Text("Delivered"),
                              content: const Text(
                                "Your "
                                " order has benn delivered an signed by you",
                              ),
                            ),
                          ])
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(int time) {
    return DateFormat("dd-MM-yyyy HH:mm")
        .format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}
