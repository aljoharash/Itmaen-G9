import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itmaen/patient-login.dart';

import 'login.dart';

class Directlogin extends StatefulWidget {
  const Directlogin({Key? key}) : super(key: key);

  @override
  _DirectloginState createState() => _DirectloginState();
}

class _DirectloginState extends State<Directlogin> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            child: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                

                  alignment:Alignment.center,
                   decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/Images/background.jpeg'),
                      fit: BoxFit.fill)

                  ////حطي هنا البوكس شادو
                  ),

                    width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                    child: Container(
                        margin: EdgeInsets.all(12),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 120,
                              ),

                              Text(
                                "أهـلًا بــك",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 124, 148, 185),
                                  fontSize: 40,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Text(
                                "أدخل نوع تسجيل الدخول ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 124, 148, 185),
                                  fontSize: 20,
                                  // alignment:Alignment.center,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 70,
                              ),
//////////////////////////////////////////
///////
                              Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MaterialButton(
                                   padding: EdgeInsets.symmetric(
                              vertical: 9, horizontal: 80),
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
                                  "تسجيل الدخول كمقدم الرعاية",
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
                              vertical: 9, horizontal: 98),
                          shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => patientScreen()));
                                },
                                child: Text(
                                  " تسجيل الدخول كمريض",
                                  style: TextStyle(
                                    fontSize: 20, color: Colors.white
                                  ),),),
                                  
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MaterialButton(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 98),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    elevation: 5.0,
                                    height: 40,
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  patientScreen()));
                                    },
                                    child: Text(
                                      " تسجيل الدخول كمريض",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    color: Color.fromARGB(255, 120, 156, 174),
                                  ),
                                ],
                              ),
                            ]))))
          ]),
    )));
  }
}
