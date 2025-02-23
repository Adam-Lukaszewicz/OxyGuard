import 'package:flutter/material.dart';

class Themes {
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: const Color(0xfffcfcfc),
    appBarTheme: const AppBarTheme(color: Color(0xfffcfcfc)),
    useMaterial3: true,
    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
            elevation: WidgetStatePropertyAll(5),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(width: 0.1))),
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            foregroundColor: WidgetStatePropertyAll(Color(0xff1874d4)))),
  );
  static final ThemeData dark = ThemeData(
    scaffoldBackgroundColor: const Color(0xff2d2d30),
    useMaterial3: true,
    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
            elevation: WidgetStatePropertyAll(5),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                side: BorderSide(width: 0.1))),
            backgroundColor: WidgetStatePropertyAll(Color(0xff434347)),
            foregroundColor: WidgetStatePropertyAll(Colors.white))),
  );
}
