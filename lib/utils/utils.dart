
import 'package:flutter/material.dart';

class NailUtils {
  static getTheme(ctx) {
    return Theme.of(ctx).copyWith(
      appBarTheme: const AppBarTheme(
        color: Color(0xFFF5F5F5),
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
        titleTextStyle: TextStyle(
          fontFamily: "Poppins",
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 30
        ),
      ),
      textTheme: const TextTheme(
        labelMedium: TextStyle(
          fontFamily: "Poppins",
        ),
        labelSmall: TextStyle(
          fontFamily: "Poppins",
        ),
        bodyMedium: TextStyle(
          fontFamily: "Poppins",
          color: Colors.black54
        ),
        bodyLarge: TextStyle(
          fontFamily: "Poppins",
          color: Colors.black87
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          )
        )
      ), 
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          overlayColor: Colors.black12
        )
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5)
    );
  }

  static void hideKeyboard(BuildContext context) {
    final focusNode = FocusScope.of(context);

    if (!focusNode.hasPrimaryFocus && focusNode.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

}