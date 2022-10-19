import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:itmaen/login.dart';
import 'package:itmaen/secure-storage.dart';
import 'package:itmaen/successSave.dart';
import 'package:itmaen/view.dart';
import 'package:itmaen/viewDailyDoses.dart';
import 'dart:ui' as ui;
import 'navigation.dart';

class callP extends StatefulWidget {
  final String name;
  final String email;
  final String mobile;

  const callP(
      {Key? key, required this.name, required this.email, required this.mobile})
      : super(key: key);

  @override
  _callP createState() => _callP();
}

class _callP extends State<callP> {
  final _formKey = GlobalKey<FormState>();
  StorageService st = StorageService();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String caregiverID = "";
  late User loggedInUser;
  var newPassword = "";
  var newEmail = "";
  String caregiverID2 = '';
  static String nameO = "";
  static String emailO = "";
  static String PassO = "";
  static String MobileO = "";
  late String id = '';
  static var id_ = '';
  //var Cid;
  static String cid_ = '';
  static var t;

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    var isAvailable = user?.uid;
    if (isAvailable == null) {
      t = true;
      id_ = (await st.readSecureData("caregiverID"))!;
      print("$id_ here 1");
      t = true;

      //return Future<bool>.value(true);
    } else {
      t = false;
      cid_ = user!.uid.toString();
      print("$cid_ here 2");
      t = false;
    }
  }

  @override
  void initState() {
    // retrieve2();
    nameO = widget.name;
    print(nameO + "نن");
    emailO = widget.email;
    MobileO = widget.mobile;
    super.initState();
    getCurrentUser();
    retrieve2();
    //retrieve();
    print("here");
    // setState(() {});
  }

  Future<void> retrieve2() async {
    final user = await _auth.currentUser;
    var isAvailable = user?.uid;
    if (isAvailable == null) {
      t = true;
      id_ = (await st.readSecureData("caregiverID"))!;
      caregiverID2 = id_;
      print("$id_ here 1");
      t = true;
      var collection = FirebaseFirestore.instance.collection('caregivers');
      var docSnapshot = await collection.doc(caregiverID2).get();
      if (!docSnapshot.exists) {
        print("ops");
      } else if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        nameO = data['user name'];
        emailO = data['email'];
        MobileO = data['mobileNum'];
      }
    }
  }

  //TextEditingController email = new TextEditingController();
  //TextEditingController password = new TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // newPasswordController.dispose();
    super.dispose();
  }

  _callNumber() async {
    //const number = nameO ; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(MobileO);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 140, 167, 190),
            title: Center(
                child: Text(
              " الاتصال",
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            )),
          ),
          floatingActionButton: ElevatedButton(
            onPressed: () {
              _callNumber();
            },
            child: Icon(
              Icons.call,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(15),
              //backgroundColor: Color.fromARGB(255, 140, 167, 190),
              primary: Color.fromARGB(255, 47, 212, 32),
              surfaceTintColor: Color.fromARGB(255, 114, 238, 43),
            ),
          ),
          body: SafeArea(
            child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage('images/profile.png'),
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 40.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '  المشرف على العلاج ',
                      style: GoogleFonts.tajawal(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 40, 114, 148),
                        fontSize: 20.0,
                        //letterSpacing: 2.5,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                      width: 150.0,
                      child: Divider(
                        color: Colors.teal.shade100,
                      ),
                    ),
                    Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 25.0),
                        child: ListTile(
                          title: Text(
                            nameO,
                            style: GoogleFonts.tajawal(
                              color: Colors.teal.shade900,
                              // fontFamily: 'Source Sans Pro',
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          leading: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 140, 167, 190),
                            //    textDirection= TextDirection.RTL
                          ),
                        )),
                    Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      //  elevation()
                      child: ListTile(
                        title: Text(emailO,
                            style: GoogleFonts.tajawal(
                              fontSize: 20.0,
                              color: Colors.teal.shade900,
                              // fontFamily: 'Source Sans Pro'
                            )),
                        // ignore: prefer_const_constructors
                        leading: Icon(Icons.email,
                            color: Color.fromARGB(255, 140, 167, 190),
                            textDirection: ui.TextDirection.rtl),

                        // textDirection: ui.TextDirection.rtl,
                        //textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                )),
          ),
        ));
  }
}
