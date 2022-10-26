import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itmaen/setDose.dart';
import 'package:itmaen/trySet.dart';
import 'dart:ui' as ui;

class addNote extends StatefulWidget {
  const addNote({Key? key}) : super(key: key);

  @override
  State<addNote> createState() => _addNoteState();
}

class _addNoteState extends State<addNote> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late List<String> toBeTransformed = [];

  String caregiverID = "";
  late User loggedInUser;

  @override
  void initState() {
    getCurrentUser();
  }

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
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController note = new TextEditingController();
  bool medExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 167, 190),
          elevation: 0,
          title: Text(
            "إضافة مفكرة",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 560, //للسماوي اللي شلتيه  كان تحت صفحة بيضاء

                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(10), // بعد عن الأطراف لل
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          
                            TextFormField(
                              minLines: 9,
                              maxLines: 14,
                              controller: note,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: 'أدخل ملاحظاتك',
                                enabled: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0,
                                    right: 12.0,
                                    bottom: 8.0,
                                    top: 8.0),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 236, 231, 231),
                                        width: 3)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Color.fromARGB(79, 255, 255, 255)),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                              ),
                            ),
                           SizedBox(
                              height: 24.0,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              elevation: 5.0,
                              height: 50,
                              padding: EdgeInsets.symmetric(
                                  vertical: 11, horizontal: 122),
                              color: Color.fromARGB(255, 140, 167, 190),
                              onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _firestore
                                        .collection('medicines')
                                        .doc(caregiverID)
                                        .set({
                                    
                                    });

                                    print("Note added");

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Navigation()));
                                  }
                                }
                              ,
                              child: Text('إضافة',
                                  style: GoogleFonts.tajawal(
                                    color: Color.fromARGB(255, 245, 244, 244),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )
                                  // style: TextStyle(fontFamily: 'Madani Arabic Black'),
                                  ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                          ]),
                    ),
                  ),
                )),
          )
        ]))));
  }
}