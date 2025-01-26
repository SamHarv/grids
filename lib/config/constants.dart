import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const blue = Color.fromARGB(255, 1, 76, 99);
const red = Color.fromARGB(255, 137, 0, 0);
const yellow = Color.fromARGB(255, 186, 150, 0);
const green = Color.fromARGB(255, 59, 88, 40);
const orange = Color.fromARGB(255, 174, 61, 0);
const pink = Color.fromARGB(255, 127, 115, 132);
const black = Color.fromARGB(255, 33, 33, 33);
const white = Color.fromARGB(255, 245, 245, 245);

final darkModeFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: Colors.white,
    fontSize: 18,
  ),
);

final darkModeLargeFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 24,
  ),
);

final darkModeSmallFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: Colors.white,
    fontSize: 16,
  ),
);

final lightModeFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: Colors.black,
    fontSize: 18,
  ),
);

final lightModeLargeFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 24,
  ),
);

final lightModeSmallFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: Colors.black,
    fontSize: 16,
  ),
);

// Display an alert dialog with a message
void showMessage(String message, BuildContext context, bool isDarkMode) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Center(
          child: Text(
            message,
            style: isDarkMode ? darkModeLargeFont : lightModeLargeFont,
          ),
        ),
      );
    },
  );
}

const gapH20 = SizedBox(height: 20);

const gapH10 = SizedBox(height: 10);
