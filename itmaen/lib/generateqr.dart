import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQR extends StatefulWidget {
@override
_GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  

String qrData="caregiver id"; // the caregiver id shall be passed from the home page to here in order to create the QR code
// final qrdataFeed = TextEditingController();
@override
Widget build(BuildContext context) {
	return Scaffold(
	//Appbar having title
	appBar: AppBar(
		title: Center(child: Text("إطمئن")),
	),
	body: Container(
		padding: EdgeInsets.all(20),
		child: SingleChildScrollView(
		
		//Scroll view given to Column
		child: Column(
			mainAxisAlignment: MainAxisAlignment.center,
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
			QrImage(data: qrData),
			SizedBox(height: 20),
			Text(" كود المريض لتسجيل الدخول",style: TextStyle(fontSize: 20),textAlign: TextAlign.center),
			
			//TextField for input link
			// TextField(
			// 	decoration: InputDecoration(
			// 	hintText: "Enter your link here..."
			// 	),
			// ),
			Padding(
				padding: const EdgeInsets.all(8.0),
				//Button for generating QR code
				// child: TextButton(
				// 	onPressed: () async {
				// 	// //a little validation for the textfield
				// 	// if (qrdataFeed.text.isEmpty) {	
				// 	// 	setState(() {
				// 	// 	qrData = "";
				// 	// 	});
				// 	// } else {
				// 	// 	setState(() {
				// 	// 	qrData = qrdataFeed.text;
				// 	// 	});
				// 	// }
        //   qrData = "caregiverId12"; 
				// 	},
				// //Title given on Button
				// 	child: Text("إنشاء كود للمريض",style: TextStyle(color: Colors.indigo[900],),),
				// //   shape: RoundedRectangleBorder(
				// // 	borderRadius: BorderRadius.circular(20),
				// // 	side: BorderSide(color: Color.fromARGB(255, 171, 177, 232)),
				// // ),
				// ),
			),
			],
		),
		),
	),
	);
}
}
