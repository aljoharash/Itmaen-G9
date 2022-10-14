import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/login.dart';
import 'dart:ui' as ui;
import 'package:itmaen/data.dart';

class editProfile extends StatefulWidget {
  editProfile({Key? key}) : super(key: key);

  get nameO => null;
  /*editProfile({Key? key, username, email, password, phoneNum}) {
    var nameO = username;
    var emailO = email;
    var PassO = password;
    var MobileO = phoneNum;
  }*/

  @override
  _editProfile createState() => _editProfile();
}

class _editProfile extends State<editProfile> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String caregiverID = "";
  late User loggedInUser;
  var newPassword = "";
  var newEmail = "";

  static String nameO = data.user1;
  static String emailO = data.email1;
  static String PassO = data.password1;
  static String MobileO = data.phoneNum1;

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
    /* var snapShotsValue = await FirebaseFirestore.instance
        .collection("doses")
        .where('caregiverID', isEqualTo: caregiverID)
        .get();
    retrieve(snapShotsValue);*/
  }

/*
  retrieve(QuerySnapshot snapshot) {
    snapshot.docs.forEach((doc) {
      nameO = doc['user name'];
      emailO = doc['email'];
      PassO = doc['password'];
      MobileO = doc['mobileNum'];
    });
  }
*/
  @override
  void initState() {
    super.initState();
    //HomePage();
    data;
  }

  final newPasswordController = TextEditingController();
  final newEmailController = TextEditingController(text: "j");
  TextEditingController username = TextEditingController(text: nameO);
  TextEditingController phoneNum = new TextEditingController();

  //TextEditingController email = new TextEditingController();
  //TextEditingController password = new TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updateEmail(newEmail);
      await currentUser!.updatePassword(newPassword);
      //FirebaseAuth.instance.signOut();
      //Navigator.pushReplacement(
      //  context,
      //  MaterialPageRoute(builder: (context) => LoginPage()),
      //);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Your Password has been Changed. Login again !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 167, 190),
          title: Center(
              child: Text(
            "الملف الشخصي",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          )),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          SingleChildScrollView(
              /* child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                     /    image: AssetImage('images/background.jpg'),
                          fit: BoxFit.fill)
                      ////حطي هنا البوكس شادو
                      ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context)
                      .size
                      .height, //للسماوي اللي شلتيه  كان تحت صفحة بيضاء
*/
              child: Center(
                  child: Container(
            margin: EdgeInsets.all(12), // بعد عن الأطراف لل
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 220,
                  ),
                  /* Text(
                    "مرحبا",
                    style: GoogleFonts.tajawal(
                      fontSize: 30,
                      //fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 122, 164, 186),
                      fontWeight: FontWeight.bold,
                    ), 
                  ),*/
                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    "الاسم ",
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    textDirection: ui.TextDirection.rtl,
                  ),
                  TextFormField(
                    autofocus: false,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Color.fromARGB(255, 239, 237, 237),
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, right: 12.0, bottom: 8.0, top: 8.0),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 236, 231, 231),
                              width: 3)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color.fromARGB(79, 255, 255, 255)),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    controller: username,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "البريد الالكتروني ",
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    textDirection: ui.TextDirection.rtl,
                  ),
                  TextFormField(
                    autofocus: false,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Color.fromARGB(255, 239, 237, 237),
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, right: 12.0, bottom: 8.0, top: 8.0),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 236, 231, 231),
                              width: 3)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color.fromARGB(79, 255, 255, 255)),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    controller: newEmailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "الرقم السري",
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    textDirection: ui.TextDirection.rtl,
                  ),
                  TextFormField(
                    autofocus: false,
                    //obscureText: true,
                    // ignore: prefer_const_constructors
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      // labelText: 'الرقم السري ',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Color.fromARGB(255, 239, 237, 237),
                      // hintText: 'رقم الهاتف ',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, right: 12.0, bottom: 8.0, top: 8.0),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 236, 231, 231),
                              width: 3)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color.fromARGB(79, 255, 255, 255)),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    controller: newPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "رقم الجوال ",
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    textDirection: ui.TextDirection.rtl,
                  ),
                  TextFormField(
                    autofocus: false,
                    //obscureText: true,
                    // ignore: prefer_const_constructors
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      // labelText: 'الرقم السري ',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Color.fromARGB(255, 239, 237, 237),
                      // hintText: 'رقم الهاتف ',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, right: 12.0, bottom: 8.0, top: 8.0),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 236, 231, 231),
                              width: 3)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Color.fromARGB(79, 255, 255, 255)),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    controller: phoneNum,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //),
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState!.validate()) {
                        getCurrentUser();
                        print(caregiverID + "ggggg");
                        _firestore
                            .collection('caregivers')
                            .doc(caregiverID)
                            .update({
                          'user name': username.text,
                          'email': newEmailController.text,
                          'password': newPasswordController.text,
                          'mobileNum': phoneNum.text,
                          'uid': caregiverID
                        });
                        setState(() {
                          newPassword = newPasswordController.text;
                          newEmail = newEmailController.text;
                        });
                        changePassword();
                      }
                    },
                    child: Text(
                      'حفظ ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          )))
        ]))));
  }
}
