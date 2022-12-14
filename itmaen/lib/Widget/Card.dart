import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildCard extends StatelessWidget {
  final String info;
  final IconData icon;
  final String item;

  const BuildCard ({Key? key, required this.icon, required this.item, required this.info})
   : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(child: Text(item)),
        SizedBox(
          width: 6,
        ),
        Text(
          info,
          style:
              GoogleFonts.tajawal(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
        ),
        SizedBox(
          width: 6,
        ),
        
        FaIcon(
          icon,
          color: Color.fromARGB(255, 140, 167, 190),
        ),
      ],
    );
  }
}
