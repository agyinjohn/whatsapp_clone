import 'package:flutter/material.dart';

import '../constants/colours.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
          backgroundColor: tabColor),
      child: Text(
        text,
        style: const TextStyle(color: blackColor),
      ),
    );
  }
}
