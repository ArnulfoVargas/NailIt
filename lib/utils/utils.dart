
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
  static Color getContrastColor(Color color, {int? darkLuminance, int? lightLuminance}) {
    int d = 0;

    // Counting the perceptive luminance - human eye favors green color...
    double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    if (luminance > 0.5) {
      d = darkLuminance ?? 0; // bright colors - black font
    } else {
      d = lightLuminance ?? 255; // dark colors - white font
    }

    return Color.fromARGB(color.alpha, d, d, d);
  }

  static List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
}