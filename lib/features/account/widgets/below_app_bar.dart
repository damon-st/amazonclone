import 'package:amazonclone/constants/global_variables.dart';
import 'package:amazonclone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BelowAppBar extends StatelessWidget {
  const BelowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: GlobalVariables.appBarGradient,
      ),
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: RichText(
        text: TextSpan(
          text: "Hellow, ",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
          children: [
            TextSpan(
              text: user.name,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
