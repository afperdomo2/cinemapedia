import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get theme {
    return ThemeData(
      colorSchemeSeed: const Color(0xFF2862F5),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue[400],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
