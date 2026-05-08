import 'package:flutter/material.dart';

class AppColors {
  static const creamBackground = Color(0xFFFFF4DF);
  static const orangePrimary = Color(0xFFEF7810);
  static const orangeDark = Color(0xFFD26E00);
  static const orangeDivider = Color(0xFFE07E33);
  static const brownDark = Color(0xFF544941);
  static const greenMuted = Color(0xFF95A397);
  static const greenLight = Color(0xFFB6D9C3);
  static const greenButton = Color(0xFFBDD8C5);
  static const beigeLight = Color(0xFFEADCC1);
}

ThemeData buildAppTheme() {
  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.orangePrimary,
    onPrimary: Color(0xFFFFFFFF),
    secondary: AppColors.greenMuted,
    onSecondary: Color(0xFFFFFFFF),
    error: Colors.red,
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: AppColors.brownDark,
  );

  const base = TextTheme(
    titleLarge: TextStyle(
      fontFamily: 'CarterOne',
      fontSize: 22,
      height: 28 / 22,
      fontWeight: FontWeight.w700,
      color: AppColors.brownDark,
    ),
    titleMedium: TextStyle(
      fontFamily: 'CarterOne',

      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w700,
      color: AppColors.brownDark,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Actor',
      fontSize: 16,
      height: 24 / 16,
      color: AppColors.brownDark,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Actor',
      fontSize: 14,
      height: 20 / 14,
      color: AppColors.brownDark,
    ),
    labelLarge: TextStyle(
      fontFamily: 'CarterOne',
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w700,
      color: AppColors.brownDark,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Actor',
    scaffoldBackgroundColor: AppColors.creamBackground,
    colorScheme: colorScheme,
    textTheme: base,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.creamBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
