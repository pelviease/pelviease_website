import 'package:flutter/material.dart';

class AppColors {
  static const Color buttonColor = Color(0xFF543855);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF1F1F1F);
  static const Color cyclamen = Color(0xFFF87EA0);
  static const Color lightcyclamen = Color(0xFFFCBECF);
  static const Color lightViolet = Color(0xFFFFF2FF);
}

const Color buttonColor = Color(0xFF543855);
const Color backgroundColor = Color(0xFFFFFFFF);
const Color textColor = Color(0xFF1F1F1F);
const Color cyclamen = Color(0xFFF87EA0);
const Color lightcyclamen = Color(0xFFFCBECF);
const Color lightViolet = Color(0xFFFFF2FF);
ThemeData buildAppTheme() {
  return ThemeData(
    fontFamily: "Commissioner",
    // Primary color scheme
    primarySwatch: MaterialColor(0xFF543855, {
      50: AppColors.lightViolet,
      100: Color(0xFFE8D5E8),
      200: Color(0xFFD1AAD1),
      300: Color(0xFFBA7FBA),
      400: Color(0xFFA354A3),
      500: AppColors.buttonColor,
      600: Color(0xFF4A3148),
      700: Color(0xFF3F2A3B),
      800: Color(0xFF34232E),
      900: Color(0xFF291C21),
    }),

    primaryColor: AppColors.buttonColor,

    // Color scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.buttonColor,
      secondary: AppColors.cyclamen,
      surface: AppColors.backgroundColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textColor,
    ),

    // Scaffold background
    scaffoldBackgroundColor: AppColors.backgroundColor,

    // App bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.buttonColor,
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.buttonColor,
        side: BorderSide(color: AppColors.buttonColor, width: 1),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Text theme
    textTheme: TextTheme(
      displayLarge:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
      displayMedium:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
      displaySmall:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.bold),
      headlineLarge:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600),
      headlineMedium:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600),
      headlineSmall:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600),
      titleLarge:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w600),
      titleMedium:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),
      titleSmall:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: AppColors.textColor),
      bodyMedium: TextStyle(color: AppColors.textColor),
      bodySmall: TextStyle(color: AppColors.textColor),
      labelLarge:
          TextStyle(color: AppColors.textColor, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: AppColors.textColor),
      labelSmall: TextStyle(color: AppColors.textColor),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightViolet,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.buttonColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.buttonColor.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.buttonColor, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.textColor),
      hintStyle: TextStyle(color: AppColors.textColor.withOpacity(0.6)),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: AppColors.backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // FloatingActionButton theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.cyclamen,
      foregroundColor: Colors.white,
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.buttonColor;
        }
        return null;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.buttonColor;
        }
        return AppColors.textColor.withOpacity(0.6);
      }),
    ),

    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.cyclamen;
        }
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.cyclamen.withOpacity(0.3);
        }
        return null;
      }),
    ),
  );
}
