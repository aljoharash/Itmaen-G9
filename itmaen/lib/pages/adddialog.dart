import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:itmaen/controller/addMedicineController.dart';
import 'package:itmaen/model/medicinesModel.dart';

class AddMedicine extends StatefulWidget {
  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
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

    var medVal = addMedicineController().scannedMedicine[0].tradeName;
    var doseVal = addMedicineController().scannedMedicine[0].strengthValue;

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
          buildTextfield('اسم الدواء', mednameCont, medVal),
          buildTextfield('الجرعة', dosecont, doseVal),
          ElevatedButton(
            onPressed: () {},
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
