import 'dart:convert';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:itmaen/model/medicines.dart';
import 'package:get/get.dart';

class addMedicineController extends GetController {
  String scan = '-1';
  List<medicines> medicinesList = [];
  List<medicines> scannedMedicine = [];
  bool found = true;

  /*onInit() {
    /* for (var medicineInfo in medicinesData) {
      medicinesList.add(medicines.fromJson(medicineInfo));
    } */
    medicinesList = ReadJsonData() as List<medicines>;
  } */

  /*Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('data/medicinesData.json');
    final data = await json.decode(response);
    // medicinesList = medicines.fromJson(data) as List<medicines>;
    //data["medicinesInformation"];
  }*/

  Future<List<medicines>> ReadJsonData() async {
    //read json file
    final jsondata = await rootBundle.loadString('lib/data/medicinesData.json');
    //decode json data as list
    final list = json.decode(jsondata) as List<dynamic>;

    //map json and initialize using DataModel
    return list.map((e) => medicines.fromJson(e)).toList();
  }

  Future<void> scanBarcode() async {
    medicinesList = await ReadJsonData() as List<medicines>;
    String barcodeResult;

    try {
      barcodeResult = await FlutterBarcodeScanner.scanBarcode(
          "#000000", "cancel", true, ScanMode.BARCODE);
      print(barcodeResult);
    } on PlatformException {
      barcodeResult = 'failed';
    }

    scan = barcodeResult;

    for (var i = 0; i < medicinesList.length; i++) {
      //print(medicinesList[i].tradeName);
      scannedMedicine.clear();

      if (scan == medicinesList[i].barcode) {
        print(medicinesList[i].tradeName);
        scannedMedicine.add(medicines.fromJson(medicinesList[i].toJson()));
        break;
      } else {
        found = false;
      }
    }
    scan = '-1';
  }
}
