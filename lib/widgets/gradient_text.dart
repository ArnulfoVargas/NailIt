import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final Gradient gradient;
  final String text;
  final TextStyle? textStyle;

  const GradientText({
    super.key, 
    this.text = "", 
    this.textStyle,
    required this.gradient, 
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTRB(0, 0, bounds.width, bounds.height)
      ),
      child: Text(text, style: textStyle,),
    );
  }
}