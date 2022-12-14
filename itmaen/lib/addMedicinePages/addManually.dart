import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itmaen/setDose.dart';
import 'package:itmaen/trySet.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

class addManually extends StatefulWidget {
  const addManually({Key? key}) : super(key: key);

  @override
  State<addManually> createState() => _addManuallyState();
}

class _addManuallyState extends State<addManually> {
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
  TextEditingController medName = new TextEditingController();
  //TextEditingController doseCount = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController packSize = new TextEditingController();
  bool medExist = false;

  List<String> list = [
    'مل',
     'مجم', 
     'حبة',
  ];
  String? selectType = 'مل';
  double dropDownwidth = 2;
  Color onClickDropDown = Colors.black45;
  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Container(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
          Text(
          item,
        ),      
        ]),
        alignment:Alignment.topRight,
      ),
    );
  }

    String medPicLink = " ";
    Color primary = Color.fromARGB(251, 193, 193, 193);


  void pickUploadNotePic(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("medPictures/${medName.text + caregiverID}.jpg");

    if (image != null) {
      await ref.putFile(File(image.path));
    }

    ref.getDownloadURL().then((value) async {
      setState(() {
        medPicLink = value;
      });
    });
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: const Text(' صورة  ', textAlign: TextAlign.right),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('التقاط صورة', textAlign: TextAlign.right),
                onPressed: () {
                  pickUploadNotePic(ImageSource.camera);
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('اختيار صورة من الملفات',
                    textAlign: TextAlign.right),
                onPressed: () {
                  pickUploadNotePic(ImageSource.gallery);
                  print(pickUploadNotePic.toString());
                  Navigator.pop(context);
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                "الغاء",
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async {
        if (await showDialog(
                builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(
                              "لا",
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Navigation(data: 2)));
                            },
                            child: Text(
                              "نعم",
                            ),
                          ),
                        ],
                        content: Text(
                          "هل أنت متأكد من رغبتك في إلغاء إضافة الدواء؟",
                          style: GoogleFonts.tajawal(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        )),
                context: context) !=
            null) {
          return (await showDialog(
              builder: (context) => AlertDialog(
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            "لا",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Navigation(data: 2)));
                          },
                          child: Text(
                            "نعم",
                          ),
                        ),
                      ],
                      content: Text(
                        "هل أنت متأكد من رغبتك في إلغاء إضافة الدواء؟",
                        style: GoogleFonts.tajawal(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      )),
              context: context));
        } else {
          return false;
        }
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 140, 167, 190),
            elevation: 0,
            title: Text(
              "إضافة دواء يدويًا",
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
                                  GestureDetector(
                                onTap: () {
                                  _selectImage(context);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 80, bottom: 24),
                                  height: 100,
                                  width: 100,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: primary,
                                  ),
                                  child: Center(
                                    child: medPicLink == " "
                                        ? const Icon(
                                            Icons.add_a_photo,
                                            color:
                                                Color.fromARGB(255, 84, 84, 84),
                                            size: 60,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.network(medPicLink),
                                          ),
                                  ),
                                ),
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
                              Text(
                                "وصف الدواء                                                                               ",
                                style: GoogleFonts.tajawal(
                                    fontWeight: FontWeight.bold),
                                textDirection: ui.TextDirection.rtl,
                              ),
                              TextFormField(
                                controller: description,
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
                              contentPadding:const EdgeInsets.only(
                                      left: 14.0,
                                      right: 12.0,
                                      bottom: 8.0,
                                      top: 8.0),
    
                              fillColor: Color.fromARGB(255, 239, 237, 237),
                              filled: true,
                              enabledBorder:OutlineInputBorder(
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
                                          .doc(medName.text + caregiverID)
                                          .set({
                                        'docName': medName.text,
                                        //  'Generic name': genericName,
                                        'Trade name': medName.text,
                                        'Unit of volume': selectType,
                                        //   'Unit of strength': unitOfStrength,
                                        // 'Volume': volume,
                                        //'Unit of volume': unitOfVolume,
                                        'Package size': packSize.text,
                                        'Remaining Package': packSize.text,
                                        //'barcode': barcode,
                                        'description': description.text,
                                        'caregiverID': caregiverID,
                                        'photo': medPicLink,
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
                                                  Navigation(data: 2,)));
                                    }
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
                              SizedBox(
                                height: 20.0,
                              ),
                            ]),
                      ),
                    ),
                  )),
            )
          ])))),
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
