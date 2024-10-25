import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class CSOutlinedButtonTheme{
  CSOutlinedButtonTheme._(); //to avoiding creating instances

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      foregroundColor: CSAccentColor,
      side: const BorderSide(color: CSAccentColor),
      padding: const EdgeInsets.symmetric(vertical: CSButtonHeight),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      foregroundColor: CSWhiteColor,
      side: const BorderSide(color: CSAccentColor),
      padding: const EdgeInsets.symmetric(vertical: CSButtonHeight),
    ),
  );
}