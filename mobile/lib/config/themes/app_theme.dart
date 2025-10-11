import 'package:flutter/material.dart';
import 'package:mobile/config/themes/app_color.dart';

class AppTheme {
  static final appTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xffF3F8FB),
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
      ),
    ),
    fontFamily: 'Inter',
    brightness: Brightness.dark
  );
}