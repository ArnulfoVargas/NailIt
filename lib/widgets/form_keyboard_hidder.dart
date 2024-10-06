import 'package:flutter/material.dart';
import 'package:tarea/utils/utils.dart';

class FormKeyboardHidder extends StatelessWidget {
  final Widget child;
  const FormKeyboardHidder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NailUtils.hideKeyboard(context);
      },
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: child,
      ),
    );
  }
}