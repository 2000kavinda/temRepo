import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class CSElevatedButtonTheme{
  CSElevatedButtonTheme._(); //to avoiding creating instances

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      foregroundColor: CSWhiteColor,
      backgroundColor: CSAccentColor,
      side: const BorderSide(color: CSAccentColor),
      padding: const EdgeInsets.symmetric(vertical: CSButtonHeight),
    ),
  );
  
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      foregroundColor: CSAccentColor,
      backgroundColor: CSWhiteColor,
      side: const BorderSide(color: CSAccentColor),
      padding: const EdgeInsets.symmetric(vertical: CSButtonHeight),
    ),
  );
}