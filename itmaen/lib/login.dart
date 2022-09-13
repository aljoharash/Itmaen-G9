import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/Images/background.jpeg'),
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
                          height: 190,
                        ),
                        Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 124, 148, 185),
                            fontSize: 40,
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
                          
                            suffixIcon: IconButton(
                            
                                icon: Icon(_isObscure3
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure3 = !_isObscure3;
                                  });
                                }),
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
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: new BorderRadius.circular(10),
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
                          height: 20,
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          elevation: 5.0,
                          height: 40,
                          padding: EdgeInsets.symmetric(
                              vertical: 9, horizontal: 138),
                          onPressed: () {
                            setState(() {
                              visible = true;
                            });
                            signIn(
                                emailController.text, passwordController.text);
                          },
                          child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          color: Color.fromARGB(255, 120, 156, 174),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                          children:[ 
                                  TextButton(onPressed: (){
                                     Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Forgotpass()));
                                  },
                         child: const Text('كلمة المرور',style: TextStyle(fontSize:20, color: Color.fromARGB(255, 127, 187, 222), decoration: TextDecoration.underline,))),
                            Text(' نسيت كلمة المرور؟',  style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 156, 184, 201)),),
                         
                          ]
                        ),
                       
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                          children:[ 
                                  TextButton(onPressed: (){
                                     Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                                  },
                         child: const Text('إنشاء حساب ',style: TextStyle(fontSize:20, color: Color.fromARGB(255, 127, 187, 222), decoration: TextDecoration.underline,))),
                            Text('مستخدم جديد؟',  style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 156, 184, 201)),),
                         
                          ]
                        ),
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
          ],
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
