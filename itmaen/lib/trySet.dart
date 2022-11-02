// ignore_for_file: unnecessary_new

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/view.dart';
//import 'Notificationapi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itmaen/navigation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'dart:ui' as ui;

class SetDose extends StatefulWidget {
  List<String> toBeTransformed;
  SetDose(
      {Key? key, required this.toBeTransformed, required List<String> value})
      : super(key: key);

  @override
  State<SetDose> createState() => _SetDoseState(toBeTransformed);
}

class _SetDoseState extends State<SetDose> with SingleTickerProviderStateMixin {
  List<String> toBeTransformed;
  _SetDoseState(this.toBeTransformed);

  String caregiverID = "";
  late User loggedInUser;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
    var package;
    var remaining ;
  final nameController = TextEditingController();
  final unitController = TextEditingController();
  final hoursController = TextEditingController();
  final pillAmountController = TextEditingController();
  final TextEditingController description = new TextEditingController();
  DateTime setDate = DateTime.now();
  TimeOfDay setTime = TimeOfDay.now();
  var selectedTime = TimeOfDay.now();
  String _groupValue = 'في أي وقت';
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateFormat dateFormatDisplayed = DateFormat('dd/MM/yyyy');
  Color onClickDropDown = Colors.black45;
  double dropDownwidth = 2;
  double sliderValue = 1;
  double sliderValue2 = 3;
  TimeOfDay timeDisplayed = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  late SnackBar snackBar;
  String every_hours = '0';
  String everyH = "";
  get onChanged => null;
  String? selectType = "مل";
  List<String> list = ['مل', 'مجم', 'حبة'];
  Color backColor = Color.fromARGB(255, 225, 225, 225);
  Color pickerColor = Color.fromARGB(255, 140, 167, 190);
  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Center(
        child: Text(
          item,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
       package = toBeTransformed[1];
     remaining = toBeTransformed[2];


    print(TimeOfDay.now());

    //Notificationapi.init();
  }

  void getCurrentUser() async {
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

  @override
  Widget build(BuildContext context) {
    nameController.text = toBeTransformed[0];
    unitController.text = toBeTransformed[3];

    //  selectType = toBeTransformed[2];

    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 140, 167, 190),
        elevation: 0,
        title: Text(
          "تحديد جرعة الدواء",
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      ":اسم الدواء",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.tajawal(
                          color: Color.fromARGB(255, 122, 164, 186),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextField(
                      readOnly: true,
                      controller: nameController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: 'اسم الدواء',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 236, 231, 231),
                                width: 3)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color.fromARGB(79, 255, 255, 255)),
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        // border: OutlineInputBorder(
                        //     borderSide: BorderSide(
                        //         color: Color.fromARGB(79, 255, 255, 255), width: 3)),
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: new BorderSide(
                        //       color: Color.fromARGB(79, 255, 255, 255)),
                        //   borderRadius: new BorderRadius.circular(10),
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextField(
                      maxLength: 40,
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(40),
                      ],
                      controller: description,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 239, 237, 237),
                        hintText: 'وصف الجرعة (اختياري)',
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
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                     Expanded(
                          child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                        margin: EdgeInsets.only(left: 3),
                        // decoration: ShapeDecoration(
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(10)),
                        //         side: BorderSide(
                        //             width: dropDownwidth,
                        //             color: onClickDropDown))),
                        child: TextField(
                            readOnly: true,
                            controller: unitController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 239, 237, 237),
                              hintText: "الوحدة",
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
                      )),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextField(
                            onSubmitted: (value) {
                              SnackBar error = SnackBar(
                                duration: Duration(seconds: 5),
                                content: Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'نطاق الأرقام المسموح به لكمية الجرعة من 1 إلى 50',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );

                              if (value != "") {
                                if (double.parse(value) > 50 ||
                                    double.parse(value) <= 0) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(error);
                                }
                              }
                              ;
                            },
                            controller: pillAmountController,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^[0-9]*[.]?[0-9]*')),
                              LengthLimitingTextInputFormatter(4)
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 239, 237, 237),
                              hintText: "الكمية لكل جرعة",
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 65,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 20, left: 17, right: 11),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: pickerColor,
                      // color: selectedColor == null
                      //     ? Color.fromARGB(255, 140, 167, 190)
                      //     : selectedColor,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          changeColor(pickerColor);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "اختيار اللون",
                                          
                                          style:
                                    
                                           TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontSize: 18,
                                           ),
                                        ),
                                      )
                                    ],
                                    content: SingleChildScrollView(
                                      child: MaterialPicker(
                                        onColorChanged: changeColor,
                                        pickerColor:
                                            pickerColor, //default color
                                      ),
                                    )));
                      },
                      child: Text(
                        " (اختياري) تحديد لون لتمييز الجرعة ",
                        style: GoogleFonts.tajawal(
                          color: Color.fromARGB(255, 245, 244, 244),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Text(
                      ":المدة",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.tajawal(
                          color: Color.fromARGB(255, 122, 164, 186),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Slider(
                        divisions: 100,
                        value: sliderValue,
                        onChanged: (double value) {
                          setState(() {
                            sliderValue = value;
                            sliderValue.toInt();
                          });
                        },
                        inactiveColor: Color.fromARGB(255, 241, 225, 225),
                        activeColor: Color.fromARGB(255, 122, 164, 186),
                        min: 1,
                        max: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Text(
                      " ـ " +
                          sliderValue.toStringAsFixed(0) +
                          " ـ " +
                          " " +
                          "يوم",
                      style: GoogleFonts.tajawal(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      //TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                    child: Text(
                      ":التكرار",
                      textAlign: TextAlign.right,
                      style: GoogleFonts.tajawal(
                          color: Color.fromARGB(255, 122, 164, 186),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          margin: EdgeInsets.only(right: 5),
                          child: TextField(
                            controller: hoursController,
                            onSubmitted: (value) {
                              SnackBar error = SnackBar(
                                duration: Duration(seconds: 5),
                                content: Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'نطاق الأرقام المسموح به لعدد الساعات بين كل جرعة من 1 إلى 23',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );

                              if (value != "") {
                                if (int.parse(value) > 23 ||
                                    int.parse(value) <= 0) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(error);
                                }
                              }
                              ;
                            },

                            style: sliderValue2 == 1
                                ? TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255))
                                : TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                            textAlign: TextAlign.right,
                            // keyboardType: TextInputType.Options(
                            //     signed: false, decimal: false),
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2)
                            ],

                            decoration: InputDecoration(
                              filled: sliderValue2 == 1 ? false : true,
                              fillColor: Color.fromARGB(255, 239, 237, 237),
                              hintText: sliderValue2 == 1
                                  ? ''
                                  : 'عدد الساعات بين كل جرعة',
                              hintStyle: TextStyle(color: Colors.grey),
                              disabledBorder: InputBorder.none,
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
                            enabled: sliderValue2 == 1 ? false : true,
                            onChanged: (value) {
                              setState(() {
                                every_hours = value;
                                everyH = value;
                                if (sliderValue2 == 1) {
                                  every_hours = '0';
                                  everyH = '0';
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            sliderValue2 == 2
                                ? "الساعات المقترحة:       12 ساعة"
                                : sliderValue2 == 3
                                    ? "الساعات المقترحة:       8 ساعات"
                                    : sliderValue2 == 4
                                        ? "الساعات المقترحة:       6 ساعات"
                                        : sliderValue2 == 5
                                            ? "الساعات المقترحة:       4 ساعات"
                                            : "",
                            style: GoogleFonts.tajawal(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ])),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: Slider(
                                divisions: 4,
                                value: sliderValue2,
                                onChanged: (value) {
                                  setState(() {
                                    sliderValue2 = value;
                                  });
                                },
                                inactiveColor:
                                    Color.fromARGB(255, 241, 225, 225),
                                activeColor: Color.fromARGB(255, 122, 164, 186),
                                min: 1,
                                max: 5,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: Text(
                              sliderValue2 == 1
                                  ? "جرعة لكل يوم"
                                  : sliderValue2 < 3
                                      ? 'جرعتين لكل يوم'
                                      : " ـ " +
                                          sliderValue2.toStringAsFixed(0) +
                                          " ـ " +
                                          ' جرعات لكل يوم',
                              style: GoogleFonts.tajawal(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                        child: Text(
                          ":تاريخ أخذ أول جرعة",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.tajawal(
                              color: Color.fromARGB(255, 122, 164, 186),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final selectedDate = await selectDate(context);
                            if (selectedDate != null) {
                              setState(() {
                                setDate = DateTime(selectedDate.year,
                                    selectedDate.month, selectedDate.day);
                                // meds?.date = setDate;
                              });
                            }
                          },
                          child: Container(
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                // color: Colors.blue,
                                color: Color.fromRGBO(33, 150, 243, 0.1)),
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 27,
                                  color: Color.fromARGB(255, 140, 167, 190),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  dateFormat.format(setDate),
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                        child: Text(
                          ":وقت أخذ أول جرعة في اليوم",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.tajawal(
                              color: Color.fromARGB(255, 122, 164, 186),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(showPicker(
                                //  disableHour: true,
                                // minHour: double.parse(TimeOfDay.now().format(context).toString().substring(0,1)),
                                ltrMode: false,
                                iosStylePicker: true,
                                hourLabel: "ساعة",
                                minuteLabel: "دقيقة",
                                okText: "حسنًا",
                                cancelText: "إلغاء",
                                value: selectedTime,
                                onChange: (TimeOfDay time) {
                                  selectedTime = time;
                                  if (selectedTime != null) {
                                    setState(() {
                                      setTime = selectedTime;
                                      timeDisplayed = setTime;
                                      print(selectedTime);

                                      // print(setTime);
                                      //   print(timeDisplayed);

                                      if ((DateTime.now()
                                                  .toString()
                                                  .substring(0, 10) ==
                                              setDate
                                                  .toString()
                                                  .substring(0, 10)) &&
                                          (int.parse(setTime
                                                  .toString()
                                                  .substring(10, 12)) <=
                                              int.parse(TimeOfDay.now()
                                                  .toString()
                                                  .substring(10, 12)))) {
                                        if (int.parse(setTime
                                                .toString()
                                                .substring(10, 12)) ==
                                            int.parse(TimeOfDay.now()
                                                .toString()
                                                .substring(10, 12))) {
                                          if (int.parse(setTime
                                                  .toString()
                                                  .substring(13, 15)) <
                                              int.parse(TimeOfDay.now()
                                                  .toString()
                                                  .substring(13, 15))) {
                                            SnackBar error = SnackBar(
                                              duration: Duration(seconds: 5),
                                              content: Directionality(
                                                textDirection:
                                                    ui.TextDirection.rtl,
                                                child: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text(
                                                        'تاريخ ووقت أخذ أول جرعة في اليوم يجب أن يبدأ من الوقت الحالي فما بعد',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(error);
                                          }
                                        } else {
                                          SnackBar error = SnackBar(
                                            duration: Duration(seconds: 5),
                                            content: Directionality(
                                              textDirection:
                                                  ui.TextDirection.rtl,
                                              child: Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      'تاريخ ووقت أخذ أول جرعة في اليوم يجب أن يبدأ من الوقت الحالي فما بعد',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(error);
                                        }
                                      }
                                    });
                                  }
                                }));
                            // final selectedTime = await selectTime(context);
                          },
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 27, 10),
                              decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Color.fromRGBO(33, 150, 243, 0.1)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.alarm,
                                    color: Color.fromARGB(255, 140, 167, 190),
                                    size: 27,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    // timeDisplayed.format(context),
                                    timeDisplayed.format(context).contains("AM")
                                        ? timeDisplayed
                                                .format(context)
                                                .substring(0, 5) +
                                            "" +
                                            "ص"
                                        : timeDisplayed
                                                .format(context)
                                                .contains("PM")
                                            ? timeDisplayed
                                                    .format(context)
                                                    .substring(0, 5) +
                                                "" +
                                                "م"
                                            : timeDisplayed.format(context),

                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 45.0,
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      //  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                          child: Text(
                            ":موعد أخذ الجرعة",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.tajawal(
                                color: Color.fromARGB(255, 122, 164, 186),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ]),
                  Center(
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Column(
                        children: [
                          Container(
                            height: 20,
                          ),
                          ListTile(
                            title: Text('قبل الأكل',
                                style: GoogleFonts.tajawal(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            leading: Radio(
                                value: 'قبل الأكل',
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  checkRadio(value as String);
                                }),
                          ),
                          ListTile(
                            title: Text('بعد الأكل',
                                style: GoogleFonts.tajawal(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            leading: Radio(
                                value: 'بعد الأكل',
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  checkRadio(value as String);
                                }),
                          ),
                          ListTile(
                            title: Text('في أي وقت',
                                style: GoogleFonts.tajawal(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            leading: Radio(
                                value: 'في أي وقت',
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  checkRadio(value as String);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        saveMedicine();
                      },
                      child: Text(
                        "إضافة",
                        style: GoogleFonts.tajawal(
                          color: Color.fromARGB(255, 245, 244, 244),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 140, 167, 190),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: () {
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
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Navigation(data: 1,)));
                                        },
                                        child: Text(
                                          "نعم",
                                        ),
                                      ),
                                    ],
                                    content: Text(
                                      "هل أنت متأكد من رغبتك في إلغاء تحديد الجرعة؟",
                                      style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    )));
                      },
                      child: Text(
                        "إلغاء",
                        style: GoogleFonts.tajawal(
                          color: Color.fromARGB(255, 245, 244, 244),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 140, 167, 190),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ])),
      ),
    );
  }

  void checkRadio(String value) {
    setState(() {
      _groupValue = value;
    });
  }

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      backColor = color;
      print(backColor);
    });
  }

  Future<DateTime?> selectDate(BuildContext context) {
    return showDatePicker(
        locale: Locale('ar', ''),
        helpText: "          اختيار تاريخ بداية أخذ الجرعات",
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2024));
  }

  // Future<TimeOfDay?> selectTime(BuildContext context) {
  //   return showTimePicker(context: context, initialTime: TimeOfDay.now());
  // }

  // void medTypeClick(MedicineType type) {
  //   setState(() {
  //     medTypeList.forEach((element) {
  //       element.isSelected = false;
  //     });
  //     medTypeList[medTypeList.indexOf(type)].isSelected = true;
  //     medType = type.name;
  //   });
  // }

  void saveMedicine() {
    bool correctRepetiveTime = true;
    DateTime newDate = setDate;
    TimeOfDay newTime = setTime;

    if (compareTimeOfDay(setTime) &&
        pillAmountController.text != "" &&
        (double.parse(pillAmountController.text) < 50 &&
            double.parse(pillAmountController.text) > 0) &&
        (sliderValue2 == 1 ||
            (int.parse(every_hours) > 0 &&
                everyH != '' &&
                int.parse(every_hours) < 23 &&
                sliderValue2 != 1)) &&
        ((setDate.isAfter(DateTime.now())) ||
            ((DateTime.now().toString().substring(0, 10) ==
                    setDate.toString().substring(0, 10)) &&
                (int.parse(setTime.toString().substring(10, 12)) >
                    int.parse(TimeOfDay.now().toString().substring(10, 12)))) ||
            ((DateTime.now().toString().substring(0, 10) ==
                    setDate.toString().substring(0, 10)) &&
                (int.parse(setTime.toString().substring(10, 12)) ==
                    int.parse(TimeOfDay.now().toString().substring(10, 12))) &&
                int.parse(setTime.toString().substring(13, 15)) >=
                    int.parse(TimeOfDay.now().toString().substring(13, 15))))) {
      // editing purpose
      _firestore.collection('dosesEdit').add({
        'name': nameController.text,
        'selectedDescription': _groupValue,
        'description': description.text,
        'amount': pillAmountController.text,
        'unit': unitController.text,
        'days': sliderValue.toString(),
        'freqPerDay': sliderValue2.toString(),
        'hoursBetweenDoses': every_hours,
        //'colors': backColor,
        'color': int.parse(backColor.toString().substring(6, 16)),
        'firstDate': setDate,
        'firstTime': setTime.toString(),
        'Time': setTime.toString().substring(10, 15),
        'Date': DateFormat("yyyy-MM-dd").format(newDate).toString(),
        'caregiverID': caregiverID,
      });

      // editing purpose

      for (int i = 0; i < sliderValue; i++) {
        for (int j = 0; j < sliderValue2; j++) {
          tz.initializeTimeZones();
          //tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
          newTime = setTime.replacing(
              hour: setTime.hour + (int.parse(every_hours) * j));
          newTime.format(context);
          print(newTime.format(context) + "Right here");

          DateTime tempTimeDate = DateFormat("yyyy-MM-dd hh:mm a").parse(
              dateFormat.format(newDate).toString() +
                  " " +
                  newTime.format(context).toString());
          print(tempTimeDate.toString() + "Here is temp DateTime");

          DateTime oldDate = DateTime.utc(2022);

          _firestore.collection('doses').add({
            'Package size': package,
            'Remaining Package' : remaining,
            'Day': newDate.day,
            'Month': newDate.month,
            'Year': newDate.year,
            'Time': tempTimeDate,
            'Date': dateFormatDisplayed.format(newDate).toString(),
            //  'TimeOnly': newTime.format(context).toString(),

            'TimeOnly': newTime.format(context).contains("AM")
                ? newTime.format(context).substring(0, 5) + "ص"
                : newTime.format(context).contains("PM")
                    ? newTime.format(context).substring(0, 5) + "م"
                    : newTime.format(context),

            'amount': pillAmountController.text,
            'unit': unitController.text,
            'days': sliderValue.toString(),
            'name': nameController.text,
            //'type': medType,
            'freqPerDay': sliderValue2.toString(),
            'description': _groupValue + "  " + description.text,
            'color': int.parse(backColor.toString().substring(6, 16)),
            "Timecheked": oldDate,
            'cheked': false,
            'caregiverID': caregiverID,
            'picture': nameController.text == "جليترا"
                ? "images/" + "جليترا" + ".png"
                : nameController.text == "سبراليكس"
                    ? "images/" + "سبراليكس" + ".png"
                    : nameController.text == "سنترم - CENTRUM"
                        ? "images/" + "CENTRUM - سنترم" + ".png"
                        : nameController.text == "بانادول - PANADOL"
                            ? "images/" + "بانادول ادفانس - PANADOL" + ".png"
                            : nameController.text == "فيدروب - VIDROP"
                                ? "images/" + "VIDROP" + ".png"
                                : "images/" + "no" + ".png"
          });

          //  Notificationapi.showScheduledNotification(
          //    scheduledDate: DateTime(newDate.year, newDate.month, newDate.day,
          //         newTime.hour, newTime.minute),
          //     payload: nameController.text.toString(),
          //     id: notifyId++,
          //     title: 'Medicine Time',
          //   );
        }
        newTime = setTime;
        newDate = newDate.add(Duration(days: 1));
        dateFormat.format(newDate);
      }

      snackBar = SnackBar(
        content: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('تم تحديد الجرعة بنجاح',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.right),
              Icon(
                Icons.check,
                color: Colors.white,
              )
            ],
          ),
        ),
        // backgroundColor: Color.fromARGB(255, 140, 167, 190),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Navigation(data: 1,)));
    } else {
      if ((DateTime.now().toString().substring(0, 10) ==
              setDate.toString().substring(0, 10)) &&
          (int.parse(setTime.toString().substring(10, 12)) <=
              int.parse(TimeOfDay.now().toString().substring(10, 12)))) {
        if (int.parse(setTime.toString().substring(10, 12)) ==
            int.parse(TimeOfDay.now().toString().substring(10, 12))) {
          if (int.parse(setTime.toString().substring(13, 15)) <
              int.parse(TimeOfDay.now().toString().substring(13, 15))) {
            SnackBar error = SnackBar(
              duration: Duration(seconds: 5),
              content: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'تاريخ ووقت أخذ أول جرعة في اليوم يجب أن يبدأ من الوقت الحالي فما بعد',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(error);
          }
        } else {
          SnackBar error = SnackBar(
            duration: Duration(seconds: 5),
            content: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'تاريخ ووقت أخذ أول جرعة في اليوم يجب أن يبدأ من الوقت الحالي فما بعد',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(error);
        }
      }

      if (pillAmountController.text == "" ||
          (everyH == '' && sliderValue2 != 1)) {
        SnackBar error = SnackBar(
          duration: Duration(seconds: 5),
          content: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'الرجاء ملء الحقول الفارغة الإجبارية',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(error);
      }

      if (pillAmountController.text != "" &&
          (double.parse(pillAmountController.text) > 50 ||
              double.parse(pillAmountController.text) <= 0)) {
        SnackBar error = SnackBar(
          duration: Duration(seconds: 5),
          content: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'نطاق الأرقام المسموح به لكمية الجرعة من 1 إلى 50',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(error);
      }

      if (sliderValue2 != 1 && int.parse(every_hours) > 23 ||
          (sliderValue2 != 1 && int.parse(every_hours) <= 0)) {
        SnackBar error = SnackBar(
          duration: Duration(seconds: 5),
          content: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'نطاق الأرقام المسموح به لعدد الساعات بين كل جرعة من 1 إلى 23',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(error);
      }

      if (compareTimeOfDay(setTime) == false) {
        SnackBar error = SnackBar(
          duration: Duration(seconds: 5),
          content: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'يجب أن يتناسب عدد الجرعات في اليوم (التكرار) مع عدد الساعات بين كل جرعة مع وقت أخذ أول جرعة في اليوم',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(error);
      }
    }
  }

  bool compareTimeOfDay(TimeOfDay newTime) {
    double _doublenewTime = newTime.hour.toDouble() +
        (newTime.minute.toDouble() / 60) +
        double.parse(every_hours) * (sliderValue2 - 1);
    if (sliderValue2 == 1) return true;
    if (_doublenewTime > TimeOfDay.hoursPerDay.toDouble()) {
      print(sliderValue2.toString() + "slider value2");
      print("double new");
      print(_doublenewTime);
      return false;
    }

    return true;
  }
}
