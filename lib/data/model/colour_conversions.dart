import 'package:flutter/material.dart';

import '/controller/constants/constants.dart';

class ColourConversions {
  String getStringFromColour(Color colour) {
    if (colour == blue) {
      return "blue";
    } else if (colour == red) {
      return "red";
    } else if (colour == yellow) {
      return "yellow";
    } else if (colour == green) {
      return "green";
    } else if (colour == orange) {
      return "orange";
    } else if (colour == pink) {
      return "pink";
    } else if (colour == Colors.grey.shade900) {
      return "black";
    } else if (colour == Colors.grey.shade100) {
      return "white";
    } else {
      return "black";
    }
  }

  Color getColourFromString(String colourString) {
    switch (colourString) {
      case "blue":
        return blue;
      case "red":
        return red;
      case "yellow":
        return yellow;
      case "green":
        return green;
      case "orange":
        return orange;
      case "pink":
        return pink;
      case "black":
        return black;
      case "white":
        return white;
      default:
        return black;
    }
  }
}
