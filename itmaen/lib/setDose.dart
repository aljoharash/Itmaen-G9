import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class setDose extends StatefulWidget {
  const setDose({Key? key}) : super(key: key);

  @override
  State<setDose> createState() => _setDoseState();
}

class _setDoseState extends State<setDose> {
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

  final _formKey = GlobalKey<FormState>();
  TextEditingController medName = new TextEditingController();
  TextEditingController doseCount = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController packSize = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 167, 190),
          elevation: 0,
          title: Text(
            "تحديد جرعة الدواء",
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(12),
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
                              "تحديد جرعة الدواء",
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
                              controller: medName,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
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
                              controller: description,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: ' وصف الجرعة (اختياري) ',
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
                              keyboardType: TextInputType.number,
                              controller: doseCount,
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
                                      builder: (context) => Navigation(data: 4,)));
                                }
                              },
                              child: Text('إضافة',
                                  style: GoogleFonts.tajawal(
                                    color: Color.fromARGB(255, 245, 244, 244),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )
                                  // style: TextStyle(fontFamily: 'Madani Arabic Black'),
                                  ),
                            ),
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
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(FormName.trim()))
      return 'يجب أن يحتوي اسم الدواء على حرفين على الاقل';
    return null;
  }

  String? ValidateDose(String? FormDose) {
    if (FormDose == null || FormDose.isEmpty) return 'الرجاء ادخال الجرعة ';
  }
}
