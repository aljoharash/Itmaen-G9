import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/controller/addMedicineController.dart';
import 'package:itmaen/Widget/Card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:itmaen/addMedicinePages/adddialog.dart';
import 'package:itmaen/home.dart';
import 'package:itmaen/navigation.dart';
import 'addmedicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addmedicine.dart';

class addManually extends StatefulWidget {
  const addManually({Key? key}) : super(key: key);

  @override
  State<addManually> createState() => _addManuallyState();
}

class _addManuallyState extends State<addManually> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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

  @override
  final _formKey = GlobalKey<FormState>();
  TextEditingController medName = new TextEditingController();
  TextEditingController doseCount = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController packSize = new TextEditingController();
  String errorMessage = '';
  @override
  Widget build(BuildContext context) => Container(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 140, 167, 190),
            title: Center(
                child: Text(
              "إضافة دواء يدويًا",
              style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
            )),
          ),
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*SafeArea(
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: 500.0,
                          child: Text('sss'),
                        ),
                      ),
                    ),*/
                    SizedBox(
                      height: 180.0,
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "إضافة دواء",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tajawal(
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                            color: Color.fromARGB(255, 140, 167, 190),
                          ),
                        ),
                      ),
                    ),
                    /*SizedBox(
                      height: 50.0,
                    ),*/
                    TextFormField(
                      controller: medName,
                      validator: ValidateMedName,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: 'اسم الدواء ',
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
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: description,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: ' وصف الدواء (اختياري) ',
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
                    ),
                    Center(
                      child: Text(errorMessage),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: doseCount,
                      validator: ValidateDose,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: 'الجرعة',
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
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: packSize,
                      validator: ValidatePack,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: 'عدد الحبات',
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
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          backgroundColor: Color.fromARGB(255, 140, 167, 190)),
                      onPressed: () async {
                        _firestore.collection('medicines').add({
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
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Navigation()));
                      },
                      child: Text(
                        'إضافة',
                        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
            ),
          )));
}

String? ValidatePack(String? formPack) {
  if (formPack == null || formPack.isEmpty) return ' الرجاء ادخال حجم العبوة';
  if (int.parse(formPack) > 9999) return 'لا يمكنك إدخال اكثر من 4 خانات';
}

String? ValidateMedName(String? FormName) {
  if (FormName == null || FormName.isEmpty) return 'الرجاء ادخال اسم الدواء';
  String pattern =
      r'^(?=.{2,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(FormName.trim()))
    return 'يجب أن يحتوي اسم الدواء على حرفين على الاقل';
  return null;
}

String? ValidateDose(String? FormDose) {
  if (FormDose == null || FormDose.isEmpty) return 'الرجاء ادخال الجرعة ';
}
