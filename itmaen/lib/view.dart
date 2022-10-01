import 'dart:core';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/add-patient.dart';
import 'package:itmaen/patient-login.dart';
import 'alert_dialog.dart';
import 'package:itmaen/model/medicines.dart';
import 'generateqr.dart';
import 'login.dart';
import 'scanqr.dart';
import 'addMedicinePages/addmedicine.dart';
//import 'pages/adddialog.dart';
import 'package:itmaen/secure-storage.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';

class View extends StatefulWidget {
  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<View> {
  String title = 'AlertDialog';
  bool tappedYes = false;
  StorageService st = StorageService();
  //var caregiverID;
  final _auth = FirebaseAuth.instance;
  late User loggedUser;

  //Future<String?> loggedInUser = getCurrentUser();

  late String id = '';
  static var id_ = '';
  //var Cid;
  static String cid_ = '';
  var caregiverID;

  static var t;

  //getCurrentUser();

  _ViewPageState() {
    View();
    //assignboolean();
  }
  //}

  @override
  void initState() {
    super.initState();
    //HomePage();

    getCurrentUser().then((value) => t = value);
  }

  Future<bool> getstatu() async {
    bool val = await getCurrentUser();
    bool val2 = val;
    return val2;
  }

  Future<bool> getCurrentUser() async {
    //HomePage();
    final user = await _auth.currentUser;
    // st.writeSecureData("caregiverID", "vEvVOOqyORTSyfork3f3rZWnqKb2");
    //print(user!.uid);
    var isAvailable = user?.uid;
    if (isAvailable == null) {
      t = true;
      id_ = (await st.readSecureData("caregiverID"))!;
      print("$id_ here 1");
      t = true;

      return Future<bool>.value(true);
    } else {
      t = false;
      cid_ = user!.uid.toString();
      print("$cid_ here 2");
      t = false;
      return Future<bool>.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var data;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 167, 190),
          title: Text("قائمة الأدوية",
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
        ),
        body: FutureBuilder(
          builder: (ctx, snapshot) {
            // Checking if future is resolved or not
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                // Extracting data from snapshot object
                data = snapshot.data as bool;
                if (data == true) {
                  return SafeArea(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('medicines')
                              .where('caregiverID', isEqualTo: id_)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Text("Loading...");
                            } //else {
                            final medicines = snapshot.data?.docs;
                            List<medBubble> medBubbles = [];
                            for (var med in medicines!) {
                              //final medName = med.data();
                              final medName = med.get('Trade name');
                              final picture = med.get('picture');
                              final MedBubble = medBubble(medName,picture);
                              medBubbles.add(MedBubble);
                            }
                            return Expanded(
                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                children: medBubbles,
                              ),
                            );
                            // }
                          })
                    ],
                  ));
                } else {
                  return SafeArea(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('medicines')
                              .where('caregiverID', isEqualTo: cid_)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Text("Loading...");
                            } //else {
                            final medicines = snapshot.data?.docs;
                            List<medBubble> medBubbles = [];
                            for (var med in medicines!) {
                              //final medName = med.data();
                              final medName = med.get('Trade name');
                              final picture = med.get('picture');
                              final MedBubble = medBubble(medName,picture);
                             
                              medBubbles.add(MedBubble);
                            }
                            return Expanded(
                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                children: medBubbles,
                              ),
                            );
                            // }
                          })
                    ],
                  ));
                }
              }
            }

            // Displaying LoadingSpinner to indicate waiting state
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          // Future that needs to be resolved
          // inorder to display something on the Canvas
          future: getCurrentUser(),
        ),
      ),
    );
  }
}

class medBubble extends StatelessWidget {
  medBubble(this.medicName,this.picture);
  var medicName;
  var picture;

  @override
  Widget build(BuildContext context) {
    //HomePage();
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Material(
              borderRadius: BorderRadius.circular(20.0),
              elevation: 7,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 100),
                child: Row(
                  children: [
                      SizedBox(
                                  child: Image.asset(picture.toString(),
                                      height: 70, width: 70),
                                ),
                     SizedBox(
                                  
                                      width: 10
                                ),
                    Text(
                      '$medicName',
                      style: GoogleFonts.tajawal(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600),
                    ),
                    
                  ],
                ),
              )),
        ),

        
      
      ],
    );

    
  }
}
