import 'colors.dart';
import 'package:flutter/material.dart';

ThemeData buildLightMode() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: white,
    primaryColor: purple,
    appBarTheme: base.appBarTheme.copyWith(
      color: white,
      iconTheme: IconThemeData(color: Colors.black45),
      textTheme: base.textTheme.copyWith(
        bodyText1: TextStyle(color: text),
        bodyText2: TextStyle(color: textWeak),
        headline1:
            TextStyle(color: text, fontSize: 25, fontWeight: FontWeight.w900),
        headline2:
            TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.w900),
        headline3: TextStyle(color: text, fontSize: 17),
      )
    ),
    iconTheme: base.iconTheme.copyWith(
      color: black,
    ),
    floatingActionButtonTheme: base.floatingActionButtonTheme
        .copyWith(backgroundColor: purple, foregroundColor: white),
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: purple,
      colorScheme: base.colorScheme.copyWith(
        secondary: purpleStrong,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    scaffoldBackgroundColor: white,
    cardColor: white,
    textSelectionColor: purpleWeak,
    errorColor: errorColor,
    cursorColor: purple,
    textTheme: base.textTheme.copyWith(
      bodyText1: TextStyle(color: text),
      bodyText2: TextStyle(color: textWeak),
      headline1:
          TextStyle(color: text, fontSize: 25, fontWeight: FontWeight.w900),
      headline2:
          TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.w900),
      headline3: TextStyle(color: text, fontSize: 17),
    ),
  );
}

ThemeData buildDarkMode() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      fillColor: darkBgColor2
    ),
    appBarTheme: base.appBarTheme.copyWith(
      color: Colors.grey[850]
    ),
    brightness: Brightness.dark,
    accentColor: white,
    primaryColor: purple,
    iconTheme: base.iconTheme.copyWith(
      color: white,
    ),
    floatingActionButtonTheme: base.floatingActionButtonTheme
        .copyWith(backgroundColor: purple, foregroundColor: white),
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: purple,
      colorScheme: base.colorScheme.copyWith(
        secondary: purpleStrong,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    cardColor: darkBgColor2,
    textSelectionColor: purpleWeak,
    errorColor: errorColor,
    cursorColor: purple,
    textTheme: base.textTheme.copyWith(
      //bodyText1: TextStyle(color: text),
      //bodyText2: TextStyle(color: textWeak),
      //headline1: TextStyle(color: text, fontSize: 25, fontWeight: FontWeight.w900),
     // headline2: TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.w900),
      headline3: TextStyle(fontSize: 17, color: white),
    ),
  );
}


TextStyle lightH1 =
    TextStyle(color: text, fontSize: 25, fontWeight: FontWeight.w900);

TextStyle lightH2 =
    TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.w900);
