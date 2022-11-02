import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
  TextEditingController title = new TextEditingController();
  TextEditingController note = new TextEditingController();
  List<String> list = ['عام', 'طارئ', 'حساسية', 'آثار جانبية'];
  String? selectType = "عام";
  Color? iconColor;
  double dropDownwidth = 2;
  Color onClickDropDown = Colors.black45;
  DropdownMenuItem<String> buildMenuItem(String item) {
    if (item == 'عام') {
      iconColor = Color.fromARGB(255, 148, 207, 255);
    } else if (item == 'طارئ') {
      iconColor = Color.fromARGB(255, 255, 160, 153);
    } else if (item == 'حساسية') {
      iconColor = Color.fromARGB(255, 223, 255, 207);
    } else if (item == 'آثار جانبية') {
      iconColor = Color.fromARGB(255, 255, 200, 117);
    }
    return DropdownMenuItem(
      value: item,
      child: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            item,
          ),
          SizedBox(
            width: 15,
          ),
          Icon(
            Icons.circle_rounded,
            color: iconColor,
            size: 15,
          ),
        ]),
        alignment: Alignment.topRight,
      ),
    );
  }

  bool medExist = false;
  String notesPicLink = " ";
  Color primary = Color.fromARGB(251, 193, 193, 193);

    void pickUploadNotePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instance
        .ref().child("notes/notepic.jpg");

      if(image != null){
      await ref.putFile(File(image.path));
      }

    ref.getDownloadURL().then((value) async {
      setState(() {
       notesPicLink = value;
      });
    });
  }


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
                height: MediaQuery.of(context)
                    .size
                    .height, //للسماوي اللي شلتيه  كان تحت صفحة بيضاء

                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(10), // بعد عن الأطراف لل
                    child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
              onTap: () {
                pickUploadNotePic();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 80, bottom: 24),
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primary,
                ),
                child: Center(
                  child: notesPicLink == " " ? const Icon(
                    Icons.add_a_photo,
                    color: Color.fromARGB(255, 84, 84, 84),
                    size: 60,
                  ) : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(notesPicLink),
                  ),
                ),
              ),
            ),

                            TextFormField(
                              controller: title,
                              textAlign: TextAlign.right,
                              validator: (value){
                                if (value == null || value.isEmpty)
                                  return 'الرجاء ادخال عنوان الملاحظة';
                                String pattern =
                                    r'^(?=.{2,30}$)[\u0621-\u064Aa-zA-Z\d\-_\s]+$';
                                RegExp regex = RegExp(pattern);
                                if (!regex.hasMatch(value.trim()))
                                  return 'يجب أن يحتوي العنوان من حرف واحد إلى 30 حرف وأن يكون خالي من الرموز';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: 'عنوان الملاحظة',
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
                              height: 16,
                            ),
                            TextFormField(
                              minLines: 9,
                              maxLines: 14,
                              controller: note,
                              validator: (value){
                                if (value == null || value.isEmpty)
                                  return 'الرجاء ادخال الملاحظة';
                                  String pattern =
                                    r'[^ ]';
                                RegExp regex = RegExp(pattern);
                                if (!regex.hasMatch(value.trim()))
                                  return 'يجب أن لا تحتوي الملاحظة على مسافات فارغة';
                                return null;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              height: 16.0,
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
                              height: 20,
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
                                print(iconColor);

                                if (selectType == 'عام') {
                                  iconColor =
                                      Color.fromARGB(255, 148, 207, 255);
                                } else if (selectType == 'طارئ') {
                                  iconColor =
                                      Color.fromARGB(255, 255, 160, 153);
                                } else if (selectType == 'حساسية') {
                                  iconColor =
                                      Color.fromARGB(255, 223, 255, 207);
                                } else if (selectType == 'آثار جانبية') {
                                  iconColor =
                                      Color.fromARGB(255, 255, 200, 117);
                                }
                                if (_formKey.currentState!.validate()) {
                                  _firestore
                                      .collection('Notes')
                                      .doc(title.text + caregiverID)
                                      .set({
                                    'caregiverID': caregiverID,
                                    'note_title': title.text,
                                    'note_content': note.text,
                                    'creation_date': DateTime.now()
                                        .toString()
                                        .substring(0, 16),
                                    'color': int.parse(
                                        iconColor.toString().substring(6, 16)),
                                    'type': selectType,
                                    'docName': title.text,
                                    'photo': notesPicLink
                                  });

                                  print("Note added");

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Navigation()));
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
        ]))));
  }
}
