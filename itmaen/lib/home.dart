import 'dart:core';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itmaen/add-patient.dart';
import 'package:itmaen/patient-login.dart';
import 'alert_dialog.dart';
import 'package:itmaen/model/medicines.dart';
import 'generateqr.dart';
import 'login.dart';
import 'scanqr.dart';
import 'pages/addmedicine.dart';
import 'pages/adddialog.dart';
import 'package:itmaen/secure-storage.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'AlertDialog';
  bool tappedYes = false;
  StorageService st = StorageService();
  //var caregiverID;
  final _auth = FirebaseAuth.instance;
  late User loggedUser;

  //Future<String?> loggedInUser = getCurrentUser();

  late String id = '';
  static var id_ = '';
  //var Cid;
  static String cid_ = '';
  var caregiverID;

  static var t;

  //getCurrentUser();

  _HomePageState() {
    getstatu();
    HomePage();
    // Test();

    // Future<String?> loggedInUser = getCurrentUser().then((value) => cid=value);
    // print("$cid heerreee");
    // //Cid = getCurrentUser();
    // if(cid!=null){
    //   print("not null");
    //   // id_ = loggedInUser.toString();
    //   Test();
    //  // medcineStream();
    // }
    // else{
    // id_= getCurrentUserStorage().toString();
    // print("is null");
    //medcineStream();}
    //id_ = id;

    getCurrentUser().then((value) => t = value);
    //assignboolean();
  }
  //}

  // Future<String?> getCurrentUserStorage() async {
  //   final String = await (st.readSecureData('caregiverID').then((value) {
  //     setState(() {
  //       id = value.toString();
  //     });
  //   }));
  //  // return id.toString();
  //  return Future.value(id.toString()) ;
  // }

  @override
  void initState() {
    super.initState();
    HomePage();
    getCurrentUser().then((value) => t = value);
    //Test();
    // getCurrentUser();
    // id = (getCurrentUserStorage()).toString();
  }

  Future<bool> getstatu() async {
    bool val = await getCurrentUser();
    bool val2 = val;
    return val2;
  }

