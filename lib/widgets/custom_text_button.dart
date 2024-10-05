import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Color color;
  final void Function()? onPressed;
  const CustomTextButton({super.key, required this.text, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child: Text(text,
        style: TextStyle(
          fontSize: 16,
          color: onPressed == null ? Colors.black26 : color,
          fontWeight: FontWeight.bold
        ),
      )
    );
  }
}