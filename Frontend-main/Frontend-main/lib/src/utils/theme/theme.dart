import 'package:codesafari/src/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:codesafari/src/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:codesafari/src/utils/theme/widget_themes/text_field_theme.dart';
import 'package:codesafari/src/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';

class CSAppTheme {
  CSAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: CSTextTheme.lightTextTheme,
    outlinedButtonTheme: CSOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: CSElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: CSTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: CSTextTheme.darkTextTheme,
    outlinedButtonTheme: CSOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: CSElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: CSTextFormFieldTheme.darkInputDecorationTheme,
  );
}
