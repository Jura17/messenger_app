import 'package:flutter/material.dart';
import 'package:messenger_app/core/theme/custom_colors.dart';

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(backgroundColor: AppColors.darkAppBackground),
  scaffoldBackgroundColor: AppColors.darkAppBackground,
  highlightColor: AppColors.highlight,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade400,
    secondary: AppColors.secondaryDark,
    tertiary: AppColors.tertiaryDark,
    inversePrimary: Colors.grey.shade200,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkAppBackground,
    selectedItemColor: AppColors.selectedDark,
    unselectedItemColor: AppColors.unselectedDark,
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateColor.resolveWith(
      (states) => AppColors.highlight,
    ),
  ),
);
