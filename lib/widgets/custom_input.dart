import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final bool autocorrect;
  final bool hasError;
  final TextEditingController controller;
  final TextInputType inputType;
  final String errorText;
  final bool obscureText;
  final int? maxLenght;
  final String? labelText;
  final IconData? icon;
  final Function(String)? onChanged;
  final Widget? suffixIcon;

  const CustomInput({
    super.key, 
    this.icon, 
    this.labelText, 
    this.suffixIcon, 
    this.obscureText = false,
    this.autocorrect = true, 
    this.hasError = false, 
    this.errorText = "",
    this.inputType = TextInputType.text,
    this.onChanged,
    this.maxLenght, 
    required this.controller, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: hasError ? Colors.red.shade400 : Colors.black12, 
                  blurRadius: 10, 
                  spreadRadius: 0,
                  blurStyle: BlurStyle.outer
                )
              ]
            ),
            child: TextField(
              onChanged: onChanged,
              controller: controller,
              autocorrect: autocorrect,
              cursorColor: Colors.black54,
              obscureText: obscureText,
              keyboardType: inputType,
              maxLength: maxLenght,
              maxLines: inputType == TextInputType.multiline ? null : 1,
              style: const TextStyle(
                fontSize: 15
              ),
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                prefixIcon: Icon(icon, color: hasError ? Colors.red.shade400 : Colors.black38,),
                labelText: labelText,
                labelStyle: TextStyle(
                  color: hasError ? Colors.red.shade400 : Colors.black38,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6,),

          if (hasError)
          Text(errorText, 
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.red.shade400,
              fontSize: 12
            ),
          )
        ],
      ),
    );
  }
}