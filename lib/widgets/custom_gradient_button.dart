import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class CustomGradientButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  const CustomGradientButton({
    super.key, 
    this.onPressed, 
    this.text = ""
  });

  @override
  Widget build(BuildContext context) {
    return GradientElevatedButton(
      onPressed: onPressed, 
      style: GradientElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10)
          )
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: onPressed != null ? const [
            Color(0xFF2C3E50),
            Color(0xFF4CA1AF)
            // Color(0xFF134E5E),
            // Color(0xFF71B280),
          ] : const [
            Color(0xFF2C3E50),
            Color(0xFF2C3E50),
          ]
        ),
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: onPressed != null ? Text(text,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ) : const Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}