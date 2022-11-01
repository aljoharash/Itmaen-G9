import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:itmaen/login.dart';
import 'dart:ui' as ui;
import 'package:itmaen/successSave.dart';
import 'package:itmaen/view.dart';
import 'package:itmaen/viewDailyDoses.dart';

import 'navigation.dart';

class editProfile extends StatefulWidget {
  final String name;
  final String email;
  final String pass;
  final String mobile;

  const editProfile(
      {Key? key,
      required this.name,
      required this.email,
      required this.pass,
      required this.mobile})
      : super(key: key);

  @override
  _editProfile createState() => _editProfile();
}

class _editProfile extends State<editProfile> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String caregiverID = "";
  late User loggedInUser;
  var newPassword = ""; //auth updates
  var newEmail = ""; //auth updates
  String caregiverID2 = '';
  static String nameO = "";
  static String emailO = "";
  static String PassO = "";
  static String MobileO = "";

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

  final newPasswordController = TextEditingController();
  final newEmailController = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController phoneNum = new TextEditingController();

  @override
  void initState() {
    retrieve2();
    nameO = widget.name;
    emailO = widget.email;
    PassO = widget.pass;
    MobileO = widget.mobile;
    username.text = nameO;
    newEmailController.text = emailO;
    newPasswordController.text = PassO;
    phoneNum.text = MobileO;

    super.initState();
    getCurrentUser();
    retrieve2();
    print("here");
  }

  Future retrieve2() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      caregiverID2 = loggedInUser.uid;
      //print("yyy");
      //print(caregiverID2);
      //print("enterd");
      //StreamBuilder(
      //  stream:FirebaseFirestore.instance.collection('caregivers')
      var collection = FirebaseFirestore.instance.collection('caregivers');
      var docSnapshot = await collection.doc(caregiverID2).get();
      if (!docSnapshot.exists) {
        print("ops");
      } else if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        // You can then retrieve the value from the Map like this:
        nameO = data['user name'];
        emailO = data['email'];
        PassO = data['password'];
        MobileO = data['mobileNum'];
      }
    }
  }

  //TextEditingController email = new TextEditingController();
  //TextEditingController password = new TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updateEmail(newEmail);
      await currentUser!.updatePassword(newPassword);
      //FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            ' تم حفظ التغيرات بنجاح',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    retrieve2();
    print("goal");
    print(emailO);
    print(nameO);
    print(PassO);
    print(MobileO);
    /*
    final newPasswordController = TextEditingController(text: PassO);
    final newEmailController = TextEditingController(text: emailO);
    TextEditingController username = TextEditingController(text: nameO);
    TextEditingController phoneNum = new TextEditingController(text: MobileO);*/
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 167, 190),
          title: Center(
              child: Text(
            "         الملف الشخصي                      ",
            textAlign: TextAlign.left,
            style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
          )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              if (newEmailController.text != widget.email ||
                  newPasswordController.text != widget.pass ||
                  username.text != widget.name ||
                  phoneNum.text != widget.mobile) {
                print("entered");
                showAlertDialogg(context);
              } else {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Navigation()));
              }
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          SingleChildScrollView(
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
                    height: 180,
                  ),
                  Icon(
                    Icons.person,
                    size: 60,
                  ),
                  SizedBox(
                    height: 19,
                  ),

                  Text(
                    "الاسم                                                                                     ",
                    textAlign: TextAlign.right,
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    autofocus: false,
                    textAlign: TextAlign.right,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Color.fromARGB(255, 239, 237, 237),
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
                    controller: username,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "يجب ملء هذا الحقل";
                      String pattern =
                          r'^(?=.{2,20}$)[\u0621-\u064Aa-zA-Z\d\-_\s]+$';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value.trim()))
                        return '  يجب أن يحتوي اسم المستخدم على حرفين على الاقل وأن لايتجاوز ٢٠حرف ';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  Text(
                    "البريد الالكتروني                                                                          ",
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    textDirection: ui.TextDirection.rtl,
                  ),
                  TextFormField(
                      autofocus: false,
                      textAlign: TextAlign.right,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
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
                      controller: newEmailController,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "يجب ملء هذا الحقل";
                        String pattern = r'\w+@\w+\.\w+';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value.trim()))
                          return 'البريد الاكتروني المدخل غير صحيح';
                        return null;
                      }),
                  SizedBox(
                    height: 19,
                  ),

                  Text(
                    "الرقم السري                                                                               ",
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                    textDirection: ui.TextDirection.rtl,
                  ),
                  TextFormField(
                    autofocus: false,
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    // ignore: prefer_const_constructors
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      // labelText: 'الرقم السري ',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Color.fromARGB(255, 239, 237, 237),
                      // hintText: 'رقم الهاتف ',
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
                    controller: newPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "يجب ملء هذا الحقل";
                      String pattern =
                          r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value.trim()))
                        return ('يجب أن تتكون كلمة المرور على ٨ رموز(منها حرف ورقم على الاقل) ');
                      ; // check arabic formation
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 19,
                  ),
                  Text(
                      "                                       رقم الجوال                                      ",
                      style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                      //textDirection: ui.TextDirection.rtl,
                      textAlign: TextAlign.right),
                  //textAlign=TextAlign.right,

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    autofocus: false,
                    //obscureText: true,
                    // ignore: prefer_const_constructors
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      // labelText: 'الرقم السري ',
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      filled: true,
                      fillColor: Color.fromARGB(255, 239, 237, 237),
                      // hintText: 'رقم الهاتف ',
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
                    controller: phoneNum,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "يجب ملء هذا الحقل";
                      String pattern = r'^(?:[+0]9)?[0-9]{10}$';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value.trim()))
                        return '  رقم الهاتف يجب أن يتكون من أرقام فقط';
                      if (value.length != 10)
                        return ' رقم الهاتف يجب أن يتكون من ١٠ أرقام';
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  //),

                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    elevation: 5.0,
                    height: 50,
                    padding:
                        EdgeInsets.symmetric(vertical: 11, horizontal: 122),
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState!.validate()) {
                        getCurrentUser();
                        print(caregiverID + "ggggg");
                        _firestore
                            .collection('caregivers')
                            .doc(caregiverID)
                            .update({
                          'user name': username.text,
                          'email': newEmailController.text,
                          'password': newPasswordController.text,
                          'mobileNum': phoneNum.text,
                          'uid': caregiverID
                        });

                        setState(() {
                          retrieve2();

                          newPassword = newPasswordController.text;
                          newEmail = newEmailController.text;
                        });
                        changePassword();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const success(
                                      title: '',
                                    )));
                      }
                      print("goal");
                      print(emailO);
                      print(nameO);
                      print(PassO);
                      print(MobileO);
                    },
                    child: Text(
                      'حفظ ',
                      style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    color: Color.fromARGB(255, 140, 167, 190),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    elevation: 5.0,
                    height: 50,
                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 90),
                    onPressed: () async {
                      showAlertDialog(context);
                      /*
                      final user = await _auth.currentUser;
                      await user?.delete();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));*/
                    },
                    child: Text(
                      'حذف الحساب ',
                      style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    color: Color.fromARGB(255, 212, 17, 17),
                  ),
                ],
              ),
            ),
          )))
        ]))));
  }

  showAlertDialog(BuildContext context) {
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
      onPressed: () async {
        final user = await _auth.currentUser;
        await user?.delete();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(""),
      content: Text(
        "هل أنت متأكد من حذف الحساب؟ ",
        style: GoogleFonts.tajawal(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.right,
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
            MaterialPageRoute(builder: (context) => Navigation()));
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
