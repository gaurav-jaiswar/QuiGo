import 'package:flutter/material.dart';

TextStyle headline = TextStyle(fontWeight: FontWeight.w600, fontSize: 18);
Color primaryColor = Color.fromARGB(255, 107, 64, 64);

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
