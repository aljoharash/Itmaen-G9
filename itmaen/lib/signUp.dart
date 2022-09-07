import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itmaen/constant.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'SignUpScreen';

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
//final _formKey =GlobalKey<FormState>() ;
  //String username = '';
  late String email;
  late String password;
  //String phoneNum = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        //inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /* Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),*/
              /*TextField(
                key: _formKey,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    username = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: ' اسم المستخدم')),
              SizedBox(
                height: 12.0,
              ), */
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'البريد الالكتروني'),
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
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'الرقم السري'),
              ),
              SizedBox(
                height: 12.0,
              ),
              /*  TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  phoneNum = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'رقم الجوال'),
              ),

              SizedBox(
                height: 24.0,
              ),*/

              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () async {
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
