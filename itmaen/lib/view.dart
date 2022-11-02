import 'dart:core';
import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/add-patient.dart';
import 'package:itmaen/editDose.dart';
import 'package:itmaen/patient-login.dart';
import 'package:itmaen/setting.dart';
import 'package:itmaen/trySet.dart';
import 'package:itmaen/viewD.dart';
import 'addMedicinePages/adddialog.dart';
import 'alert_dialog.dart';
import 'package:itmaen/model/medicines.dart';
import 'editMedicine.dart';
import 'generateqr.dart';
import 'login.dart';
import 'scanqr.dart';
import 'addMedicinePages/addmedicine.dart';
//import 'pages/adddialog.dart';
import 'package:itmaen/secure-storage.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';

class View extends StatefulWidget {
  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<View> {
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

  bool isLoading = true;
  List<MedicinesModel> medicineList = [];
  List<MedicinesModel> medicineSearchList = [];
  // FirebaseFirestore.instance
  //                               .collection('medicines')
  //                               .where('caregiverID', isEqualTo: cid_)
  //                               .snapshots()

  //getCurrentUser();

  _ViewPageState() {
    View();
    //assignboolean();
  }
  //}

  @override
  void initState() {
    super.initState();
    //HomePage();

    getCurrentUser().then((value) {
      t = value;
      _getMediciens(cid_);
    });
  }

  void _getMediciens(var cavID) async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('medicines');

    collectionReference
        .where('caregiverID', isEqualTo: cid_)
        .get()
        .then((value) {
      List<QueryDocumentSnapshot> medicines = value.docs;
      medicineList.clear();
      medicineSearchList.clear();
      for (int i = 0; i < medicines.length; i++) {
        var medicineInfo = medicines[i].data() as Map<String, dynamic>;
        var med = MedicinesModel.fromJson(medicineInfo);
        med.medID = medicines[i].id;
        medicineList.add(med);
        medicineSearchList.add(med);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  search(String input) async {
    if (input.isNotEmpty) {
      await searchMedicines(input).then((value) {
        setState(() {
          medicineList = value;
        });
      });
    } else {
      _getMediciens(cid_);
    }
  }

  Future<List<MedicinesModel>> searchMedicines(String input) async {
    return medicineSearchList.where((element) {
      if (element.medicName!.toLowerCase().contains(input.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  Future<bool> getstatu() async {
    bool val = await getCurrentUser();
    bool val2 = val;
    return val2;
  }

  Future<bool> getCurrentUser() async {
    //HomePage();
    final user = await _auth.currentUser;
    // st.writeSecureData("caregiverID", "vEvVOOqyORTSyfork3f3rZWnqKb2");
    //print(user!.uid);
    var isAvailable = user?.uid;
    if (isAvailable == null) {
      t = true;
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

    var data;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SafeArea(
        top: false,
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
            drawer: NavBar(),
            appBar: AppBar(
              // automaticallyImplyLeading: false,
              backgroundColor: Color.fromARGB(255, 140, 167, 190),
              title: Text("قائمة الأدوية",
                  style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
            ),
            floatingActionButton: ElevatedButton(
              onPressed: () {
                showAddDialog();
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(15),
                //backgroundColor: Color.fromARGB(255, 140, 167, 190),
                primary: Color.fromARGB(255, 140, 167, 190),
                surfaceTintColor: Color.fromARGB(255, 84, 106, 125),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.maxFinite,
                  height: 60,
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "اسم الدواء",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide( width:3 , color:Color.fromARGB(255, 140, 167, 190)),
                          //   borderRadius: BorderRadius.circular(50)
                          // ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromARGB(255, 140, 167, 190)),
                          ),
                          icon: Icon(
                            Icons.search,
                            size: 30,
                            color: Color.fromARGB(255, 140, 167, 190),
                          ),
                          contentPadding: EdgeInsets.only(right: 3)),
                      onChanged: (value) async {
                        search(value);
                        // CustomersController.search(value.trim());
                      },
                    ),
                  ),
                ),
                Expanded(
                  // height: 170,
                  child: isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        )
                      : Scrollbar(
                          child: ListView.builder(
                            // scrollDirection: Axis.vertical,
                            // shrinkWrap: true,
                            itemCount: medicineList.length,
                            itemBuilder: (context, index) {
                              return medBubble(
                                  medicineList[index].medicName,
                                  medicineList[index].meddescription,
                                  medicineList[index].package,
                                  medicineList[index].remaining,
                                  medicineList[index].picture,
                                  medicineList[index].photo,
                                  medicineList[index].strength,
                                  _getMediciens,
                                  cid_,
                                  medicineList[index].medID);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class medBubble extends StatelessWidget {
  medBubble(
      this.medicName,
      this.meddescription,
      this.package,
      this.remaining,
      this.picture,
      this.photo,
      this.strength,
      this.refreshList,
      this.cid,
      this.medID);
  Function refreshList;
  var medicName;
  var meddescription;
  var package;
  var remaining;
  var picture;
  var photo;
  var cid;
  var medID;

  late List<String> toBeTransformed = [];
  var strength;

  // **** editing purposes *****

  var editAmount;
  var editDescription;
  var editDays;
  var editFreq;
  var editHoursBetween;
  var selectedNote;
  var selectedUnit;
  var editColor;
  var editTime;
  var editDate;

  //**** editing purposes *****

  @override
  Widget build(BuildContext context) {
    retrieveInfo(medicName);

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Material(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 7,
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Row(
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: 
                          photo == " "?
                          Image.asset(picture.toString(),
                              height: 65, width: 65) : 
                            Container(
                              height: 65,
                              width: 65,
                              child:
                                Image.network(photo),
                              
                            ),

                        ),
                        Text(
                          ' $medicName ',
                          style: GoogleFonts.tajawal(
                              fontSize: 18,
                              color: Color.fromARGB(255, 55, 89, 122),
                              fontWeight: FontWeight.w600),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            '  حجم العبوة $package  ',
                            style: GoogleFonts.tajawal(
                                fontSize: 13,
                                color: Color.fromARGB(255, 109, 140, 147),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        // here image
                        //SizedBox(width: 80,),
                        // Directionality(textDirection: TextDirection.rtl,
                        //                 child: Image.asset('assets/Images/itmaenlogo.png',
                        //                   height: 65, width: 65),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      ' $meddescription ',
                      style: GoogleFonts.tajawal(
                          fontSize: 13,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Container(
                        // ******

                        child: FutureBuilder(
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If we got an error
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    '${snapshot.error} occurred',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );

                                // if we got our data
                              } else if (snapshot.hasData) {
                                // Extracting data from snapshot object
                                final data = snapshot.data as bool;
                                return Container(
                                    width: 235,
                                    child: data == true
                                        ? (MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),

                                            padding: EdgeInsets.fromLTRB(
                                                47, 10, 60, 10),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          editDose(
                                                            value:
                                                                toBeTransformed,
                                                            toBeTransformed: [
                                                              medicName,
                                                              editDescription,
                                                              editAmount,
                                                              selectedUnit,
                                                              editColor,
                                                              editDays,
                                                              editFreq,
                                                              editHoursBetween,
                                                              selectedNote,
                                                              editTime
                                                                  .toString(),
                                                              editDate,
                                                              package,
                                                              remaining
                                                            ],
                                                          )));
                                            },

                                            color: Color.fromARGB(
                                                255, 248, 149, 121),
                                            //    Color.fromARGB(255, 216, 94, 13),

                                            child: Row(
                                              children: [
                                                Text(
                                                  "تعديل جرعة الدواء",
                                                  style: GoogleFonts.tajawal(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                          ))
                                        : (MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.fromLTRB(
                                                47, 10, 60, 10),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => SetDose(
                                                  value: toBeTransformed,
                                                  toBeTransformed: [
                                                    medicName,
                                                    package,
                                                    remaining,
                                                    strength
                                                  ],
                                                ),
                                              ));
                                            },
                                            color: Color.fromARGB(
                                                255, 140, 167, 190),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "تحديد جرعة الدواء",
                                                  style: GoogleFonts.tajawal(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                          )));
                              }
                            }

                            // Displaying LoadingSpinner to indicate waiting state
                            return SizedBox();
                          },

                          // Future that needs to be resolved
                          // inorder to display something on the Canvas
                          future: checkHasValue(medicName),
                        ),

                        //*******
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditMed(
                                        name: medicName,
                                        description: meddescription,
                                        package: package,
                                        remaining: remaining,
                                        strength: strength,
                                        medID: medID,
                                      )));
                            },
                            child: Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 111, 161, 200),
                              size: 25,
                            ),
                          )),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                          padding: EdgeInsets.fromLTRB(12, 10, 0, 10),
                          alignment: Alignment.bottomLeft,
                          child: GestureDetector(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "لا",
                                                style: GoogleFonts.tajawal(),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                var collectionDoses =
                                                    FirebaseFirestore.instance
                                                        .collection('doses');
                                                var snapshotDoses =
                                                    await collectionDoses
                                                        .where("name",
                                                            isEqualTo:
                                                                medicName)
                                                        .where("caregiverID",
                                                            isEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .get();
                                                for (var doc
                                                    in snapshotDoses.docs) {
                                                  Timestamp doseTime =
                                                      doc.get("Time");
                                                  print(doseTime);

                                                  if (doseTime.compareTo(
                                                          Timestamp.now()) >
                                                      0) {
                                                    await doc.reference
                                                        .delete();
                                                  }
                                                }

                                                ;

                                                var collectionDoseEdit =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'dosesEdit');
                                                var snapshotoseEdit =
                                                    await collectionDoseEdit
                                                        .where("name",
                                                            isEqualTo:
                                                                medicName)
                                                        .where("caregiverID",
                                                            isEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .get();
                                                for (var doc
                                                    in snapshotoseEdit.docs) {
                                                  await doc.reference.delete();
                                                }
                                                ;

                                                var collectionMed =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'medicines');
                                                var snapshotMed =
                                                    await collectionMed
                                                        .where(
                                                            "Trade name",
                                                            isEqualTo:
                                                                medicName)
                                                        .where("caregiverID",
                                                            isEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .get();
                                                for (var doc
                                                    in snapshotMed.docs) {
                                                  await doc.reference.delete();
                                                }
                                                refreshList(cid);
                                                // refreshList;
                                              },
                                              child: Text(
                                                "نعم",
                                                style: GoogleFonts.tajawal(),
                                              ),
                                            ),
                                          ],
                                          content: Text(
                                            "هل أنت متأكد من رغبتك في حذف الدواء وما يتبعه من جرعات؟",
                                            style: GoogleFonts.tajawal(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.right,
                                          )));
                            },
                            child: Icon(
                              Icons.delete,
                              color: ui.Color.fromARGB(255, 247, 76, 81),
                              size: 25,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ))),
    );
  }

  Future<bool> checkHasValue(String name) async {
    bool hasV = false;

    await FirebaseFirestore.instance
        .collection('dosesEdit')
        .where("name", isEqualTo: name)
        .get()
        .then((value) {
      hasV = value.docs.isNotEmpty;
      // hasV = value.docs[0].exists;
    });

    return hasV;
  }

  void retrieveInfo(String name) => FirebaseFirestore.instance
          .collection('dosesEdit')
          .where("name", isEqualTo: name)
          .get()
          .then((value) {
        //hasValue = value.docs[0].exists;
        if (value.docs.length > 0) {
          editDescription = (value.docs[0].get('description'));
          editAmount = (value.docs[0].get('amount'));
          editDays = (value.docs[0].get('days'));
          editFreq = (value.docs[0].get('freqPerDay'));
          editHoursBetween = (value.docs[0].get('hoursBetweenDoses'));
          selectedNote = (value.docs[0].get('selectedDescription'));
          selectedUnit = (value.docs[0].get('unit'));
          editColor = (value.docs[0].get('color')).toString();
          editTime = (value.docs[0].get('firstTime'));
          editDate = (value.docs[0].get('Date'));
        }
      });
}

class MedicinesModel {
  var medicName,
      meddescription,
      package,
      remaining,
      picture,
      photo,
      strength,
      medID;
  MedicinesModel(
      {this.medicName,
      this.meddescription,
      this.package,
      this.remaining,
      this.picture,
      this.photo,
      this.strength,
      this.medID});
  MedicinesModel.fromJson(Map<String, dynamic> map) {
    if (map == null) {
      return;
    }

    medicName = map['Trade name'];
    meddescription = map['description'];
    package = map['Package size'];
    remaining = map['Remaining Package'];
    picture = map['picture'];
    photo = map['photo'];
    strength = map['Unit of volume'];
  }
}
