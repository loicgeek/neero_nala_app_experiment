import 'package:flutter/material.dart';

class ThemeLight {
  data() {
    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFFC58C46),
      ),
    );
  }
}
