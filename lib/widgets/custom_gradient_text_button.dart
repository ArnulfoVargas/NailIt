import 'package:flutter/material.dart';
import 'package:tarea/widgets/widgets.dart';

class CustomGradientTextButton extends StatelessWidget {
  const CustomGradientTextButton({
    super.key, 
    this.text = "", 
    this.textStyle, 
    this.onPressed,
    this.height = 48,
    required this.gradient, 
  });

  final String text;
  final TextStyle? textStyle;
  final double height; 
  final Function()? onPressed;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(0),
      decoration:  BoxDecoration(
        color: onPressed != null ? Colors.transparent : const Color.fromARGB(15, 0, 0, 0),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10, 
            spreadRadius: 0,
            blurStyle: BlurStyle.outer
          )
        ],
      ),
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            disabledBackgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
            overlayColor: const Color.fromARGB(15, 0, 0, 0),
            elevation: 0,
            
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent
          ),
          child: Flexible(
            child: GradientText(
              text: text,
              textStyle: textStyle,
              gradient: gradient
            ),
          )
        ),
      ),
    );
  }
}