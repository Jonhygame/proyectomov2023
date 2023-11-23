import 'package:flutter/material.dart';

class StylesApp {
  static ThemeData lightTheme(BuildContext context) {
    final theme = ThemeData.light();
    return theme.copyWith(
        //primaryColor: Color.fromARGB(255, 255, 0, 0)
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Color.fromARGB(255, 255, 255, 255),
              background: Color.fromARGB(255, 255, 255, 255),
            ),
        primaryColor: Color.fromARGB(255, 255, 255, 255));
  }

  static ThemeData darkTheme(BuildContext context) {
    final theme = ThemeData.dark();
    return theme.copyWith(
      //primaryColor: Color.fromARGB(255, 255, 0, 0)
      colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Color.fromARGB(0, 0, 255, 255),
          background: Color.fromARGB(0, 0, 255, 255)),
    );
  }
}
