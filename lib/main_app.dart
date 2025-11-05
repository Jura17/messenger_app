import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/core/theme/dark_theme.dart';
import 'package:messenger_app/core/theme/light_theme.dart';
import 'package:messenger_app/core/theme/theme_cubit.dart';
import 'package:messenger_app/features/auth/presentation/screens/auth_gate.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          home: const AuthGate(),
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
        );
      },
    );
  }
}
