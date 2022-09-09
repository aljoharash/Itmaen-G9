import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:itmaen/model/medicines.dart';
import 'package:itmaen/data/medicinesData.dart';

class addMedicineController {
  String scan = '-1';
  List<medicines> medicinesList = [];
  List<medicines> scannedMedicine = [];
  bool found = true;

  @override
  onInit() {
    for (var medicineInfo in medicinesData) {
      medicinesList.add(medicines.fromJson(medicineInfo));
    }
  }

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
        "#000000", "cancel", true, ScanMode.BARCODE);
    // .then((value) => setState(() => scannedMed = value))
    //  .then((value) => null);
  }

  Future<void> scanBarcode() async {
    String barcodeResult;

    try {
      barcodeResult = await _scan();
      print(barcodeResult);
    } on PlatformException {
      barcodeResult = 'Couldn\'t Scan';
    }

    scan = barcodeResult;

    for (var i = 0; i < medicinesList.length; i++) {
      scannedMedicine.clear();

      if (scanBarcode == medicinesList[i].barcode) {
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
