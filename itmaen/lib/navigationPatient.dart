import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:itmaen/addMedicinePages/adddialog.dart';
import 'package:itmaen/view.dart';
import 'add-patient.dart';
import 'home.dart';

class NavigationPatient extends StatefulWidget {
  const NavigationPatient({Key? key}) : super(key: key);

  @override
  State<NavigationPatient> createState() => _NavigationPatientState();
}

class _NavigationPatientState extends State<NavigationPatient> {
  int _selectedIndex = 0;
  bodyFunction() {
    switch (_selectedIndex) {
      case 0:
        return View();
        break;
      case 1:
        return View();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {


    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 0) {
        //logout
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
