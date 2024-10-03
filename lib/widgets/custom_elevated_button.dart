import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const CustomElevatedButton({super.key, this.onPressed, this.text = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, 
              blurRadius: 10, 
              spreadRadius: 0,
              blurStyle: BlurStyle.outer
            )
          ]
        ),
        child: Material(
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: onPressed,
            child: Ink(
              decoration: const BoxDecoration(
                color: Color(0xFF229799),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(text, 
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}