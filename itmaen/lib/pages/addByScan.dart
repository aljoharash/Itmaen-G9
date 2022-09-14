import 'package:flutter/material.dart';
import 'package:itmaen/controller/addMedicineController.dart';
import 'package:itmaen/Widget/Card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:itmaen/pages/adddialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'addmedicine.dart';

class addByScan extends StatelessWidget {
  String? genericName;
  String? tradeName;
  String? strengthValue;
  String? unitOfStrength;
  String? volume;
  String? unitOfVolume;
  String? packageSize;
  String? barcode;
  String? description;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  // String caregiverID = "";
  // late User loggedInUser;

  // @override
  // void initState() {
  //   getCurrentUser();
  // }

  // void getCurrentUser() async {
  //   try {
  //     final user = await _auth.currentUser;
  //     if (user != null) {
  //       loggedInUser = user;
  //       caregiverID = loggedInUser.uid;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: GetBuilder<addMedicineController>(
              init: addMedicineController(),
              builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: _.scannedMedicine.isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  child: _.notFound
                                      ? Text(
                                          'لم يتم العثور على الدواء',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          'اقرأ الباركود',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ))
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    BuildCard(
                                      info: 'اسم الدواء',
                                      icon: FontAwesomeIcons.medkit,
                                      item: tradeName = _
                                          .scannedMedicine[0].tradeName
                                          .toString(),
                                    ),
                                    Divider(),
                                    BuildCard(
                                      info: 'وصف الدواء ',
                                      icon: FontAwesomeIcons.list,
                                      item: description = _
                                          .scannedMedicine[0].description
                                          .toString(),
                                    ),
                                    Divider(),
                                    BuildCard(
                                      info: 'الجرعة ',
                                      icon: FontAwesomeIcons.diagnoses,
                                      item: strengthValue = _
                                          .scannedMedicine[0].strengthValue
                                          .toString(),
                                    ),
                                    Divider(),
                                    BuildCard(
                                      info: 'الاسم العلمي ',
                                      icon: FontAwesomeIcons.stethoscope,
                                      item: genericName = _
                                          .scannedMedicine[0].genericName
                                          .toString(),
                                    ),
                                    Divider(),
                                    BuildCard(
                                      info: 'عدد الحبات',
                                      icon: FontAwesomeIcons.pills,
                                      item: packageSize = _
                                          .scannedMedicine[0].packageSize
                                          .toString(),
                                    ),
                                    Divider(),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60.0,
                        width: 200,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 140, 167, 190),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                    child: Icon(
                                  FontAwesomeIcons.barcode,
                                  size: 16,
                                  color: Colors.white,
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "الماسح الضوئي",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () => _.scanBarcode()),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 60.0,
                        width: 200,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 76, 146, 15),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                    child: Icon(
                                  FontAwesomeIcons.plus,
                                  size: 16,
                                  color: Colors.white,
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "إضافة",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              _firestore.collection('medicines').add({
                                'Generic name': genericName,
                                'Trade name': tradeName,
                                'Strength value': strengthValue,
                                'Unit of strength': unitOfStrength,
                                'Volume': volume,
                                'Unit of volume': unitOfVolume,
                                'Package size': packageSize,
                                'barcode': barcode,
                                'description': description,
                                //'caregiverID': caregiverID,
                              });
                              _.scannedMedicine.clear();

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QrCode()));
                            }),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 60.0,
                        width: 200,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 187, 18, 6),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                    child: Icon(
                                  FontAwesomeIcons.ban,
                                  size: 16,
                                  color: Colors.white,
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "إلغاء",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              _.scannedMedicine.clear();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => QrCode()));
                            }),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
