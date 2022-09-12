import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:itmaen/controller/addMedicineController.dart';
import 'package:itmaen/model/medicinesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itmaen/secure-storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMedicine extends StatefulWidget {
  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  String? genericName;
  String? tradeName;
  String? strengthValue;
  String? unitOfStrength;
  String? volume;
  String? unitOfVolume;
  String? packageSize;
  String? barcode;
  String? description;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String caregiverID = "";
  late User loggedInUser;

  @override
  void initState() {
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildTextfield(
        String hint, TextEditingController controller, var val) {
      return Container(
        margin: EdgeInsets.all(4),
        child: TextField(
          decoration: InputDecoration(
              labelText: val,
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.black38,
              ))),
          controller: controller,
        ),
      );
    }

    var mednameCont = TextEditingController();
    var dosecont = TextEditingController();

    //var medVal = addMedicineController().scannedMedicine[0].tradeName;
    // var doseVal = addMedicineController().scannedMedicine[0].strengthValue;

    return Container(
      padding: EdgeInsets.all(8),
      height: 300,
      width: 400,
      child: Column(
        children: [
          Text(
            'أضف دواء',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.blueGrey),
          ),
          //  buildTextfield('اسم الدواء', mednameCont, medVal),
          // buildTextfield('الجرعة', dosecont, doseVal),
          ElevatedButton(
            onPressed: () {
              _firestore.collection('medicines').add({
                'Generic name': genericName,
                'Trade name': tradeName,
                'Strength value': strengthValue,
                'Unit of strength': unitOfStrength,
                'Volume': volume,
                'Unit of volume': unitOfVolume,
                'Package size': packageSize,
                'barcode': barcode,
                'description': description,
                'caregiverID': caregiverID,
              });
            },
            child: Text('أضف الدواء'),
          ),
          ElevatedButton(
            onPressed: () => addMedicineController().scanBarcode(),
            child: Text('الماسح الضوئي'),
          ),
        ],
      ),
    );
  }
}
