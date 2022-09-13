import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/patient-login.dart';
import 'package:itmaen/signUp.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'forgot.dart';
import 'home.dart';
//import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  //String uid = '';
  //String? uid = _auth.currentUser?.uid.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), color:Color.fromARGB(255, 107, 137, 162),
        onPressed: () {  Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => patientScreen()));
                             },),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/background.jpg'),
                          fit: BoxFit.fill)
              
                      ////حطي هنا البوكس شادو
                      ),
              
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context)
                      .size
                      .height, //للسماوي اللي شلتيه  كان تحت صفحة بيضاء
              
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.all(12), // بعد عن الأطراف لل
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 220,
                            ),
                            Text(
                              "تسجيل الدخول",
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
                              textAlign: TextAlign.right,
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: 'البريد الإلكتروني ',
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
                              validator: (value) {
                                if (value!.length == 0) {
                                  return "يجب ملء هذا الحقل";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value.trim())) {
                                  return ("الرجاء ادخال بريد إلكتروني صحيح");
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 20,
                            ),
              
                            TextFormField(
                              textAlign: TextAlign.right,
                              controller: passwordController,
                              obscureText: _isObscure3,
                              decoration: InputDecoration(
                                suffixIcon: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: IconButton(
                                      icon: Icon(_isObscure3
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure3 = !_isObscure3;
                                        });
                                      }),
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: 'كلمة المرور',
                                enabled: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0,
                                    right: 12.0,
                                    bottom: 8.0,
                                    top: 15.0),
                                focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                      color: Color.fromARGB(79, 255, 255, 255)),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                        color: Color.fromARGB(255, 236, 231, 231),
                                        width: 3)
                                ),
                              ),
                              validator: (value) {
                                RegExp regex = new RegExp(r'^.{8,}$');
                                if (value!.isEmpty) {
                                  return "يجب ملء هذا الحقل";
                                }
                                if (!regex.hasMatch(value)) {
                                  return ("الرجاء ادخال كلمة مرور صحيحة، أقل عدد 8");
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                passwordController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
              
                            SizedBox(
                              height: 30,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              elevation: 5.0,
                              height: 50,
                              padding: EdgeInsets.symmetric(
                                  vertical: 11, horizontal: 122),
                              onPressed: () {
                                setState(() {
                                  visible = true;
                                });
                                signIn(
                                    emailController.text, passwordController.text);
                              },
                              child: Text(
                                "تسجيل الدخول",
                                        style: GoogleFonts.tajawal(
                                fontSize: 20,
                          
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              color:  Color.fromARGB(255, 140, 167, 190),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Forgotpass()));
                                      },
                                      child: const Text('كلمة المرور',
                                         style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 140, 167, 190),
                                      decoration: TextDecoration.underline,
                                    ))),
                                  Text(
                                    ' نسيت كلمة المرور؟',
                                style: GoogleFonts.tajawal(
                                    fontSize: 20,
                                    color: Color.fromARGB(167, 135, 168, 188),fontWeight: FontWeight.bold),
                                  ),
                                ]),
              
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUpScreen()));
                                      },
                                      child: const Text('إنشاء حساب ',
                                        style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 140, 167, 190),
                                      decoration: TextDecoration.underline,
                                    ))),
                                  Text(
                                    'مستخدم جديد؟',
                                     style: GoogleFonts.tajawal(
                                    fontSize: 20,
                                    color: Color.fromARGB(167, 135, 168, 188),fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            Visibility(
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: visible,
                                child: Container(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))),
              /////////////////////////////////to be removed/////////////////////////
              
                            /////////////////////////////////////////////////////////////////////////
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found') {
          Fluttertoast.showToast(
              msg: " البريد الإلكتروني أو كلمة المرور غير صحيحة ");
        } else if (error.code == 'wrong-password') {
          Fluttertoast.showToast(
              msg: " البريد الإلكتروني أو كلمة المرور غير صحيحة ");
        }
      }
    }
  }
}
