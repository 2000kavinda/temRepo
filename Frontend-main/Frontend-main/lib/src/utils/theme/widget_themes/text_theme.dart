import 'package:codesafari/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CSTextTheme {
  CSTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    titleLarge: const TextStyle(
      fontFamily: 'PetitCochon',
      color: CSAccentColor,
      fontSize: 60.0,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.montserrat(
      color: CSDarkColor,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: CSDarkColor,
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.poppins(
      color: CSDarkColor,
      fontSize: 22.0,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: GoogleFonts.workSans(
      color: CSDarkColor,
      fontSize: 16.0,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: CSDarkColor,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
    ),
    bodySmall: GoogleFonts.poppins(
      color: CSDarkColor,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: GoogleFonts.poppins(
      color: CSDarkColor,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
    ),
  );
  static TextTheme darkTextTheme = TextTheme(
    titleLarge: const TextStyle(
      fontFamily: 'PetitCochon',
      color: CSAccentColor,
      fontSize: 60.0,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: GoogleFonts.montserrat(
      color: CSWhiteColor,
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.montserrat(
      color: CSWhiteColor,
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: GoogleFonts.poppins(
      color: CSWhiteColor,
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: GoogleFonts.poppins(
      color: CSWhiteColor,
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: GoogleFonts.poppins(
      color: CSWhiteColor,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
    ),
    bodySmall: GoogleFonts.poppins(
      color: CSWhiteColor,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: GoogleFonts.poppins(
      color: CSWhiteColor,
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
    ),
  );
}
