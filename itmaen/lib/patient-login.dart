import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/home.dart';
import 'package:itmaen/login.dart';
import 'package:itmaen/navigation.dart';
import 'package:itmaen/scanqr.dart';
import 'package:itmaen/secure-storage.dart';
import 'view.dart';

import 'biometric-auth.dart';

class patientScreen extends StatelessWidget {
  StorageService st = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: AssetImage('images/background.jpg'),
            //  image: AssetImage('assets/Images/background.jpeg'),
            fit: BoxFit.contain,
          ),

          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          'أهلا بك!',
                          style: GoogleFonts.tajawal(
                            fontSize: 30,
                            //fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 122, 164, 186),
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'من فضلك قم بتسجيل الدخول',
                          style: GoogleFonts.tajawal(
                            fontSize: 25,
                            //fontStyle: FontStyle.italic,
                            color: Color.fromARGB(255, 122, 164, 186),
                            fontWeight: FontWeight.bold,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        // Image.asset(
                        //   'assets/Images/background.jpeg',

                        // )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 25, left: 24, right: 24),
                      child: MaterialButton(
                        onPressed: () async {
                          // st.deleteSecureData("caregiverID");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ScanQR()));
                        },
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color.fromARGB(255, 140, 167, 190),
                        child: Text(
                          'تسجيل الدخول لأول مرة بمسح الكود',
                          style: GoogleFonts.tajawal(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 25, left: 24, right: 24),
                      child: MaterialButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color.fromARGB(255, 140, 167, 190),
                        onPressed: () async {
                          bool isAuthenticated = await BiometricAuthentication
                              .authenticateWithBiometrics();

                          String? id = await st.readSecureData("caregiverID");

                          print(id);
                          if (isAuthenticated && id != null) {
                            // WE SHOULD READ FROM THE STORAGE ALSO IF THE IS A CAREGIVER
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => View(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'خطأ في تسجيل الدخول! في حال كنت مستخدم للتطبيق لأول مرة يرجى مسح الكود',
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.right),
                              ),
                            );
                            //  );
                          }
                        },
                        child: Text(
                          'تسجيل الدخول السريع',
                          style: GoogleFonts.tajawal(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 248, 250, 250),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: const Text('اضغط هنا لتسجيل الدخول',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 140, 167, 190),
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                          Text(
                            ' مقدم رعاية؟ ',
                            style: GoogleFonts.tajawal(
                                fontSize: 20,
                                color: Color.fromARGB(167, 135, 168, 188),
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                    // Container(
                    //   height: 80,
                    //   width: double.infinity,
                    //   padding:
                    //       const EdgeInsets.only(top: 25, left: 24, right: 24),
                    //   child: ElevatedButton(
                    //     // elevation: 0,
                    //     // shape: RoundedRectangleBorder(
                    //     //     borderRadius: BorderRadius.circular(25),
                    //     // ),
                    //     // color: Colors.white,
                    //     onPressed: () => Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //             builder: (context) => HomePage())),
                    //     child: Text(
                    //       'GO TO HOME PAGE [FOR TEST] WILL BE REMOVED',
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w700,
                    //         color: Color.fromARGB(255, 248, 250, 250),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
