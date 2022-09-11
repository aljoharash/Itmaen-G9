import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

//Just For Testing that your database works ! Remove the code below after testing (Windows Usesrs)
import 'directLogin.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:itmaen/patient-login.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Given Title
      title: 'إطمئن',
      debugShowCheckedModeBanner: false,
      //Given Theme Color
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: patientScreen(),
    );
  }
}
