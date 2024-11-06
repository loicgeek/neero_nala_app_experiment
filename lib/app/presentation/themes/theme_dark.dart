import 'package:flutter/material.dart';

class ThemeDark {
  data() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      primaryColor: Color(0xFFC58C46),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xFFC58C46),
      ),
    );
  }
}
