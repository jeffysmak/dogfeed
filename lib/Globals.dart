import 'package:flutter/material.dart';

class Globals {
  static void showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String generatePetId(String uid) {
    String code = '';
    for (int i = 0; i < uid.length; i++) {
      if (i % 4 == 0) {
        code = '$code${uid[i]}';
      }
    }
    return code.toUpperCase();
  }
}
