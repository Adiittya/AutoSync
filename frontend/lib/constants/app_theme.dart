import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final TextStyle mainTitle = GoogleFonts.interTight(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static final TextStyle title = GoogleFonts.interTight(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static final TextStyle subtitle = GoogleFonts.interTight(
    color: Colors.black54,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle navLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const Color background = Colors.white;
  static final Color inputBackground = Colors.grey.shade200;
  static final Color fileChip = Colors.grey.shade300;

  static BoxDecoration inputDecoration = BoxDecoration(
    color: inputBackground,
    borderRadius: BorderRadius.circular(20),
  );
}
