import 'package:flutter/material.dart';

/// A class to centralize the theme colors used in the Pomodoro Timer app.
class ThemeColors {
  static const Color primary = Colors.white; // Light red
  static const Color primaryDark = Color(0xFFD32F2F); // Dark red
  static const Color secondary = Color(0xFF81C784); // Green
  static const Color background =
      Colors.white; //gradient with the primery for the background
  static const Color breakColor = Color(0xFFD32F2F); // Green for break text
  static const Color textColor = Colors.black87; // Black text color
  static const Color indicatorBackground =
      Color(0xFFFFCDD2); // Grey for progress indicator background
  static const Color progress = Color(0xFFD32F2F); // Amber for session progress
  static const Color progressBackground =
      Color(0xFFFFCDD2); // Grey for session progress background
}
