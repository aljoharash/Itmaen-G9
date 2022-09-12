import 'package:flutter/material.dart';
import 'package:itmaen/controller/addMedicineController.dart';
import 'package:itmaen/Widget/Card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:itmaen/pages/adddialog.dart';

import 'addmedicine.dart';

class addByScan extends StatelessWidget {
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(FontAwesomeIcons.barcode),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          'الباركود: ' +
                                              _.scannedMedicine[0].barcode.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0XFF666666)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    BuildCard(
                                      info: 'اسم الدواء: ',
                                      icon: FontAwesomeIcons.medkit,
                                      item: _.scannedMedicine[0].tradeName.toString(),
                                    ),
                                    Divider(),
                                    BuildCard(
                                      info: 'وصف الدواء ',
                                      icon: FontAwesomeIcons.list,
                                      item: _.scannedMedicine[0].description.toString(),
                                    ),
                                    Divider(),
                                    BuildCard(
                                      info: 'الجرعة: ',
                                      icon: FontAwesomeIcons.diagnoses,
                                      item: _.scannedMedicine[0].strengthValue.toString(),
                                    ),
                                    Divider(),
                                    BuildCard(
                                      info: 'الاسم العلمي: ',
                                      icon: FontAwesomeIcons.stethoscope,
                                      item: _.scannedMedicine[0].genericName.toString(),
                                    ),
                                    Divider(),
                                    BuildCard(
                                      info: 'حجم العلبة: ',
                                      icon: FontAwesomeIcons.pills,
                                      item: _.scannedMedicine[0].packageSize.toString(),
                                    ),
                                    Divider(),
                                    BuildCard(
                                      info: 'الحجم ',
                                      icon: FontAwesomeIcons.moneyBillAlt,
                                      item:
                                          _.scannedMedicine[0].volume.toString(),
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
                        height: 70.0,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30.0),
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
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70.0,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30.0),
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
                                  "إلغاء",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
															QrCode()));}),
                            
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