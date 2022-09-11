import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Forgotpass extends StatefulWidget {
  const Forgotpass({Key? key}) : super(key: key);

  @override
  _ForgotpassState createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  // bool showProgress = false;
  bool visible = false;
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
              //  color: Colors.blueGrey,
              alignment:Alignment.center,
                   decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.jpeg'),
                      fit: BoxFit.fill)

                  ////حطي هنا البوكس شادو
                  ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Container(
                    
                    margin: EdgeInsets.all(12),
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
                            
                            "نسيت كلمة المرور؟",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:  Color.fromARGB(255, 124, 148, 185),
                              fontSize: 40,
                              
                            ),
                               textAlign:TextAlign.center,
                          ),
                          Text(
                            "أدخل بريدك الإلكتروني المسجل وسيتم إرسال رابط ستتمكن من خلاله استعادة حسابك.",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:  Color.fromARGB(255, 124, 148, 185),
                              fontSize: 20,
                             // alignment:Alignment.center,
                            ),
                              textAlign:TextAlign.center,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              textAlign:TextAlign.right,
                            controller: emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 239, 237, 237),
                              hintText: 'البريد الإلكتروني',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 19.0,right:12.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(10),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.length == 0) {
                                return "يجب ملء هذا الحقل";
                              }
                              if (!RegExp(
                                      "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return ("أرجو ادخال بريد إلكتروني صحيح");
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              // emailController.text = value!;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MaterialButton(
                                   padding: EdgeInsets.symmetric(
                              vertical: 9, horizontal: 170),
                             shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () {
                                  Forgotpassss(emailController.text);
                                  setState(() {
                                    visible = true;
                                  });
                                },
                                child: Text(
                                  "إرسال",
                                  style: TextStyle(
                                    fontSize: 20, color: Colors.white
                                  ),
                                ),
                                color:  Color.fromARGB(255, 120, 156, 174),
                              ),
                                 SizedBox(
                          height: 20,
                        ),
                              MaterialButton(
                                    padding: EdgeInsets.symmetric(
                              vertical: 9, horizontal: 138),
                          shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    fontSize: 20, color: Colors.white
                                  ),
                                ),
                               color:  Color.fromARGB(255, 120, 156, 174),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void Forgotpassss(String email) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .sendPasswordResetEmail(email: email)
          .then((uid) => {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()))
              })
          .catchError((e) {});
    }
  }
}
