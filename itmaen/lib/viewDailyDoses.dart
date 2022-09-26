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

class ViewD extends StatefulWidget {
  @override
  _ViewDPageState createState() => _ViewDPageState();
}

class _ViewDPageState extends State<ViewD> {
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
    ViewD();
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
                  var j = 0 ; 
                  return SafeArea(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('doses')
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
                              final medName = med.get('name');
                              final checked = med.get('cheked');
                              final caregiverID = med.get('caregiverID');
                              final doc = med.id;
                              final time = med.get('TimeOnly'); 
                              final MedBubble = medBubble(medName , checked,caregiverID, doc,time);
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
                  var i = 0 ; 
                  return SafeArea(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('doses')
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
                              final medName = med.get('name');
                              final checked = med.get('cheked');
                              final id = med.get('caregiverID');
                              final doc = med.id;
                              final time = med.get('TimeOnly'); 
                             // var i = 0;  
                              final MedBubble = medBubble(medName , checked, caregiverID, doc,time);
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

class medBubble extends StatefulWidget {
  medBubble(this.medicName , this.checked , this.ID , this.doc , this.time);
  var medicName;
  var checked ; 
  var ID ; 
  var doc; 
  var time ; 

  @override
  State<medBubble> createState() => _medBubbleState();
}

class _medBubbleState extends State<medBubble> {

  bool _value = false;
  bool _valu = false;
    @override
   Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
    child: Material(
          child: SizedBox(
            width: 115,
            height: 110,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: const Offset(
                              1.0,
                              1.0,
                            ), //Offset
                            blurRadius: 15.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                      ), //BoxDecoration
                       
                      /** CheckboxListTile Widget **/
                      child: CheckboxListTile(
                        title:  Text('${widget.medicName}'),
                        subtitle: Text(
                            '${widget.time}'),
                        secondary: CircleAvatar(
                          backgroundColor: Colors.yellow,// here you put the color in sara's database
                           //NetworkImage
                          radius: 20,
                        ),
                        autofocus: false,
                        isThreeLine: true,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        selected: widget.checked,
                        value: widget.checked,
                        onChanged: (bool?value){
                       FirebaseFirestore.instance.collection('doses').doc(widget.doc).update({'cheked': value});
                          setState(() {
                            _valu = value!;
                            widget.checked = value; 

                            print(widget.checked
                            ); 
                          });
                        },
                      ), //CheckboxListTile
                    ),
                  ],
                ), //Container
              ), //Padding
            ), //Center
          ),
        ), //SizedBox
      );
    

}}
