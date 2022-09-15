import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'navigation.dart';
import 'home.dart';

class GenerateQR extends StatefulWidget {
  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  final _auth = FirebaseAuth.instance;
  late User? loggedInUser = _auth.currentUser;
  //String? qrData = loggedInUser!.uid ;
  // late User loggedInUser;
  //@override
  // void initState() {
  //   super.initState();
  // getCurrentUser();
  // }

  // void getCurrentUser() async {
  //   //String qrData="";
  //   try {
  //     final user = await _auth.currentUser;
  //     if (user != null) {
  //       loggedInUser = user;
  //       qrData = loggedInUser.uid;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }

  // }

//String qrData="caregiver id"; // the caregiver id shall be passed from the home page to here in order to create the QR code
// final qrdataFeed = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar having title
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 167, 190),
        title: Center(
            child: Text(
          "كود الاضافة ",
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        )),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          //Scroll view given to Column
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QrImage(data: loggedInUser!.uid),
              SizedBox(height: 20),
              Text(
                " كود المريض لتسجيل الدخول",
                style: GoogleFonts.tajawal(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 140, 167, 190)),
                textAlign: TextAlign.center,
              ),

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
              Container(
                height: 80,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 25, left: 24, right: 24),
                child: MaterialButton(
                  onPressed: () async {
                    // st.deleteSecureData("caregiverID");
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Navigation()));
                  },
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color.fromARGB(255, 140, 167, 190),
                  child: Text(
                    'العودة للقائمة الرئيسية',
                    style: GoogleFonts.tajawal(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
