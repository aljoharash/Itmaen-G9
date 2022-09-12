import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:itmaen/controller/addMedicineController.dart';
import 'package:itmaen/model/medicinesModel.dart';
import 'package:itmaen/pages/addByScan.dart';

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
      height: 200,
      width: 400,
      child: Column(
        children: [
          Text(
            'إضافة دواء',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.blueGrey),
          ),
          //buildTextfield('اسم الدواء', mednameCont),
          //buildTextfield('الجرعة', dosecont),
          ElevatedButton(
            onPressed: () {//Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
															//));
                              },
            child: Text('أضف الدواء يدويًا'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200,40),
              maximumSize: const Size(200,40),
            ),
          ),
          ElevatedButton(
            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
															addByScan()));},
            child:Icon(Icons.qr_code_scanner),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200,40),
              maximumSize: const Size(200,40),
            ),
          ),
        ],
      ),
    );
  }
}
