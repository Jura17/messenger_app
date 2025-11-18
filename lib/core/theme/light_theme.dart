import 'package:flutter/material.dart';
import 'package:messenger_app/core/theme/custom_colors.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(backgroundColor: AppColors.lightAppBackground),
  scaffoldBackgroundColor: AppColors.lightAppBackground,
  highlightColor: AppColors.highlight,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: AppColors.secondaryLight,
    tertiary: AppColors.tertiaryLight,
    inversePrimary: Colors.grey.shade800,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.lightAppBackground,
    selectedItemColor: AppColors.selectedLight,
    unselectedItemColor: AppColors.unselectedLight,
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateColor.resolveWith(
      (states) => AppColors.highlight,
    ),
  ),
);
