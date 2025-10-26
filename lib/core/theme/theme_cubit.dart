import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _themeKey = 'isDarkMode';
  final SharedPreferences _prefs;

  ThemeCubit(this._prefs)
      : super(
          _prefs.getBool(_themeKey) == true ? ThemeMode.dark : ThemeMode.light,
        );

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newMode);
    _prefs.setBool(_themeKey, newMode == ThemeMode.dark);
  }
}
