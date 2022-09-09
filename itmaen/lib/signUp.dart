import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itmaen/constant.dart';

import 'firebase.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'SignUpScreen';

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
//final _formKey =GlobalKey<FormState>() ;
  var username = '';
  var email = '';
  var password = '';
  var phoneNum = '';

  @override
  Widget build(BuildContext context) {
    var children2 = <Widget>[
      Flexible(
        child: Hero(
          tag: 'logo',
          child: Container(
            height: 200.0,
            child: Image.asset('images/logo.jpg'),
          ),
        ),
      ),
      SizedBox(
        height: 48.0,
      ),
      TextField(
          //key: _formKey,
          textAlign: TextAlign.center,
          onChanged: (value) {
            username = value;
          },
          decoration: kTextFieldDecoration.copyWith(hintText: ' اسم المستخدم')),
      SizedBox(
        height: 12.0,
      ),
      TextField(
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        onChanged: (value) {
          email = value;
        },
        decoration:
            kTextFieldDecoration.copyWith(hintText: 'البريد الالكتروني'),
      ),
      SizedBox(
        height: 12.0,
      ),
      TextField(
        obscureText: true,
        textAlign: TextAlign.center,
        onChanged: (value) {
          password = value;
        },
        decoration: kTextFieldDecoration.copyWith(hintText: 'الرقم السري'),
      ),
      SizedBox(
        height: 12.0,
      ),
      TextField(
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        onChanged: (value) {
          phoneNum = value;
        },
        decoration: kTextFieldDecoration.copyWith(hintText: 'رقم الجوال'),
      ),
      SizedBox(
        height: 24.0,
      ),
      TextButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side:
                        BorderSide(color: Color.fromARGB(255, 54, 158, 244))))),
        onPressed: () async {
          try {
            final newUser = await _auth.createUserWithEmailAndPassword(
                email: email, password: password);

            User? updateUser = FirebaseAuth.instance.currentUser;
            //updateUser?.updateDisplayName(username);
            userSetup(username, email, password, phoneNum);
          } catch (e) {
            print(e);
          }
        },
        child: Text('انشاء حساب'),
      )
    ];

    /*Future addUserDetails(var username1, var mobileNumber, var email1) async {
      await FirebaseFirestore.instance.collection('caregivers').add({
        'user name': username1,
        'mobile number': mobileNumber,
        'email': email1
      });
    }

    addUserDetails(username, phoneNum, email); */

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children2,
          ),
        ),
      ),
    );
  }
}
