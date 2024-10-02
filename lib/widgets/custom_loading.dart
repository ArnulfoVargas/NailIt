
import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final void Function() onLoadFunction;
  final double size;
  final Color color;
  final double thickness;
  const CustomLoading({
    super.key, 
    required this.onLoadFunction, 
    this.size = 50, 
    this.color = Colors.white, 
    this.thickness = 4
  });

  @override
  Widget build(BuildContext context) {
    onLoadFunction();
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: color,
        backgroundColor: Colors.transparent,
        strokeWidth: thickness,
      ),
    );
  }
}