// void assignboolean() async{
//   t = await getCurrentUser();
// }

  /*void getCurrentUser() async {
    //String qrData=""
StorageService st = StorageService();
  var caregiverID;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;*/

  // @override
  // void initState() {
  //   super.initState();
  //   //id = (getCurrentUserStorage()).toString();
  //   Test();
  // }
  //getUserid().then((String userID) {...})
  //getCurrentUserStorage();

  Future<bool> getCurrentUser() async {
    final user = await _auth.currentUser;
    //st.writeSecureData("caregiverID", "3Tflquyaa4ghz5bjOF0kxqHfP5f1");
    //print(user!.uid);
    var isAvailable = user?.uid;
    if (isAvailable == null) {
      //t=true;
      id_ = (await st.readSecureData("caregiverID"))!;
      print("$id_ here 1");
      t = true;
      return Future<bool>.value(true);
    } else {
      t = false;
      cid_ = user!.uid.toString();
      print("$cid_ here 2");
      t = false;
      return Future<bool>.value(false);
    }

    // try {
    //    user = await _auth.currentUser;
    //   if (user != null) {
    //     loggedInUser = user;
    //     caregiverID= loggedInUser.uid;
    //     // print(loggedInUser.email);
    //   }

    // } catch (e) {
    //   print(e);
    // }
    //return user?.uid;
    //  return Future.value(user?.uid);
    //    //return user ;
    // }
    ///////////////////////////////

    // void Test() async {
    //   try {
    //     final user = await _auth.currentUser;
    //     if (user != null) {
    //      // loggedUser = user;
    //      // id_= loggedUser.uid;
    //      id_ = cid.toString();
    //       // print(loggedInUser.email);
    //     }
    //   } catch (e) {
    //     print(e);
    //   }
    // }

    // void medcineStream() async {
    //   final user = await _auth.currentUser;
    //   if (user != null) {
    //     final medicines = FirebaseFirestore.instance
    //         .collection('medicines')
    //         .where('caregiverID', isEqualTo: caregiverID);
    //     await for (var snapchot in medicines.snapshots()) {
    //       for (var medicine in snapchot.docs) {
    //         print(medicine.data());
    //       }
    //     }
    //   } else {
    //     final medicines = FirebaseFirestore.instance
    //         .collection('medicines')
    //         .where('caregiverID', isEqualTo: id_);
    //     await for (var snapchot in medicines.snapshots()) {
    //       for (var medicine in snapchot.docs) {
    //         print(medicine.data());
    //       }
    //     }
    //   }
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
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AddMedicine()));
      //print('test is:');

    }
  }

  @override
  Widget build(BuildContext context) {
// Future<bool> getrealvalue() async {
// bool val = await getstatu();
// return val;
// }

//void x(){
    // String = await (st.readSecureData('caregiverID').then((value) {
    //     setState(() {
    //       id = value.toString();
    //     });
    //bool t ;
    // getCurrentUser().then((value) => t = value);
    //  Future<bool> t = getCurrentUser();
    //  print(t==Future<bool>.value(true) );
    //  print("lets see");
    // print(t);
    // bool t ;

    // print(t);
    // bool t = false ;
    getCurrentUser().then((value) => t = value);
    print(t);
    print("lets seee");
    if (t == true) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 140, 167, 190),
              title: const Text('قائمة الادوية'),
              actions: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton(
                      child: Text(
                        'تسجيل الخروج',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      onPressed: () async {
                        if (caregiverID != null) {
                          final action = await AlertDialogs.yesCancelDialog(
                              context,
                              'تسجيل الخروج',
                              'هل متأكد من عملية تسجيل الخروج؟');
                          if (action == DialogsAction.yes) {
                            setState(() => tappedYes = true);

                            await FirebaseAuth.instance.currentUser!.delete();
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          } else {
                            setState(() => tappedYes = false);
                          }
                        } else {
                          final action = await AlertDialogs.yesCancelDialog(
                              context,
                              'تسجيل الخروج',
                              'هل متأكد من عملية تسجيل الخروج؟');
                          if (action == DialogsAction.yes) {
                            setState(() => tappedYes = true);
                            //await FirebaseAuth.instance.currentUser!.delete();
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => patientScreen()));
                          } else {
                            setState(() => tappedYes = false);
                          }
                        }
                      }),
                ),
              ],
            ),
            body: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('medicines')
                        .where('caregiverID', isEqualTo: id_)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Loading...");
                      } //else {
                      final medicines = snapshot.data?.docs;
                      List<medBubble> medBubbles = [];
                      for (var med in medicines!) {
                        //final medName = med.data();
                        final medName = med.get('Trade name');
                        final MedBubble = medBubble(medName);
                        medBubbles.add(MedBubble);
                      }
                      return Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          children: medBubbles,
                        ),
                      );
                      // }
                    })
              ],
            )),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'إضافة مستقبل رعاية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_hospital_rounded),
                  label: 'إضافة دواء',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color.fromARGB(255, 140, 167, 190),
              onTap: _onItemTapped,
            ),
          ));
    } else {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 140, 167, 190),
              title: const Text('قائمة الادوية'),
              actions: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextButton(
                      child: Text(
                        'تسجيل الخروج',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      onPressed: () async {
                        if (caregiverID != null) {
                          final action = await AlertDialogs.yesCancelDialog(
                              context,
                              'تسجيل الخروج',
                              'هل متأكد من عملية تسجيل الخروج؟');
                          if (action == DialogsAction.yes) {
                            setState(() => tappedYes = true);

                            await FirebaseAuth.instance.currentUser!.delete();
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          } else {
                            setState(() => tappedYes = false);
                          }
                        } else {
                          final action = await AlertDialogs.yesCancelDialog(
                              context,
                              'تسجيل الخروج',
                              'هل متأكد من عملية تسجيل الخروج؟');
                          if (action == DialogsAction.yes) {
                            setState(() => tappedYes = true);
                            //await FirebaseAuth.instance.currentUser!.delete();
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => patientScreen()));
                          } else {
                            setState(() => tappedYes = false);
                          }
                        }
                      }),
                ),
              ],
            ),
            body: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('medicines')
                        .where('caregiverID', isEqualTo: cid_)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Loading...");
                      } //else {
                      final medicines = snapshot.data?.docs;
                      List<medBubble> medBubbles = [];
                      for (var med in medicines!) {
                        //final medName = med.data();
                        final medName = med.get('Trade name');
                        final MedBubble = medBubble(medName);
                        medBubbles.add(MedBubble);
                      }
                      return Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          children: medBubbles,
                        ),
                      );
                      // }
                    })
              ],
            )),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'إضافة مستقبل رعاية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_hospital_rounded),
                  label: 'إضافة دواء',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Color.fromARGB(255, 140, 167, 190),
              onTap: _onItemTapped,
            ),
          ));
    }
  }
}

class medBubble extends StatelessWidget {
  medBubble(this.medicName);
  var medicName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Material(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 7,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              ' $medicName ',
              style:
                  TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          )),
    );
  }
}
