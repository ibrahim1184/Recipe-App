import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle headline1 = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle headline2 = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle headline3 = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle bodyText1 = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static TextStyle bodyText2 = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );
  static final TextStyle smallText = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );
}

