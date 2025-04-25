import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      )),
      appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.white)),
      colorScheme: lightColorScheme.copyWith(surface: Colors.white));

  static final dark = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      )),
      appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(color: Colors.white)),
      colorScheme: darkColorScheme.copyWith(surface: Colors.black));

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: primaryColor,
    primaryContainer: Color(0xFF640AFF),
    secondary: Color(0xFF03DAC5),
    secondaryContainer: Color(0xFF0AE1C5),
    surface: Color(0xFFFAFBFB),
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: primaryColor,
    primaryContainer: Color(0xFF640AFF),
    secondary: Color(0xFF03DAC5),
    secondaryContainer: Color(0xFF0AE1C5),
    surface: Color(0xFF151515),
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Color(0xFFD3D2E6),
    onSurface: Color(0xFFC9C7DB),
    brightness: Brightness.dark,
  );

  static const Color primaryColor = Color(0xff93C249);
  static const Color backgroundColor = Color(0xFFeff2f6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color lightGray = Color(0xffceced2);
  static const Color hintDarkGray = Color(0xff8F8F8F);
  static const Color blackColor = Color(0xFF000000);
  static const Color hintBgColor = Color(0xFFF2F2F2);
  static const Color lightPurple = Color(0xFF6472D2);

  //Button Colors
  static const Color primaryButtonColor = primaryColor;
  static const Color secondaryButtonColor = Color(0xFFEEF0F2);

  //Text Colors
  static const Color primaryTextColor = Color(0xFF182132);
  static const Color secondaryTextColor = Color(0xFFB9C0C7);
  static const Color navGrey = Color(0xFFB7B7B7);
  static const Color whiteAndGrey = Color(0xFFF1EDE7);
  static const Color lightRose = Color(0xFFFCB5B5);
  static const Color orange = Color(0xFFFC763E);
  static const Color pampas = Color(0xFFF9F8F6);
  static const Color darkBlue = Color(0xFF353C70);

  //State Colors
  static const Color warningTextColor = Color(0xFFCB5A2A);
  static const Color warningBgColor = Color(0xFFFFEAE1);
  static const Color successTextColor = Color(0xFF38A160);
  static const Color successBgColor = Color(0xFFEEF7F1);
  static const Color errorTextColor = Color(0xFFE24C4C);
  static const Color errorBgColor = Color(0xFFFEECEC);

  //Util Colors
  static const Color dividerColor = Color(0xFFCB5A2A);
  static const Color borderColor = Color(0xffe8e8e8);
}
