import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EditMed extends StatefulWidget {
  final String name;
  final String description;
  final String strength;
  final String package;
  const EditMed({Key? key, required this.name , required this.description , required this.package , required this.strength}) : super(key: key);

  @override
  State<EditMed> createState() => _EditMedState();
}

class _EditMedState extends State<EditMed> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late List<String> toBeTransformed = [];

  String caregiverID = "";
  late User loggedInUser;
  String prevMed = "";
  

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
  TextEditingController medName = new TextEditingController();
  TextEditingController doseCount = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController packSize = new TextEditingController();
  bool medExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 167, 190),
          elevation: 0,
          title: Text(
            "تعديل دواء",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context)
                    .size
                    .height, //للسماوي اللي شلتيه  كان تحت صفحة بيضاء

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
                              height: 100,
                            ),
                            Text(
                              "تعديل دواء",
                              style: GoogleFonts.tajawal(
                                fontSize: 30,
                                //fontStyle: FontStyle.italic,
                                color: Color.fromARGB(255, 122, 164, 186),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              // initialValue: widget.name ,
                              controller: medName,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'الرجاء ادخال اسم الدواء';
                                String pattern =
                                    r'^(?=.{3,20}$)[\u0621-\u064Aa-zA-Z\d\-_\s]+$';
                                RegExp regex = RegExp(pattern);
                                if (!regex.hasMatch(value.trim()))
                                  return 'يجب أن يحتوي اسم الدواء على ثلاثة أحرف على الاقل';
                                return null;
                              },
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: 'اسم الدواء ',
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
                              height: 16.0,
                            ),
                            TextFormField(
                              // initialValue: widget.description,
                              controller: description,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: ' وصف الدواء (اختياري) ',
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
                              height: 16.0,
                            ),
                            TextFormField(
                              // initialValue: widget.strength,
                              keyboardType: TextInputType.number,
                              controller: doseCount,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'الرجاء ادخال الجرعة ';
                                return null;
                              },
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: 'الجرعة',
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
                              height: 16.0,
                            ),
                            TextFormField(
                              // initialValue: widget.package,
                              keyboardType: TextInputType.number,
                              controller: packSize,
                              validator: ValidatePack,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: 'حجم العبوة',
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
                                var doc = await _firestore
                                    .collection("medicines")
                                    .doc( medName.text + caregiverID)
                                    .get();
                                if (doc.exists) {
                                  print("already exist");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      // margin: EdgeInsets.only(right: 10),

                                      content: Text('تمت إضافة الدواء مسبقًا',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.right),
                                    ),
                                  );
                                } else {
                                  if (_formKey.currentState!.validate()) {
                                    _firestore
                                        .collection('medicines')
                                        .doc(widget.name + caregiverID)
                                        .update({
                                      //  'Generic name': genericName,
                                      'Trade name': medName.text,
                                      'Strength value': doseCount.text,
                                      //   'Unit of strength': unitOfStrength,
                                      // 'Volume': volume,
                                      //'Unit of volume': unitOfVolume,
                                      'Package size': packSize.text,
                                      //'barcode': barcode,
                                      'description': description.text,
                                      'caregiverID': caregiverID,
                                      'picture': (medName.text == "جليترا"
                                          ? "images/" + "جليترا" + ".png"
                                          : medName.text == "سبراليكس"
                                              ? "images/" + "سبراليكس" + ".png"
                                              : medName.text ==
                                                      "سنترم - CENTRUM"
                                                  ? "images/" +
                                                      "CENTRUM - سنترم" +
                                                      ".png"
                                                  : medName.text ==
                                                          "بانادول - PANADOL"
                                                              "PANADOL"
                                                      ? "images/" +
                                                          "بانادول ادفانس - PANADOL" +
                                                          ".png"
                                                      : medName.text ==
                                                              "فيدروب - VIDROP"
                                                          ? "images/" +
                                                              "VIDROP" +
                                                              ".png"
                                                          : "images/" +
                                                              "no" +
                                                              ".png"),
                                    });

                                    print("Med added");

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Navigation()));
                                  }
                                }
                              },
                              child: Text('تعديل',
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
                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius:
                            //           BorderRadius.all(Radius.circular(10.0))),
                            //   elevation: 5.0,
                            //   height: 50,
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: 11, horizontal: 76),
                            //   color: Color.fromARGB(255, 140, 167, 190),
                            //   onPressed: () async {
                            //     var doc = await _firestore
                            //         .collection("medicines")
                            //         .doc(medName.text + caregiverID)
                            //         .get();
                            //     if (doc.exists) {
                            //       print("already exist");
                            //       ScaffoldMessenger.of(context).showSnackBar(
                            //         const SnackBar(
                            //           // margin: EdgeInsets.only(right: 10),

                            //           content: Text('تمت إضافة الدواء مسبقًا',
                            //               style: TextStyle(fontSize: 15),
                            //               textAlign: TextAlign.right),
                            //         ),
                            //       );
                            //     } else {
                            //       if (_formKey.currentState!.validate()) {
                            //         _firestore
                            //             .collection('medicines')
                            //             .doc(medName.text + caregiverID)
                            //             .set({
                            //           //  'Generic name': genericName,
                            //           'Trade name': medName.text,
                            //           'Strength value': doseCount.text,
                            //           //   'Unit of strength': unitOfStrength,
                            //           // 'Volume': volume,
                            //           //'Unit of volume': unitOfVolume,
                            //           'Package size': packSize.text,
                            //           //'barcode': barcode,
                            //           'description': description.text,
                            //           'caregiverID': caregiverID,
                            //           'picture': (medName.text == "جليترا"
                            //               ? "images/" + "جليترا" + ".png"
                            //               : medName.text == "سبراليكس"
                            //                   ? "images/" + "سبراليكس" + ".png"
                            //                   : medName.text ==
                            //                           "سنترم - CENTRUM"
                            //                       ? "images/" +
                            //                           "CENTRUM - سنترم" +
                            //                           ".png"
                            //                       : medName.text ==
                            //                               "بانادول - PANADOL"
                            //                           ? "images/" +
                            //                               "بانادول ادفانس - PANADOL" +
                            //                               ".png"
                            //                           : medName.text ==
                            //                                   "فيدروب - VIDROP"
                            //                               ? "images/" +
                            //                                   "VIDROP" +
                            //                                   ".png"
                            //                               : "images/" +
                            //                                   "no" +
                            //                                   ".png"),
                            //         });

                            //         Navigator.of(context)
                            //             .push(MaterialPageRoute(
                            //                 builder: (context) => SetDose(
                            //                       value: toBeTransformed,
                            //                       toBeTransformed: [
                            //                         medName.text,
                            //                       ],
                            //                     )));
                            //       }
                            //     }
                            //   },
                            //   child: Text('تحديد جرعة الدواء',
                            //       style: GoogleFonts.tajawal(
                            //         color: Color.fromARGB(255, 245, 244, 244),
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.bold,
                            //       )
                            //       // style: TextStyle(fontFamily: 'Madani Arabic Black'),
                            //       ),
                            // ),
                          ]),
                    ),
                  ),
                )),
          )
        ]))));
  }

  String? ValidatePack(String? formPack) {
    if (formPack == null || formPack.isEmpty) return ' الرجاء ادخال حجم العبوة';
    if (int.parse(formPack) > 9999) return 'لا يمكنك إدخال اكثر من 4 خانات';
  }

  String? ValidateMedName(String? FormName) {
    if (FormName == null || FormName.isEmpty) return 'الرجاء ادخال اسم الدواء';
    String pattern =
        r'^(?=.{2,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
    RegExp regex = RegExp(pattern, unicode: true);
    if (!regex.hasMatch(FormName.trim()))
      return 'يجب أن يحتوي اسم الدواء على حرفين على الاقل';
    return null;
  }

  String? ValidateDose(String? FormDose) {
    if (FormDose == null || FormDose.isEmpty) return 'الرجاء ادخال الجرعة ';
  }
}
