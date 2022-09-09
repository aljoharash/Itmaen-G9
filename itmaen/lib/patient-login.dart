import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itmaen/home.dart';
import 'package:itmaen/scanqr.dart';
import 'package:itmaen/secure-storage.dart';

import 'biometric-auth.dart';

class patientScreen extends StatelessWidget {
  StorageService st = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              //put the logo here
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     image: Image()
              //       // image: NetworkImage(
              //       //     'https://images.unsplash.com/photo-1557683316-973673baf926?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE4fHx8ZW58MHx8fHw%3D&w=1000&q=80'),
              //       // fit: BoxFit.fill
              //       ),
              // ),

              ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'أهلا بك',
                          style: TextStyle(
                              fontSize: 55,
                              // fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 118, 176, 186),
                              fontFamily: 'Madani Arabic Black'),
                          textDirection: TextDirection.rtl,
                          // textAlign: TextAlign.left,
                        ),
                        Text(
                          'من فضلك قم بتسجيل الدخول',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.blueGrey,
                            fontFamily: 'Madani Arabic Black',
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        Image.asset(
                          'assets/Images/itmaenlogo.png',
                          height: 400,
                          width: 400,
                        )
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
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Colors.blueGrey,
                        child: Text(
                          'تسجيل الدخول لأول مرة بمسح الكود',
                          style: TextStyle(
                            fontSize: 20,
                            // fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Madani Arabic Black',
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
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Colors.blueGrey,
                        onPressed: () async {
                          bool isAuthenticated = await BiometricAuthentication
                              .authenticateWithBiometrics();

                          String? id = await st.readSecureData("caregiverID");

                          print(id);
                          if (isAuthenticated && id != null) {
                            // WE SHOULD READ FROM THE STORAGE ALSO IF THE IS A CAREGIVER
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'خطأ في تسجيل الدخول! في حال كنت مستخدم للتطبيق لأول مرة يرجى مسح الكود'),
                              ),
                            );
                            //  );
                          }
                        },
                        child: Text(
                          'تسجيل الدخول السريع',
                          style: TextStyle(
                              fontSize: 20,
                              // fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 248, 250, 250),
                              fontFamily: 'Madani Arabic Black'),
                        ),
                      ),
                    ),
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
