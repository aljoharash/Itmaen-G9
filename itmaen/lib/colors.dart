import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class colors {
  final int id;
  final String name;
  final Color color;
  final String colorText;
  final String icon;

  colors(this.id, this.name, this.color, this.colorText, this.icon);

  static List<colors> colorsList() {
    return <colors>[
      colors(1, "أحمر", Colors.red.shade400, "Colors.red.shade400", '🔴'),
      colors(2, "برتقالي", Colors.deepOrange.shade300, "Colors.deepOrange.shade300", '🟠'),
      colors(3, "أصفر", Colors.amber.shade200, "Colors.amber.shade200", '🟡'),
      colors(4, "أخضر", Colors.green.shade200, "Colors.green.shade200", '🟢'),
      colors(5, "أزرق", Colors.blue.shade400, "Colors.blue.shade400", '🔵'),
      colors(6, "بنفسجي", Colors.deepPurple.shade200, "Colors.deepPurple.shade200", '🟣'),
      colors(7, "بني", Colors.brown.shade300, "Colors.brown.shade300", '🟤'),
      colors(8, "أسود", Colors.grey.shade800, "Colors.brown.shade300", '⚫️'),
    ];
  }
}
