import 'package:flutter/material.dart';

class CustomLabeledTextbutton extends StatelessWidget {
  final String topText;
  final String buttonText;
  final Function()? onPressed;
  const CustomLabeledTextbutton({
    super.key,
    this.buttonText = "",
    this.topText = "",
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(topText),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            minimumSize: const Size(100, 30),
            foregroundColor: const Color(0xFF229799)
          ),
          onPressed: onPressed, 
          child: Text(buttonText,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold
            ),
          )
        )
      ],
    );
  }
}