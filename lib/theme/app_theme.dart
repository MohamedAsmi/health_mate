import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Main Colors based on your palette
  static const Color primaryColor = Color(0xFF2196F3); // Primary
  static const MaterialColor primaryColorB = Colors.blue; // Primary
  static const Color gray4 = Color(0xFFFFFFFF); // Gray-4
  static const Color gray3 = Color(0xFF8A98AB); // Gray-3
  static const Color gray2 = Color(0xFF4B5768); // Gray-2
  static const Color lightGray = Color(0xFFFFFFFF); // Light Gray (White)
  static const Color vanillaCream = Color(0xFFFDF5E6); // Vanilla Cream
  static const Color beige = Color(0xFFF7E9D4); // Beige
  static const Color sand = Color(0xFFFAF0E6); // Sand

  // Semantic Colors
  static const Color backgroundColor = vanillaCream;
  static const Color surfaceColor = lightGray;
  static const Color secondaryColor = beige;
  static const Color errorColor = Color(0xFFB00020);

  // Text Colors
  static const Color onPrimaryColor = lightGray;
  static const Color onSecondaryColor = gray2;
  static const Color onErrorColor = lightGray;
  static const Color onBackgroundColor = gray2;
  static const Color onSurfaceColor = gray2;

  // Dark Theme Colors
  static const Color darkBackgroundColor = gray2;
  static const Color darkSurfaceColor = Color(0xFF2D3748);
  static const Color darkOnBackgroundColor = gray4;
  static const Color darkOnSurfaceColor = lightGray;

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: gray2,
  );

  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: gray2,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: gray2,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: gray3,
  );

  // Monospace Text Styles using Google Fonts
  static TextStyle monospaceStyle = GoogleFonts.courierPrime(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: gray2,
    letterSpacing: 0.5,
  );

  static TextStyle monospaceSmallStyle = GoogleFonts.courierPrime(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: gray2,
    letterSpacing: 0.5,
  );

  static TextStyle monospaceLargeStyle = GoogleFonts.courierPrime(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: gray2,
    letterSpacing: 0.5,
  );

  static TextStyle monospaceCodeStyle = GoogleFonts.courierPrime(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: gray2,
    letterSpacing: 0.3,
    backgroundColor: const Color(0xFFF5F5F5), // Light gray background for code
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: onPrimaryColor,
        onSecondary: onSecondaryColor,
        onError: onErrorColor,
        onBackground: onBackgroundColor,
        onSurface: onSurfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: sand,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: gray4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: gray4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: surfaceColor,
        shadowColor: gray3.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: darkBackgroundColor,
        surface: darkSurfaceColor,
        onPrimary: onPrimaryColor,
        onSecondary: onSecondaryColor,
        onError: onErrorColor,
        onBackground: darkOnBackgroundColor,
        onSurface: darkOnSurfaceColor,
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurfaceColor,
        foregroundColor: darkOnSurfaceColor,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: gray3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: gray3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: darkSurfaceColor,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
