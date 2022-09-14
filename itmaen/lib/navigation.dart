import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:itmaen/addMedicinePages/adddialog.dart';
import 'package:itmaen/view.dart';
import 'add-patient.dart';
import 'home.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  bodyFunction() {
    switch (_selectedIndex) {
      case 0:
        return AddPatient();
        break;
      case 1:
        return AddPatient();
        break;
      case 2:
        return View();
        break;
      case 3:
        return View();
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

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 2) {
        showAddDialog();
      }
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
