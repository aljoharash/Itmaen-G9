import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/controller/addMedicineController.dart';
import 'package:itmaen/Widget/Card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:itmaen/addMedicinePages/adddialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itmaen/home.dart';
import 'package:itmaen/navigation.dart';
import 'package:itmaen/secure-storage.dart';
import 'package:itmaen/setDose.dart';
import 'addmedicine.dart';
import 'package:itmaen/trySet.dart';
import 'dart:ui' as ui;

class addByScan extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User? loggedInUser = _auth.currentUser;
  late List<String> toBeTransformed = [];

  TextEditingController medName = new TextEditingController();
  TextEditingController doseUnit = new TextEditingController();
  TextEditingController descriptionControl = new TextEditingController();
  TextEditingController packSize = new TextEditingController();
  bool medExist = false;
  late String genericName = "";
  late String tradeName = "";
  late String strengthValue = "";
  late String unitOfStrength = "";
  late String volume = "";
  late String unitOfVolume = "";
  late String packageSize = "";
  late String barcode = "";
  late String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 167, 190),
        title: Center(
            child: Text(
          "الماسح الضوئي         ",
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        )),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: GetBuilder<addMedicineController>(
              init: addMedicineController(),
              builder: (_) {
                if (_.scannedMedicine.isNotEmpty) {
                  medName.text = _.scannedMedicine[0].tradeName.toString();
                  descriptionControl.text =
                      _.scannedMedicine[0].description.toString();
                  packSize.text = _.scannedMedicine[0].packageSize.toString();
                  doseUnit.text = _.scannedMedicine[0].unitOfVolume.toString();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "إضافة دواء",
                      style: GoogleFonts.tajawal(
                        fontSize: 28,
                        //fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 122, 164, 186),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      //child: Card(
                      // elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: _.scannedMedicine.isEmpty
                            ? Container(
                                alignment: Alignment.center,
                                height: 100,
                                child: Card(
                                    elevation: 5,
                                    child: addMedicineController.notFound
                                        ? Padding(
                                            padding: const EdgeInsets.all(30),
                                            child: Text(
                                              'لم يتم المسح حتى الان أو لم يتم العثور على الدواء',
                                              style: GoogleFonts.tajawal(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Text(
                                            'اقرأ الباركود',
                                            style: GoogleFonts.tajawal(
                                                fontWeight: FontWeight.bold),
                                          )))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "اسم الدواء                                                                               ",
                                    style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold),
                                    textDirection: ui.TextDirection.rtl,
                                  ),
                                  TextFormField(
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
                                        return 'يجب أن يحتوي اسم الدواء على ثلاثة أحرف على الأقل وأن يكون خالي من الرموز';
                                      return null;
                                    },
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(255, 239, 237, 237),
                                      hintText: 'اسم الدواء ',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0,
                                          right: 12.0,
                                          bottom: 8.0,
                                          top: 8.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 236, 231, 231),
                                              width: 3)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Color.fromARGB(
                                                79, 255, 255, 255)),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(
                                    "وصف الدواء                                                                               ",
                                    style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold),
                                    textDirection: ui.TextDirection.rtl,
                                  ),
                                  TextFormField(
                                    controller: descriptionControl,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 6,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(255, 239, 237, 237),
                                      hintText: ' وصف الدواء (اختياري) ',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0,
                                          right: 12.0,
                                          bottom: 8.0,
                                          top: 8.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 236, 231, 231),
                                              width: 3)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Color.fromARGB(
                                                79, 255, 255, 255)),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Text(
                                    "حجم العبوة                                                                               ",
                                    style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold),
                                    textDirection: ui.TextDirection.rtl,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: packSize,
                                    validator: ValidatePack,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(255, 239, 237, 237),
                                      hintText: 'حجم العبوة',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0,
                                          right: 12.0,
                                          bottom: 8.0,
                                          top: 8.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 236, 231, 231),
                                              width: 3)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Color.fromARGB(
                                                79, 255, 255, 255)),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    " الوحدة                                                                                       ",
                                    style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold),
                                    textDirection: ui.TextDirection.rtl,
                                  ),
                                  TextFormField(
                                    controller: doseUnit,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'الرجاء إدخال الوحدة';
                                      String pattern =
                                          r'^(?=.{2,20}$)[\u0621-\u064Aa-zA-Z\d\-_\s]+$';
                                      RegExp regex = RegExp(pattern);
                                      if (!regex.hasMatch(value.trim()))
                                        return 'يجب أن يحتوي اسم الوحدة على حرفين على الاقل';
                                      return null;
                                    },
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(255, 239, 237, 237),
                                      hintText: 'الوحدة',
                                      enabled: true,
                                      contentPadding: const EdgeInsets.only(
                                          left: 14.0,
                                          right: 12.0,
                                          bottom: 8.0,
                                          top: 8.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 236, 231, 231),
                                              width: 3)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Color.fromARGB(
                                                79, 255, 255, 255)),
                                        borderRadius:
                                            new BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                  ),
                                ],
                              ),
                      ),
                      // ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60.0,
                        width: 200,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 140, 167, 190),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                  child: Icon(
                                FontAwesomeIcons.barcode,
                                size: 16,
                                color: Colors.white,
                              )),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "الماسح الضوئي",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
                            _.scanBarcode();
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 60.0,
                        width: 200,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 140, 167, 190),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // ******* Go to setDose *********

                                SizedBox(
                                  width: 10,
                                ),

                                Text(
                                  "إضافة",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.tajawal(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              var doc = await _firestore
                                  .collection("medicines")
                                  .doc(medName.text + loggedInUser!.uid)
                                  .get();
                              if (doc.exists) {
                                print("already exist");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    // margin: EdgeInsets.only(right: 10),

                                    content: Text('تمت إضافة الدواء مسبقًا',
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.right),
                                  ),
                                );
                              } else {
                                if (addMedicineController.notFound == false) {
                                  _firestore
                                      .collection('medicines')
                                      .doc(medName.text + loggedInUser!.uid)
                                      .set({
                                    'docName': medName.text,
                                    'Generic name': genericName,
                                    'Trade name': medName.text,
                                    'Strength value': strengthValue,
                                    'Unit of strength': unitOfStrength,
                                    'Volume': volume,
                                    'Unit of volume': doseUnit.text,
                                    'Package size': packSize.text,
                                    'Remaining Package': packSize.text,
                                    'barcode': barcode,
                                    'description': descriptionControl.text,
                                    'caregiverID': loggedInUser!.uid,
                                    'picture': medName.text == "جليترا"
                                        ? "images/" + "جليترا" + ".png"
                                        : medName.text == "سبراليكس"
                                            ? "images/" + "سبراليكس" + ".png"
                                            : medName.text == "سنترم - CENTRUM"
                                                ? "images/" +
                                                    "CENTRUM - سنترم" +
                                                    ".png"
                                                : medName.text ==
                                                        "بانادول - PANADOL"
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
                                                            ".png"
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      // margin: EdgeInsets.only(right: 10),

                                      content: Text('تمت إضافة الدواء بنجاح',
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.right),
                                    ),
                                  );
                                  _.scannedMedicine.clear();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Navigation(data: 1,)));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      // margin: EdgeInsets.only(right: 10),

                                      content: Text(
                                          'عليك استخدام الماسح الضوئي أولاً ',
                                          style: TextStyle(fontSize: 20),
                                          textAlign: TextAlign.right),
                                    ),
                                  );
                                }

                                _.scannedMedicine.clear();
                              }
                            }),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
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
