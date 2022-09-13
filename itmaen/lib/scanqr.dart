import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/home.dart';
import 'package:itmaen/secure-storage.dart';
import 'biometric-auth.dart';

class ScanQR extends StatefulWidget {
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  ////////////////////////////////////////
  String qrCodeResult = "Not Yet Scanned";
  ///////////////////////////////

  StorageService st = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 167, 190),
        title: Text("تسجيل الدخول بالكود الخاص بك",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Message displayed over here
            // Text(
            //   "Result",
            //   style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            // Text (
            //   qrCodeResult,
            //   style: TextStyle(
            //     fontSize: 20.0,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            // SizedBox(
            //   height: 20.0,
            // ),

            //Button to scan QR code
            MaterialButton(
              padding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Color.fromARGB(255, 140, 167, 190),
              onPressed: () async {
                //test
                //String? q = await st.readSecureData("caregiver");
                String barcodeScanRes;
                try {
                  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                      '#ff6666', 'Cancel', true, ScanMode.QR);

                  bool isAuthenticated = await BiometricAuthentication
                      .authenticateWithBiometrics();
                  if (isAuthenticated) {
                    st.writeSecureData("caregiverID",
                        barcodeScanRes); // if it did not work replace it with qr code result
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  } else {
                    st.writeSecureData("caregiverID", null);
                  }
                } on PlatformException {
                  barcodeScanRes = 'Failed to get platform version.';
                }

                setState(() {
                  qrCodeResult = barcodeScanRes;
                  // _storage.write(key: "caregiverID", value: qrCodeResult);
                });
              },
              child: Text(
                "افتح الماسح الضوئي",
                style: GoogleFonts.tajawal(
                    color: Color.fromARGB(255, 228, 229, 231),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Image.asset('images/itmaenlogo.png', height: 200, width: 200),
          ],
        ),
      ),
    );
  }
}
