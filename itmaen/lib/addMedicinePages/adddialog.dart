import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/controller/addMedicineController.dart';
import 'package:itmaen/model/medicinesModel.dart';
import 'package:itmaen/addMedicinePages/addByScan.dart';
import 'package:itmaen/addMedicinePages/addManually.dart';

class AddMedicine extends StatefulWidget {
  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  @override
  Widget build(BuildContext context) {
    //
    // var mednameCont = TextEditingController();
    // var dosecont = TextEditingController();

    return Container(
      padding: EdgeInsets.all(10),
      height: 160,
      width: 400,
      child: Column(
        children: [
          Text('إضافة دواء',
              style: GoogleFonts.tajawal(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 140, 167, 190),
              )),
          //buildTextfield('اسم الدواء', mednameCont),
          //buildTextfield('الجرعة', dosecont),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => addManually()));
            },
            child: Text(
              'أضف الدواء يدويًا',
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 40),
              maximumSize: const Size(200, 40),
              primary: Color.fromARGB(255, 140, 167, 190),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addMedicineController.notFound = true;
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => addByScan()));
            },
            child: Icon(Icons.qr_code_scanner),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 40),
              maximumSize: const Size(200, 40),
              primary: Color.fromARGB(255, 140, 167, 190),
            ),
          ),
        ],
      ),
    );
  }
}
