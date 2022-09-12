import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itmaen/add-patient.dart';
import 'package:itmaen/model/medicines.dart';
import 'generateqr.dart';
import 'login.dart';
import 'scanqr.dart';
import 'pages/addmedicine.dart';
import 'package:itmaen/secure-storage.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StorageService st = StorageService();
  var caregiverID;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  static var id_;
  late String id = '';

  _HomePageState() {
    id_ = id;
  }
  Future<String?> getCurrentUserStorage() async {
    final String = await (st.readSecureData('caregiverID').then((value) {
      setState(() {
        id = value.toString();
      });
    }));
    return id;
  }

  @override
  void initState() {
    super.initState();
    id = (getCurrentUserStorage()).toString();
  }
  //getUserid().then((String userID) {...})
  //getCurrentUserStorage();

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser.uid;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void medcineStream() async {
    final user = await _auth.currentUser;
    if (user != null) {
      final medicines = FirebaseFirestore.instance
          .collection('medicines')
          .where('caregiverID', isEqualTo: caregiverID);
      await for (var snapchot in medicines.snapshots()) {
        for (var medicine in snapchot.docs) {
          print(medicine.data());
        }
      }
    } else {
      final medicines = FirebaseFirestore.instance
          .collection('medicines')
          .where('caregiverID', isEqualTo: id_);
      await for (var snapchot in medicines.snapshots()) {
        for (var medicine in snapchot.docs) {
          print(medicine.data());
        }
      }
    }
  }

  void check() {
    StorageService st = StorageService();
    st.writeSecureData('caregiverID', caregiverID);
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'مرحبا بك في اطمئن',
      style: optionStyle,
    ),
    Text(
      'Index 1: Add Patient',
      style: optionStyle,
    ),
    Text(
      'Index 2: Add Medicine',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    } else if (index == 1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AddPatient()));
    } else if (index == 2) {
      //print('test is:');
      check();
      getCurrentUser();
      getCurrentUserStorage();
      medcineStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إطمئن'),
        //  actions:
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('medicines')
                  .where('caregiverID', isEqualTo: caregiverID)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                } else {
                  final medicines = snapshot.data?.docs;
                  List<Text> medWidgets = [];
                  for (var med in medicines!) {
                    final medName = med.get('Trade name');
                    final medWidget = Text('$medName ');
                    medWidgets.add(medWidget);
                  }

                  return Column(
                    children: medWidgets,
                  );
                }
              })
        ],
      )

          /*TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              print('test is:');
              check();
              getCurrentUser();
              getCurrentUserStorage();
              medcineStream();
            },
            child: const Text('print'),
          ),*/

          ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'إضافة مريض',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_rounded),
            label: 'إضافة دواء',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
