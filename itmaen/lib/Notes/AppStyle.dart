import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static Color bgColor = Color(0xFFe2e2ff);
  static Color mainColor = Color.fromARGB(255, 121, 48, 48);
  static Color accentColor = Color(0xFF0065FF);

  ///setting the cards different color
  static List<Color> cardsColor = [
    Colors.white,
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.blueGrey.shade100,
  ];

  ///setting the text style
  static TextStyle mainTitle =
      GoogleFonts.tajawal(fontSize: 20, fontWeight: FontWeight.bold);

  static TextStyle mainContent =
      GoogleFonts.tajawal(fontWeight: FontWeight.bold);

  static TextStyle dateTitle =
      GoogleFonts.tajawal(fontSize: 15, fontWeight: FontWeight.bold);
}
