import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:itmaen/addMedicinePages/adddialog.dart';
import 'package:itmaen/generateqr.dart';
import 'package:itmaen/patient-login.dart';
import 'package:itmaen/view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'add-patient.dart';
import 'alert_dialog.dart';
import 'home.dart';
import 'login.dart';
import 'package:itmaen/calendar/calendarView.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
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

  Future<bool> _isCollectionExits() async {
    QuerySnapshot<Map<String, dynamic>> _query = await FirebaseFirestore
        .instance
        .collection('patients')
        .where("caregiverID", isEqualTo: caregiverID)
        .get();

    if (_query.docs.isNotEmpty) {
      // Collection exits
      return true;
    } else {
      // Collection not exits
      return false;
    }
  }

  int _selectedIndex = 3;
  bodyFunction() {
    switch (_selectedIndex) {
      case 0:
        return;
        break;
      case 1:
        return AddPatient();
        break;
      case 2:
        return View();
        break;
      case 3:
        return CalendarEvents();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    void showAddDialog() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: AddMedicine(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      );
    }

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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Navigation()));
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
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Navigation()));
        }
      }
    }

    Future<void> _onItemTapped(int index) async {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 2) {
        showAddDialog();
      }
      if (index == 0) {
        logout();
      }
      if (index == 1) {
        if (await _isCollectionExits() == true) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => GenerateQR()));
        }
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
            Icons.person_add,
            color: Colors.white,
          ),
          Icon(
            Icons.add,
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
