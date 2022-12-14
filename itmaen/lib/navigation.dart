import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itmaen/Notes/HomeScreen.dart';
import 'package:itmaen/addMedicinePages/adddialog.dart';
import 'package:itmaen/callP.dart';
import 'package:itmaen/generateqr.dart';
import 'package:itmaen/patient-login.dart';
import 'package:itmaen/setting.dart';
import 'package:itmaen/view.dart';
import 'package:itmaen/viewD.dart';
//import 'package:';
import 'Notes/addNotes.dart';
import 'add-patient.dart';
import 'alert_dialog.dart';
import 'calendar/test22/newCalendar.dart';
import 'home.dart';
import 'login.dart';
import 'navigationPatient.dart';
import 'notification.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Navigation extends StatefulWidget {
  int data;
   Navigation({Key? key, required this.data}) : super(key: key);

  void sendNotificationchecked(String mediName) async {
    Noti.showBigTextNotification(
        title: "تم أخذ الجرعة",
        body: "${mediName} ",
        fln: flutterLocalNotificationsPlugin);
  }

  void sendNotificationchecked2(String mediName) async {
    Noti.showBigTextNotification(
        title: "تم أخذ الجرعة",
        body: "اطمئن، قام مستقبل رعايتك بأخذ ${mediName}",
        fln: flutterLocalNotificationsPlugin);
  }

  void sendNotificationPackage(String mediName ) async {
    Noti.showBigTextNotification(
        title: "دواء على وشك الانتهاء",
        body: "قارب دواء ${mediName} على الانتهاء، قم بتجديده",
        fln: flutterLocalNotificationsPlugin);
  }

  @override
  State<Navigation> createState() => _NavigationState(this.data);
}

class _NavigationState extends State<Navigation> {
  int data;
  _NavigationState(this.data);
  String title = 'AlertDialog';
  bool tappedYes = false;
  final _auth = FirebaseAuth.instance;
  String caregiverID = "";
  //late User loggedInUser;
  Timer? timer;
  late User? loggedInUser = _auth.currentUser;
  late var _selectedIndex;

  @override
  void initState() {
    super.initState();
  getCurrentUser();
    _selectedIndex= data;
    getCurrentUser();
    Noti.initialize(flutterLocalNotificationsPlugin);

    timer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
      sendNotification();
    });
  }

  void getCurrentUser() async {
    //String qrData="";
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //caregiverID = loggedInUser.uid;
        caregiverID = user.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _isCollectionExits() async {
    print(caregiverID);
    QuerySnapshot<Map<String, dynamic>> _query = await FirebaseFirestore
        .instance
        .collection('patients')
        .where("caregiverID", isEqualTo: loggedInUser!.uid)
        .get();
        print('hereeeeeeee');

    if (_query.docs.isNotEmpty) {
      // Collection exits
      return true;
    } else {
      // Collection not exits
      return false;
    }
  }

  void sendNotification() async {
    var _query;
    await FirebaseFirestore.instance
        .collection('doses')
        .where("caregiverID", isEqualTo: caregiverID)
        .get()
        .then((value) {
      for (var i = 0; i < value.size; i++) {
        print("here is the size");
        print("caregiver");
        print(value.size);
        _query = (value.docs[i].get('Time')).toDate().toString();
        var time_ = DateTime.parse(_query);

        var time = DateTime.parse("2022-09-20 19:43:00.999"); // just for test
        var now = DateTime.now(); // today's time
        var currentTime = DateTime.now();
        var diff = time_
            .difference(currentTime)
            .inMinutes; // getting the difference in mins
        print("here is the difference");
        print(diff);
        if (diff == 4) {
          Noti.showBigTextNotification(
              title: "تذكير بأخذ الجرعة",
              body: ''' 
  [${value.docs[i].get("name")}]
 عزيزي, لا تنسى تذكير مستقبل رعايتك بأخذ جرعته''',
              fln: flutterLocalNotificationsPlugin);
        }
        //else if (diff <= -1440) {
        //   // passed a day over the medication , it will be removed
        //   value.docs[i].reference.delete();
        // }
      } // end for
    });
    // }
  }

 

  
  Future<Widget> bodyFunction() async {
    // _selectedIndex = _select ; 
    // _selectedIndex = data; 
    try {
      switch (_selectedIndex) {
        // case 0:
        //   return;
        //   break;

        case 0:
          if (await _isCollectionExits() == true) {
            return GenerateQR();
          } else  {
            return AddPatient();
          }

          break;

        case 1:
          return HomeScreen();
          break;
        case 2:
          return View();
          break;

        case 3:
          return LoadDataFromFireStoree();
          break;

        case 4:
          return ViewD();
          break;

        default:
          return View();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      if (caregiverID != null) {
        final action = await AlertDialogs.yesCancelDialog(
            context, 'تسجيل الخروج', 'هل أنت متأكد من رغبتك في تسجيل الخروج؟');
        if (action == DialogsAction.yes) {
          timer?.cancel(); // stop the timer // no more notification
          setState(() => timer!.cancel());
          timer = null;

          timer?.cancel(); //
          await FirebaseAuth.instance.signOut();
          timer?.cancel();
          loggedInUser = null;
          //timer=null;
          timer?.cancel();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
          timer?.cancel();
          timer = null;
        } else {
          setState(() => tappedYes = false);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Navigation(data: 4,)));
        }
      } else {
        final action = await AlertDialogs.yesCancelDialog(
            context, 'تسجيل الخروج', 'هل أنت متأكد من رغبتك في تسجيل الخروج؟');
        if (action == DialogsAction.yes) {
          timer?.cancel(); // stop the timer
          timer = null;
          setState(() => timer!.cancel());
          timer?.cancel();
          timer = null;
          // await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => patientScreen()));
          timer?.cancel();
          timer = null;
        } else {
          setState(() => tappedYes = false);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigationPatient()));
        }
      }
    }

    Future<void> _onItemTapped(int index) async {
      setState(() {
        //index = data ; 
        _selectedIndex = index;
      });
      // if (index == 0) {
      //   logout();
      // }
      // if (index == 1) {
      //   if (await _isCollectionExits() == true) {
      //     Navigator.of(context)
      //         .push(MaterialPageRoute(builder: (context) => GenerateQR()));
      //   }
      // }
    }

    return Scaffold(
      body: FutureBuilder<Widget>(
          future: bodyFunction(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            }

            return Container(child: CircularProgressIndicator());
          }),
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Color.fromARGB(255, 140, 167, 190),
        animationDuration: Duration(milliseconds: 300),
        items: [
          // Icon(
          //   Icons.logout,
          //   color: Colors.white,
          // ),
          Icon(
            Icons.person_add,
            color: Colors.white,
          ),
          FaIcon(
            Icons.assignment,
            color: Colors.white,
          ),
          Icon(
            FontAwesomeIcons.pills,
            color: Colors.white,
          ),
          Icon(
            Icons.calendar_month,
            color: Colors.white,
          ),
          Icon(
            Icons.home,
            color: Colors.white,
          ),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
