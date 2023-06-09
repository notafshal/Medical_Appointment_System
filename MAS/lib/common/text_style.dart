import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  const AppTextStyle._();

  static TextStyle headline1 = GoogleFonts.roboto(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.0,
  );

  static TextStyle headline2 = GoogleFonts.roboto(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.0,
  );

  static TextStyle headline3 = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle inkWellLink = GoogleFonts.roboto(
    fontSize: 14,
    color: Color(0xffFFCE00),
    decoration: TextDecoration.underline,
    decorationThickness: 1,
  );
  static TextStyle inkWell = GoogleFonts.roboto(
    fontSize: 14,
    color: Color(0xffFFCE00),
  );

  static TextStyle subtitle1 =
      GoogleFonts.roboto(fontSize: 15, color: Colors.white.withOpacity(0.7));

  static TextStyle subtitle2 =
      GoogleFonts.roboto(fontSize: 13, color: Colors.white.withOpacity(0.7));

  static TextStyle body1 = GoogleFonts.roboto(
      fontSize: 16,
      height: 1.75,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15);

  static TextStyle body2 = GoogleFonts.roboto(
      fontSize: 14,
      height: 1.43,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15);

  static TextStyle button = GoogleFonts.barlowSemiCondensed(
      fontSize: 16,
      height: 1.75,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15);

  static TextStyle caption = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: white,
  );

  static TextStyle overline = GoogleFonts.roboto(
      fontSize: 12,
      height: 1.5,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1);

  static get white => null;
}
