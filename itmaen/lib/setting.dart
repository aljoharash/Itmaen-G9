import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/editprofile.dart';
import 'package:itmaen/patient-login.dart';
import 'alert_dialog.dart';
import 'login.dart';
import 'navigation.dart';
import 'navigationPatient.dart';
import 'dart:ui' as ui;

class NavBar extends StatefulWidget {
  static const String id = 'SignUpScreen';

  @override
  _NavBar createState() => _NavBar();
}

//userSetup
class _NavBar extends State<NavBar> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String caregiverID = "";
  late User loggedInUser;
  String caregiverID2 = '';
  static String nameO = "";
  static String emailO = "";
  static String PassO = "";
  static String MobileO = "";
  Timer? timer;
  bool tappedYes = false;

  @override
  void initState() {
    //getCurrentUser();
    // Noti.initialize(flutterLocalNotificationsPlugin);

    timer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
      // sendNotification();
    });
  }

  Future retrieve2() async {
    final user = await _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      caregiverID2 = loggedInUser.uid;
      var collection = FirebaseFirestore.instance.collection('caregivers');
      var docSnapshot = await collection.doc(caregiverID2).get();
      if (!docSnapshot.exists) {
        print("ops");
      } else if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        // You can then retrieve the value from the Map like this:
        nameO = data['user name'];
        emailO = data['email'];
        PassO = data['password'];
        MobileO = data['mobileNum'];
        print(nameO);
      }
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

          timer?.cancel(); //
          await FirebaseAuth.instance.signOut();
          timer?.cancel();
          //loggedInUser = null;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
          timer?.cancel();
        } else {
          setState(() => tappedYes = false);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Navigation()));
        }
      } else {
        final action = await AlertDialogs.yesCancelDialog(
            context, 'تسجيل الخروج', 'هل أنت متأكد من رغبتك في تسجيل الخروج؟');
        if (action == DialogsAction.yes) {
          timer?.cancel(); // stop the timer
          setState(() => timer!.cancel());
          timer?.cancel();

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

    Future<void> _onItemTapped(int index) async {
      setState(() {
        // _selectedIndex = index;
      });
      if (index == 0) {
        logout();
      }
    }

    retrieve2();
    return Drawer(
      // child: Directionality(
      //textDirection: ui.TextDirection.rtl,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,

        children: [
          UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text(""),
            /*      currentAccountPicture: CircleAvatar(
                child: ClipOval(
                   child: Icon(
                  Icons.person,
                  size: 50,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                  ),
                ),*/
            decoration: BoxDecoration(
                // color: Color.fromARGB(255, 57, 110, 151),
                image: DecorationImage(
                    image: AssetImage('images/logoSide.JPG'),
                    fit: BoxFit.fitWidth)),
          ),
          ListTile(
            leading: Icon(Icons.person, textDirection: TextDirection.rtl),
            title: Text('حسابي', style: GoogleFonts.tajawal()),
            onTap: () => loggedInUser != null
                ? {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => editProfile(
                            name: nameO,
                            email: emailO,
                            pass: PassO,
                            mobile: MobileO)))
                  }
                : Text(""),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('تسجيل الخروج', style: GoogleFonts.tajawal()),
            onTap: () => logout(),
          ),
          /* ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Request'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Policies'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () => null,
          ),*/
        ],
      ),
    );
  }
}
