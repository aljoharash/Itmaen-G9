import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:itmaen/pages/adddialog.dart';

class QrCode extends StatefulWidget {
  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    void showAddDialog() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: AddMedicine(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: Icon(Icons.add),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: ListView(),
      ),
    );
  }
}
