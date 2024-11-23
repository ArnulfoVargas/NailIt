
import 'package:flutter/material.dart';

class NailUtils {
  static String baseRoute = "nailit-api.onrender.com";
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
        bodySmall: TextStyle(
          color: Colors.black54,
          fontFamily: "Poppins",
          fontWeight: FontWeight.bold,
          fontSize: 14
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

  static showError(BuildContext context, String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color.fromARGB(255, 252, 49, 49),
        dismissDirection: DismissDirection.down,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        content: Text(errorMsg,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      )
    );
  }

  static showLoading(BuildContext context) {
    showDialog(
      context: context, 
      barrierDismissible: false,
      useSafeArea: true,
      builder: (ctx) => const AlertDialog(
        title: Text("Please wait",
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: Colors.black54
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        content: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
              color: Color(0xFF229799),
            ),
          )
        ),
      )
    );
  }
}