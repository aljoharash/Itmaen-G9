import 'package:flutter/material.dart';
import 'package:itmaen/controller/addMedicineController.dart';
import 'package:itmaen/Widget/Card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:itmaen/pages/adddialog.dart';

import 'addmedicine.dart';

class addManually extends StatefulWidget {
  const addManually({Key? key}) : super(key: key);

  @override
  State<addManually> createState() => _addManuallyState();
}

class _addManuallyState extends State<addManually> {
  @override
  final _formKey = GlobalKey<FormState>();
  TextEditingController medName = new TextEditingController();
  TextEditingController doseCount = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController packSize = new TextEditingController();
  String errorMessage = '';
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*SafeArea(
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: 500.0,
                          child: Text('sss'),
                        ),
                      ),
                    ),*/
                    SizedBox(
                      height: 180.0,
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "إضافة دواء",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 50,
                              color: Colors.blueGrey,
                              fontFamily: 'Madani Arabic Black'),
                        ),
                      ),
                    ),
                    /*SizedBox(
                      height: 50.0,
                    ),*/
                    TextFormField(
                      controller: medName,
                      validator: ValidateMedName,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: 'اسم الدواء ',
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 12.0, bottom: 8.0, top: 8.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 236, 231, 231),
                                width: 3)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color.fromARGB(79, 255, 255, 255)),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: description,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: ' وصف الدواء (اختياري) ',
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 12.0, bottom: 8.0, top: 8.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 236, 231, 231),
                                width: 3)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color.fromARGB(79, 255, 255, 255)),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(errorMessage),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: doseCount,
                      validator: ValidateDose,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: 'الجرعة',
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 12.0, bottom: 8.0, top: 8.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 236, 231, 231),
                                width: 3)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color.fromARGB(79, 255, 255, 255)),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: packSize,
                      validator: ValidatePack,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: 'حجم العبوة',
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 12.0, bottom: 8.0, top: 8.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 236, 231, 231),
                                width: 3)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color.fromARGB(79, 255, 255, 255)),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    ElevatedButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          backgroundColor: Colors.blueGrey),
                      onPressed: () async {
                        // add to database
                      },
                      child: Text(
                        'إضافة',
                        style: TextStyle(fontFamily: 'Madani Arabic Black'),
                      ),
                    ),

                  ]),
            ),
          )));
}


String? ValidatePack(String? formPack) {
  if (formPack == null || formPack.isEmpty)
    return ' الرجاء ادخال حجم العبوة';

}

String? ValidateMedName(String? FormName) {
  if (FormName == null || FormName.isEmpty) return 'الرجاء ادخال اسم الدواء';
  String pattern =
      r'^(?=.{2,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(FormName.trim()))
    return 'يجب أن يحتوي اسم الدواء على حرفين على الاقل';
  return null;
}

String? ValidateDose(String? FormDose) {
  if (FormDose == null || FormDose.isEmpty)
    return 'الرجاء ادخال الجرعة ';
}