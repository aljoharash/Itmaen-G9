import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      extendBodyBehindAppBar: true,
       appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), color:Color.fromARGB(255, 107, 137, 162),
        onPressed: () {  Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                             },),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  //  color: Colors.blueGrey,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/background.jpg'),
                          // image: AssetImage('assets/images/background.jpeg'),
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
                                  style: GoogleFonts.tajawal(
                            fontSize: 30,
                            //fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 122, 164, 186),
                            fontWeight: FontWeight.bold,
                          ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "أدخل بريدك الإلكتروني المسجل وسيتم إرسال رابط ستتمكن من خلاله استعادة حسابك",
                                style: GoogleFonts.tajawal(
                            fontSize: 20,
                            //fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 122, 164, 186),
                            fontWeight: FontWeight.bold,
                          ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textAlign: TextAlign.right,
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(255, 239, 237, 237),
                                hintText: 'البريد الإلكتروني',
                                enabled: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 19.0,
                                    right: 12.0,
                                    bottom: 8.0,
                                    top: 8.0),
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
                                  return ("الرجاء ادخال بريد إلكتروني صحيح");
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
                                      vertical: 11, horizontal: 160),
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
                                       style: GoogleFonts.tajawal(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                                  ),
                                  color: Color.fromARGB(255, 140, 167, 190),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                MaterialButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 11, horizontal: 123),
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
                                     style: GoogleFonts.tajawal(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                                  ),
                                  color: Color.fromARGB(255, 140, 167, 190),
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
