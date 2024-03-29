import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itmaen/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui;

class editNote extends StatefulWidget {
  QueryDocumentSnapshot doc;
  editNote({Key? key, required this.doc}) : super(key: key);

  @override
  State<editNote> createState() => _editNoteState();
}

class _editNoteState extends State<editNote> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late List<String> toBeTransformed = [];

  String caregiverID = "";
  late User loggedInUser;

  String? selectType;
  TextEditingController title = new TextEditingController();
  TextEditingController note = new TextEditingController();

  @override
  void initState() {
    selectType = widget.doc['type'];
    title.text = widget.doc['note_title'];
    note.text = widget.doc['note_content'];
    getCurrentUser();
  }

  var oldname;
  var snapShotsValueCheck;
  var titlee;
  List<String> titles = <String>[];

  retrieveCheck(QuerySnapshot snapshot) {
    print("here");
    snapshot.docs.forEach((doc) {
      // medname = doc['Trade name'];
      // description = doc['description'];
      // package = doc['Package size'];
      // strength = doc['Strength value'];
      titlee = doc['note_title'];
      titles.add(titlee);
      print(titlee);
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
        print("name: $oldname");
      });
    }

    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser.uid;
      }
    } catch (e) {
      print(e);
    }

    var snapShotsValue = await FirebaseFirestore.instance
        .collection("Notes")
        .where('caregiverID', isEqualTo: caregiverID)
        .where('note_title', isEqualTo: widget.doc['note_title'])
        .get();

    snapShotsValueCheck = await FirebaseFirestore.instance
        .collection("Notes")
        .where('caregiverID', isEqualTo: caregiverID)
        .get();

    retrieve(snapShotsValue);
  }

  final _formKey = GlobalKey<FormState>();
  List<String> list = ['عام', 'طارئ', 'حساسية', 'آثار جانبية'];

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
        .ref()
        .child("notes/${title.text + caregiverID}.jpg");

    if (image != null) {
      await ref.putFile(File(image.path));
    }

    ref.getDownloadURL().then((value) async {
      setState(() {
        notesPicLink = value;
      });
    });
  }

  Widget getWidget() {
    if (widget.doc['photo'] == " " && notesPicLink == " ") {
      return Text(
        "لم يتم تحميل اي صورة",
        style: GoogleFonts.tajawal(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      );
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: notesPicLink == " "
              ? Image.network(widget.doc['photo'])
              : Image.network(notesPicLink));
    }
  }

  Widget getWidget2() {
    if (widget.doc['photo'] == " " && notesPicLink == " ") {
      return const Icon(
        Icons.photo,
        color: Color.fromARGB(255, 84, 84, 84),
        size: 60,
      );
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: notesPicLink == " "
              ? Image.network(widget.doc['photo'])
              : Image.network(notesPicLink));
    }
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
                                  builder: (context) => Navigation(data: 1)));
                            },
                            child: Text(
                              "نعم",
                            ),
                          ),
                        ],
                        content: Text(
                          "هل أنت متأكد من رغبتك في إلغاء تعديل الملاحظة؟",
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
                        "هل أنت متأكد من رغبتك في إلغاء تعديل الملاحظة؟",
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
              "تعديل ملاحظة",
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
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(actions: [
                                            Container(
                                                width: 400,
                                                height: 400,
                                                child: getWidget())
                                          ]));
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
                                  child: Stack(children: [
                                    Center(child: getWidget2()),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: CircleAvatar(
                                          //radius: 20,
                                          backgroundColor:
                                              Color.fromARGB(255, 140, 167, 190),
                                          child: ElevatedButton(
                                            child: Icon(
                                              Icons.add_a_photo,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              pickUploadNotePic();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(5),
                                              //backgroundColor: Color.fromARGB(255, 140, 167, 190),
                                              primary: Color.fromARGB(
                                                  255, 140, 167, 190),
                                              surfaceTintColor: Color.fromARGB(
                                                  255, 84, 106, 125),
                                            ),
                                          )),
                                    ),
                                  ]),
                                ),
                              ),
                              TextFormField(
                                controller: title,
                                textAlign: TextAlign.right,
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'الرجاء ادخال عنوان الملاحظة';
                                  String pattern =
                                      r'^(?=.{2,30}$)[\u0621-\u064Aa-zA-Z\d\-_\s]+$';
                                  RegExp regex = RegExp(pattern);
                                  if (!regex.hasMatch(value.trim()))
                                    return 'يجب أن يحتوي العنوان من حرف واحد إلى 30 حرف وأن يكون خالي من الرموز';
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'الرجاء ادخال الملاحظة';
                                  String pattern = r'[^ ]';
                                  RegExp regex = RegExp(pattern);
                                  if (!regex.hasMatch(value.trim()))
                                    return 'يجب أن لا تحتوي الملاحظة على مسافات فارغة';
                                  return null;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                  var doc = await _firestore
                                      .collection("Notes")
                                      .doc(title.text + caregiverID)
                                      .get();
    
                                  var exist = false;
                                  retrieveCheck(snapShotsValueCheck);
    
                                  for (int i = 0; i < titles.length; i++) {
                                    print(titles[i]);
                                    print(title.text);
                                    if (titles[i] == title.text &&
                                        titles[i] != widget.doc['note_title']) {
                                      print('exist');
                                      print(titles[i]);
                                      exist = true;
                                    }
                                  }
    
                                  if (exist) {
                                    print("already exist");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        // margin: EdgeInsets.only(right: 10),
    
                                        content: Text('تمت إضافة الملاحظة مسبقًا',
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.right),
                                      ),
                                    );
                                  } else {
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
                                          .doc(oldname + caregiverID)
                                          .update({
                                        'caregiverID': caregiverID,
                                        'note_title': title.text,
                                        'note_content': note.text,
                                        'creation_date': DateTime.now()
                                            .toString()
                                            .substring(0, 16),
                                        'color': int.parse(iconColor
                                            .toString()
                                            .substring(6, 16)),
                                        'type': selectType,
                                        'photo': widget.doc['photo'] == " "
                                            ? notesPicLink
                                            : widget.doc['photo'],
                                      });
    
                                      print("Note updated");
    
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
                            ]),
                      ),
                    ),
                  )),
            )
          ])))),
    );
  }
}
