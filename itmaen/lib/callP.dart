import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:itmaen/login.dart';
import 'package:itmaen/data.dart';
import 'package:itmaen/secure-storage.dart';
import 'package:itmaen/successSave.dart';
import 'package:itmaen/view.dart';
import 'package:itmaen/viewDailyDoses.dart';
import 'dart:ui' as ui;
import 'navigation.dart';

class callP extends StatefulWidget {
  callP({Key? key}) : super(key: key);

  /*
  static String nameO = data.user1;
  static String emailO = data.email1;
  static String PassO = data.password1;
  static String MobileO = data.phoneNum1;*/
  /*editProfile({Key? key, username, email, password, phoneNum}) {
    var nameO = username;
    var emailO = email;
    var PassO = password;
    var MobileO = phoneNum;
  }*/

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

    //retrieve2();
    /*
    
    var snapShotsValue = await FirebaseFirestore.instance
        .collection("caregivers")
        .where('caregiverID', isEqualTo: caregiverID)
        .get();
   // retrieve(snapShotsValue);
    print("test enter");*/
  }

  @override
  void initState() {
    retrieve2();

    super.initState();
    getCurrentUser();
    //retrieve();
    print("here");
    // setState(() {});
  }

  Future retrieve2() async {
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

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updateEmail(newEmail);
      await currentUser!.updatePassword(newPassword);
      //FirebaseAuth.instance.signOut();

    } catch (e) {}
  }

  _callNumber() async {
    //const number = nameO ; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(nameO);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                  'deem',
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    fontFamily: 'Source Sans Pro',
                    color: Colors.teal.shade100,
                    fontSize: 20.0,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
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
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      title: Text(
                        nameO,
                        style: TextStyle(
                          color: Colors.teal.shade900,
                          fontFamily: 'Source Sans Pro',
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
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Expanded(
                        child: ListTile(
                      // ignore: prefer_const_constructors
                      leading: Icon(Icons.email,
                          color: Color.fromARGB(255, 140, 167, 190),
                          textDirection: ui.TextDirection.rtl),
                      title: Text(
                        emailO,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.teal.shade900,
                            fontFamily: 'Source Sans Pro'),
                        textDirection: ui.TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                    ))),
              ],
            )),
      ),
    ));
  }
}
