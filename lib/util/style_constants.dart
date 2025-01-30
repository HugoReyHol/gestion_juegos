import 'package:flutter/material.dart';

const double compactMargin = 10;
const double normalMargin = 30;

const double compactTitle = 18;
const double normalTitle = 26;

const double compactText = 14;
const double normalText = 20;

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  primaryColor: Colors.green,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green
  ),
  // colorScheme: ColorScheme.dark(
  //   brightness: Brightness.dark,
  //   primary: Colors.green,
  //   onPrimary: Colors.black54,
  //   surface: Colors.black54
  // )
);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
    useMaterial3: true,
    primaryColor: Colors.green,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.green
    ),
    // colorScheme: ColorScheme.dark(
    //   brightness: Brightness.light,
    //     primary: Colors.green,
    //     onPrimary: Colors.white70,
    //     surface: Colors.white70
    // )
);