import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui;

import 'package:itmaen/view.dart';

class EditMed extends StatefulWidget {
  final String name;
  final String description;
  final String strength;
  final String package;
  final String remaining;
  final String medID; //new code
  const EditMed(
      {Key? key,
      required this.name,
      required this.description,
      required this.package,
      required this.remaining,
      required this.strength,
      required this.medID //new code
      })
      : super(key: key);

  @override
  State<EditMed> createState() => _EditMedState();
}

class _EditMedState extends State<EditMed> {
  final _firestore = FirebaseFirestore.instance;
  final _doseFirestore = FirebaseFirestore.instance;
  final _doseEditFirestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late List<String> toBeTransformed = [];

  String caregiverID = "";
  late User loggedInUser;

  static String medname = "";
  static String description = "";
  static String package = "";
  static String remaining = "";
  static String strength = "";
  String? selectType;

  TextEditingController medName = TextEditingController();
  TextEditingController doseCount = TextEditingController();
  TextEditingController meddescription = TextEditingController();
  TextEditingController packSize = TextEditingController();

  @override
  void initState() {
    selectType = widget.strength;
    medname = widget.name;
    description = widget.description;
    package = widget.package;
    remaining = widget.remaining;
    strength = widget.strength;
    medName.text = medname;
    doseCount.text = strength;
    meddescription.text = description;
    packSize.text = package;
    getCurrentUser();
  }

  var oldname;
  var dosename;
  var doses;
  var dosesEdit;
  List<String> doseName = <String>[];
  var namee;
  int count = 0;

  // retrieve(QuerySnapshot snapshot) {
  //   print("here");
  //   snapshot.docs.forEach((doc) {
  //     oldname = doc['docName'];
  //     print("name: $oldname");
  //   });
  // }

////////update dose edit
  updateDoseEdit(QuerySnapshot snapshot) {
    print("here doseEdit");
    snapshot.docs.forEach((doc) {
      count++;
      if (doc['name'] == widget.name) {
        _doseEditFirestore
            .collection('dosesEdit')
            .where('name', isEqualTo: widget.name)
            .get()
            .then((value) {
          value.docs[0].reference
              .update({'name': medName.text, "unit": doseCount.text});
        });
      } else {
        print('dose not found');
      }
    });
  }

////////update dose
  updateDose(QuerySnapshot snapshot) {
    print("here dose");
    snapshot.docs.forEach((doc) {
      int countdose = 0;
      if (doc['name'] == widget.name) {
        _doseFirestore
            .collection('doses')
            .where('name', isEqualTo: widget.name)
            .get()
            .then((value) {
          value.docs[countdose].reference.update({
            'name': medName.text,
            'Package size': packSize.text,
            'Remaining Package': packSize.text,
            "unit": doseCount.text
          });
        });
      } else {
        print('dose not found');
      }
    });
  }

  var snapShotsValueCheck;

  retrieveCheck(QuerySnapshot snapshot) {
    print("here");
    snapshot.docs.forEach((doc) {
      // medname = doc['Trade name'];
      // description = doc['description'];
      // package = doc['Package size'];
      // strength = doc['Strength value'];
      namee = doc['Trade name'];
      doseName.add(namee);
      print(namee);
    });
  }

