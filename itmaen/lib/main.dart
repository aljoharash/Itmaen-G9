import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:workmanager/workmanager.dart';

//Just For Testing that your database works ! Remove the code below after testing (Windows Usesrs)
import 'directLogin.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:itmaen/patient-login.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'navigation.dart';
import 'viewD.dart';

// void callbackDispatcher(){
//   Workmanager().executeTask((task, inputData) {
  
// 	Navigation();
//   ViewD(); 
 
// 	return Future.value(true);
// });

// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//    Workmanager().initialize(
	
// 	// The top level function, aka callbackDispatcher
// 	callbackDispatcher); 
//  // Workmanager().registerPeriodicTask('task','number1' , frequency: const Duration(seconds: 60));
//    Workmanager().registerOneOffTask('task','number1');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', ''),
        Locale('en', ''), // English, no country code
      ],
      locale: Locale('en', ''),
      //Given Title
      title: 'إطمئن',
      debugShowCheckedModeBanner: false,
      //Given Theme Color
      theme: ThemeData(
          //primarySwatch: Colors.blueGrey,
          ),
      home: patientScreen(),
    );
  }
}
