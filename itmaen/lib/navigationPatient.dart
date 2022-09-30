import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:itmaen/patient-login.dart';
import 'package:itmaen/view.dart';
import 'alert_dialog.dart';
import 'calendar/PatienrCalendar.dart';
import 'calendar/patientCalendar2.dart';
import 'calendar/test22/newCalendar.dart';
import 'login.dart';

class NavigationPatient extends StatefulWidget {
  const NavigationPatient({Key? key}) : super(key: key);

  @override
  State<NavigationPatient> createState() => _NavigationPatientState();
}

class _NavigationPatientState extends State<NavigationPatient> {
  String title = 'AlertDialog';
  bool tappedYes = false;
  final _auth = FirebaseAuth.instance;
  String caregiverID = "";
  late User loggedInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    //String qrData="";
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }

  int _selectedIndex = 1;
  bodyFunction() {
    switch (_selectedIndex) {
      case 0:
        return;
        break;
      case 1:
        return PatientCalendar();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      if (caregiverID != null) {
        final action = await AlertDialogs.yesCancelDialog(
            context, 'تسجيل الخروج', 'هل أنت متأكد من رغبتك في تسجيل الخروج؟');
        if (action == DialogsAction.yes) {
          setState(() => tappedYes = true);

          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          setState(() => tappedYes = false);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigationPatient()));
        }
      } else {
        final action = await AlertDialogs.yesCancelDialog(
            context, 'تسجيل الخروج', 'هل أنت متأكد من رغبتك في تسجيل الخروج؟');
        if (action == DialogsAction.yes) {
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
