import 'package:flutter/material.dart';

class KAppBar {
  static AppBarTheme appBarTheme(Color bgColor, Color fgColor) => AppBarTheme(
    backgroundColor: bgColor,
    foregroundColor: fgColor,
    centerTitle: true,
  );
}
