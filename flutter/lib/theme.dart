import 'package:flutter/material.dart';

// Custom color scheme: https://crizantlai.medium.com/flutter-how-to-extend-themedata-b5b987a95bb5
extension CustomColorScheme on ColorScheme {
  Color get blue => const Color.fromRGBO(19, 43, 155, 1.0);
  Color get orange => Color.fromRGBO(251, 160, 24, 1);
}