  void getCurrentUser() async {
    retrieve(QuerySnapshot snapshot) {
      print("here");
      snapshot.docs.forEach((doc) {
        oldname = doc['docName'];
        // medname = doc['Trade name'];
        // description = doc['description'];
        // package = doc['Package size'];
        // strength = doc['Strength value'];
        print("name: $oldname " + medname + description + package + strength);
      });
    }

    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser.uid;
        print(caregiverID);
        print('idddd');
      }
    } catch (e) {
      print(e);
    }

    var snapShotsValue = await FirebaseFirestore.instance
        .collection("medicines")
        .where('caregiverID', isEqualTo: caregiverID)
        .where('Trade name', isEqualTo: widget.name)
        // .where('description', isEqualTo: widget.description)
        // .where('Package size', isEqualTo: widget.package)
        // .where('Strength value', isEqualTo: widget.strength)
        .get();

    dosesEdit = await FirebaseFirestore.instance
        .collection('dosesEdit')
        .where('caregiverID', isEqualTo: caregiverID)
        .where('name', isEqualTo: widget.name)
        .get();

    doses = await FirebaseFirestore.instance
        .collection('doses')
        .where('caregiverID', isEqualTo: caregiverID)
        .where('name', isEqualTo: widget.name)
        .get();

    snapShotsValueCheck = await FirebaseFirestore.instance
        .collection("medicines")
        .where('caregiverID', isEqualTo: caregiverID)
        .get();

    retrieve(snapShotsValue);
  }

  final _formKey = GlobalKey<FormState>();
  // TextEditingController medName = new TextEditingController(text: name);
  // TextEditingController doseCount = new TextEditingController(text:);
  // TextEditingController description = new TextEditingController(text:);
  // TextEditingController packSize = new TextEditingController(text:);
  bool medExist = false;
  List<String> list = [
    'مل',
    'مجم',
    'حبة',
  ];
  double dropDownwidth = 2;
  Color onClickDropDown = Colors.black45;
  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            item,
          ),
        ]),
        alignment: Alignment.topRight,
      ),
    );
  }

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              if (medName.text != widget.name ||
                  meddescription.text != widget.description ||
                  packSize.text != widget.package ||
                  selectType != widget.strength) {
                print("entered");
                showAlertDialogg(context);
              } else {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Navigation(data: 2,))
                    );
                    
              }
            },
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
                              "بيانات الدواء",
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
                            Text(
                              "اسم الدواء                                                                               ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold),
                              textDirection: ui.TextDirection.rtl,
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
                                  return 'يجب أن يحتوي اسم الدواء من 3 إلى 20 حرف وأن يكون خالي من الرموز';
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
                            Text(
                              "وصف الدواء                                                                               ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold),
                              textDirection: ui.TextDirection.rtl,
                            ),
                            TextFormField(
                              // initialValue: widget.description,
                              controller: meddescription,
                              textAlign: TextAlign.right,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              validator: (value) {
                                if (value == null || value.isEmpty) return null;
                                String pattern =
                                    r'^(?=.{3,350}$)[\u0621-\u064Aa-zA-Z\d\-.،,_\s]+$';
                                RegExp regex = RegExp(pattern);
                                if (!regex.hasMatch(value.trim()))
                                  return 'يجب أن يحتوي الوصف على ثلاثة أحرف على الأقل وأن يكون خالي من الرموز';
                                return null;
                              },
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
                            Text(
                              "حجم العبوة                                                                               ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold),
                              textDirection: ui.TextDirection.rtl,
                            ),
                            TextFormField(
                              // initialValue: widget.strength,
                              keyboardType: TextInputType.number,
                              controller: packSize,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: ValidatePack,
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
                              height: 16.0,
                            ),
                            Text(
                              " الوحدة                                                                                       ",
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold),
                              textDirection: ui.TextDirection.rtl,
                            ),
                            Container(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0,
                                      right: 12.0,
                                      bottom: 8.0,
                                      top: 8.0),
                                  fillColor: Color.fromARGB(255, 239, 237, 237),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 236, 231, 231),
                                          width: 3)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color:
                                            Color.fromARGB(79, 255, 255, 255)),
                                    borderRadius: new BorderRadius.circular(10),
                                  ),
                                ),
                                isExpanded: true,
                                items: list.map(buildMenuItem).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectType = value;
                                    dropDownwidth = 2;
                                    onClickDropDown =
                                        Color.fromARGB(79, 255, 255, 255);
                                  });
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                value: selectType,
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
                                    .doc(medName.text + caregiverID)
                                    .get();

                                var exist = false;
                                retrieveCheck(snapShotsValueCheck);

                                for (int i = 0; i < doseName.length; i++) {
                                  print(doseName[i]);
                                  print(medName.text);
                                  if (doseName[i] == medName.text &&
                                      doseName[i] != widget.name) {
                                    print('exist');
                                    print(doseName[i]);
                                    exist = true;
                                  }
                                }

                                if (exist) {
                                  print("already exist");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      // margin: EdgeInsets.only(right: 10),

                                      content: Text('تمت إضافة الدواء مسبقًا',
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.right),
                                    ),
                                  );
                                } else if (double.parse(remaining) >
                                    double.parse(packSize.text)) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "لا",
                                                    style:
                                                        GoogleFonts.tajawal(),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    print(
                                                        (oldname + caregiverID)
                                                            .toString());
                                                    print("test 111");
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _firestore
                                                          .collection(
                                                              'medicines')
                                                          .doc(widget
                                                              .medID) //new code
                                                          // .doc('testtestFAmv3c30ydRn7PkA2jbL9SBXPOp1')
                                                          .update({
                                                        //  'Generic name': genericName,
                                                        'Trade name':
                                                            medName.text,
                                                        'Unit of volume':
                                                            doseCount.text,
                                                        //   'Unit of strength': unitOfStrength,
                                                        // 'Volume': volume,
                                                        //'Unit of volume': unitOfVolume,
                                                        'Package size':
                                                            packSize.text,
                                                        'Remaining Package':
                                                            packSize.text,
                                                        //'barcode': barcode,
                                                        'description':
                                                            meddescription.text,
                                                        'caregiverID':
                                                            caregiverID,
                                                        'picture': (medName
                                                                    .text ==
                                                                "جليترا"
                                                            ? "images/" +
                                                                "جليترا" +
                                                                ".png"
                                                            : medName.text ==
                                                                    "سبراليكس"
                                                                ? "images/" +
                                                                    "سبراليكس" +
                                                                    ".png"
                                                                : medName.text ==
                                                                        "سنترم - CENTRUM"
                                                                    ? "images/" +
                                                                        "CENTRUM - سنترم" +
                                                                        ".png"
                                                                    : medName.text ==
                                                                            "بانادول - PANADOL"
                                                                        // "PANADOL"
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

                                                      updateDose(doses);
                                                      updateDoseEdit(dosesEdit);

                                                      print("Med updated");

                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Navigation(data: 2,)));
                                                    }
                                                  },
                                                  child: Text(
                                                    "نعم",
                                                    style:
                                                        GoogleFonts.tajawal(),
                                                  ),
                                                ),
                                              ],
                                              content: Text(
                                                "تبقى لديك مسبقًا من الدواء " +
                                                    remaining +
                                                    " " +
                                                    strength +
                                                    "، " +
                                                    "هل أنت متأكد من رغبتك في حذف الكمية المتبقية واستبدالها بحجم العبوة الذي قمت بإدخاله؟",
                                                style: GoogleFonts.tajawal(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.right,
                                              )));
                                } else {
                                  print((oldname + caregiverID).toString());
                                  print("test 111");
                                  if (_formKey.currentState!.validate()) {
                                    _firestore
                                        .collection('medicines')
                                        .doc(widget.medID) //new code
                                        // .doc('testtestFAmv3c30ydRn7PkA2jbL9SBXPOp1')
                                        .update({
                                      //  'Generic name': genericName,
                                      'Trade name': medName.text,
                                      'Unit of volume': selectType,
                                      //   'Unit of strength': unitOfStrength,
                                      // 'Volume': volume,
                                      //'Unit of volume': unitOfVolume,
                                      'Package size': packSize.text,
                                      'Remaining Package': packSize.text,
                                      //'barcode': barcode,
                                      'description': meddescription.text,
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
                                                      // "PANADOL"
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

                                    updateDose(doses);
                                    updateDoseEdit(dosesEdit);

                                    print("Med updated");

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Navigation(data: 1,)));
                                  }
                                }
                              },
                              child: Text('حفظ',
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
    if (double.parse(formPack) > 9999) return 'لا يمكنك إدخال اكثر من 4 خانات';
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

    showAlertDialogg(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "لا",
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "نعم ",
        style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      ),
      onPressed: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Navigation(data: 2,)));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text(
        "هل أنت متأكد من العوده دون حفظ التغيرات ",
        style: GoogleFonts.tajawal(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
