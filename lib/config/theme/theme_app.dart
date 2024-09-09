import 'package:flutter/material.dart';

final List<Color> themeColors = [
  Colors.teal,
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.amber,
  Colors.deepPurple,
  Colors.indigo,
  Colors.cyan,
  Colors.lightBlue,
  Colors.lime,
  Colors.lightGreen,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];

class ThemeApp {
  final int colorSelector;

  ThemeApp({required this.colorSelector});
  ThemeData get themeData {
    return ThemeData(
      colorSchemeSeed: themeColors[colorSelector],
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
