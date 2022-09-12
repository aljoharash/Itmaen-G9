import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuildCard extends StatelessWidget {
  final String info;
  final IconData icon;
  final String item;

  const BuildCard ({Key? key, required this.icon, required this.item, required this.info})
   : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FaIcon(
          icon,
          color: Colors.black87,
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          info,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0XFF666666)),
        ),
        SizedBox(
          width: 6,
        ),
        Flexible(child: Text(item)),
      ],
    );
  }
}