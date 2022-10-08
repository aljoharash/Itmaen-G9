import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:itmaen/patient-login.dart';
import 'package:itmaen/secure-storage.dart';
import 'package:itmaen/view.dart';
import 'package:itmaen/viewD.dart';
import 'alert_dialog.dart';
import 'calendar/patientCalendar2.dart';
import 'calendar/test22/newCalendar.dart';
import 'login.dart';
import 'navigation.dart';
import 'notification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NavigationPatient extends StatefulWidget {
  const NavigationPatient({Key? key}) : super(key: key);

  // void sendNotificationchecked(String mediName) async {
  //   Noti.showBigTextNotification(
  //       title: "تم أخذ الجرعة",
  //       body: "${mediName} ",
  //       fln: flutterLocalNotificationsPlugin);
  // }

  @override
  State<NavigationPatient> createState() => _NavigationPatientState();
}

class _NavigationPatientState extends State<NavigationPatient> {
  String title = 'AlertDialog';
  bool tappedYes = false;
  final _auth = FirebaseAuth.instance;
  String caregiverID = "";
  late User loggedInUser;
  String id_ = "";
  Timer? timer;
  StorageService st = StorageService();
  @override
  void initState() {
    super.initState();
    getCurrentUser();

    Noti.initialize(flutterLocalNotificationsPlugin);
    timer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
      sendNotification();
    });
    print('first');
  }

  void getCurrentUser() async {
    //String qrData="";
    id_ = (await st.readSecureData("caregiverID"))!;
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser.uid;
        id_ = (await st.readSecureData("caregiverID"))!;
      }
    } catch (e) {
      print(e);
    }
  }

  void sendNotification() async {
    print('second');
    var _query;
    await FirebaseFirestore.instance
        .collection('doses')
        .where("caregiverID", isEqualTo: id_)
        .get()
        .then((value) {
      for (var i = 0; i < value.size; i++) {
        print(id_);
        print("patirnt");
        print("here is the size");
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
 لقد تبقى 5 دقائق على موعد جرعتك''',
              fln: flutterLocalNotificationsPlugin);
        }
        //  else if(diff <= -1440){ // passed a day over the medication , it will be removed
        //   value.docs[i].reference.delete();
        // }
      } // end for
    });
    // timer?.cancel();
    // }
  }

  void sendNotificationchecked(String mediName) async {
    Noti.showBigTextNotification(
        title: "تم أخذ الجرعة",
        body: "${mediName} ",
        fln: flutterLocalNotificationsPlugin);
  }

  int _selectedIndex = 2;
  bodyFunction() {
    switch (_selectedIndex) {
      case 0:
        return;
        break;
      case 1:
        return PatientCalendar();
        break;
      case 2:
        return ViewD();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      if (caregiverID != null) {
        final action = await AlertDialogs.yesCancelDialog(
            context, 'تسجيل الخروج', 'هل أنت متأكد من رغبتك في تسجيل الخروج؟');
        if (action == DialogsAction.yes) {
          timer?.cancel();
          setState(() => timer?.cancel());

          await FirebaseAuth.instance.signOut();
           timer?.cancel();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => patientScreen()));
               timer?.cancel();
        } else {
          setState(() => tappedYes = false);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigationPatient()));
        }
      } else {
        final action = await AlertDialogs.yesCancelDialog(
            context, 'تسجيل الخروج', 'هل أنت متأكد من رغبتك في تسجيل الخروج؟');
        if (action == DialogsAction.yes) {
          timer?.cancel();
          setState(() => tappedYes = true);

          // await FirebaseAuth.instance.signOut();

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => patientScreen()));
        } else {
          setState(() => tappedYes = false);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigationPatient()));
        }
      }
    }

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 0) {
        logout();
      }
    }

    return Scaffold(
      body: bodyFunction(),
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Color.fromARGB(255, 140, 167, 190),
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.logout,
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
