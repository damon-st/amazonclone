import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key, required this.text, required this.onTap, this.colorBtn})
      : super(key: key);
  final String text;
  final VoidCallback onTap;
  final Color? colorBtn;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          50,
        ),
        primary: colorBtn,
      ),
      child: Text(
        text,
        style: TextStyle(color: colorBtn == null ? Colors.white : Colors.black),
      ),
    );
  }
}
