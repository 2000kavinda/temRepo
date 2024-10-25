import 'package:codesafari/src/constants/colors.dart';
import 'package:flutter/material.dart';

class CSTextFormFieldTheme {
  CSTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
          border: OutlineInputBorder(),
          prefixIconColor: CSAccentColor,
          floatingLabelStyle: TextStyle(color: CSAccentColor),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: CSAccentColor)
          ));

  static InputDecorationTheme darkInputDecorationTheme =
  const InputDecorationTheme(
      border: OutlineInputBorder(),
      prefixIconColor: CSAccentColor,
      floatingLabelStyle: TextStyle(color: CSAccentColor),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: CSAccentColor)
      ));
}
