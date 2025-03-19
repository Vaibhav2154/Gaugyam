import 'package:gaugyam/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 3),
    borderRadius: BorderRadius.circular(10),
  );
  static final lightThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.whiteColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.whiteColor,
      foregroundColor: AppPallete.gradient1,
      iconTheme: IconThemeData(color: AppPallete.gradient1),
      elevation: 0,
    ),
    chipTheme: ChipThemeData(
      color: MaterialStateProperty.all(AppPallete.primaryFgColor),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),
      errorBorder: _border(AppPallete.errorColor),
    ),
  );
}
