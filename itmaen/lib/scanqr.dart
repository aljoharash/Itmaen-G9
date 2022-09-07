
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';




class ScanQR extends StatefulWidget {
@override
_ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {

String qrCodeResult = "Not Yet Scanned";

   

@override
Widget build(BuildContext context) {
	return Scaffold(
	appBar: AppBar(
		title: Text("تسجيل الدخول بالكود الخاص بك"),
	),
	body: Container(
		padding: EdgeInsets.all(20),
	child: Column(
	mainAxisAlignment: MainAxisAlignment.center,
	crossAxisAlignment: CrossAxisAlignment.stretch,
	children: [
	//Message displayed over here
	Text(
		"Result",
		style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
		textAlign: TextAlign.center,
	),
	Text(
		qrCodeResult,
		style: TextStyle(
		fontSize: 20.0,
		),
		textAlign: TextAlign.center,
	),
	SizedBox(
		height: 20.0,
	),

	//Button to scan QR code
	ElevatedButton(
		// padding: EdgeInsets.all(15),
		onPressed: () async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
//barcode scanner flutter ant 
    setState(() {
      qrCodeResult = barcodeScanRes;
    });
		},
		child: Text("افتح الماسح الضوئي",style: TextStyle(color: Colors.indigo[900]),),
		//Button having rounded rectangle border
		// shape: RoundedRectangleBorder(
		// side: BorderSide(color: Colors.indigo[900]),
		// borderRadius: BorderRadius.circular(20.0),
		// ),
	),

		],
		),
	),
	);
}
}