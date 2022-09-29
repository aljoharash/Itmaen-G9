import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
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

  late AnimationController _animationController;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final nameController = TextEditingController();
  final pillAmountController = TextEditingController();
  final TextEditingController description = new TextEditingController();
  //TextEditingController unit = new TextEditingController();
  DateTime setDate = DateTime.now();
  TimeOfDay setTime = TimeOfDay.now();
  //int notifyId = 0;
  String medType = '';
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateFormat dateFormatDisplayed = DateFormat('dd/MM/yyyy');
  Color onClickDropDown = Colors.black45;
  double dropDownwidth = 2;
  double sliderValue = 50;
  double sliderValue2 = 3;
  //Medicine? meds;
  late SnackBar snackBar;
  String every_hours = '0';
  get onChanged => null;
  String? selectType = "مل";
  List<String> list = ['مل', 'مجم', 'حبة'];
  Color backColor = Color.fromARGB(255, 209, 209, 209);
  Color pickerColor = Color.fromARGB(255, 140, 167, 190);
  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _animationController.forward();
    _animationController.addListener(() {});
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
    //  selectType = toBeTransformed[2];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 140, 167, 190),
        elevation: 0,
        title: Text(
          "تحديد جرعة الدواء",
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // ignore: prefer_const_constructors
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
                          color: Color.fromARGB(255, 236, 231, 231), width: 3)),
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



            Row(
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.only(left: 15),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          side: BorderSide(
                              width: dropDownwidth, color: onClickDropDown))),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: list.map(buildMenuItem).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectType = value;

                        dropDownwidth = 2;
                        onClickDropDown = Color.fromARGB(79, 255, 255, 255);
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    value: selectType,
                  ),
                )),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: TextField(
                      controller: pillAmountController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
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
                                    style: GoogleFonts.tajawal(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 140, 167, 190),
                                    ),
                                  ),
                                )
                              ],
                              content: SingleChildScrollView(
                                child: MaterialPicker(
                                  onColorChanged: changeColor,
                                  pickerColor: pickerColor, //default color
                                ),
                              )));
                },
                child: Text(
                  "تحديد لون الجرعة ",
                  style: GoogleFonts.tajawal(
                    color: Color.fromARGB(255, 245, 244, 244),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Container(
            //   color: Color.fromARGB(255, 239, 237, 237),
            //   padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            //   margin: EdgeInsets.only(right: 10, left: 10),

            //   height: 70,

            //   // width: double.infinity,
            //   child: DropdownButtonFormField(
            //     // isExpanded: true,
            //     decoration: InputDecoration(labelText: 'قم باختيار لون للجرعة'),
            //     items: colors
            //         .colorsList()
            //         .map<DropdownMenuItem<colors>>((color1) => DropdownMenuItem(
            //               value: color1,
            //               child: Row(
            //                 children: <Widget>[
            //                   Text(color1.name + " "),
            //                 ],
            //               ),
            //             ))
            //         .toList(),
            //     onChanged: ((value) {
            //       setState(() {
            //       selectedColor = value as String;
            //       });
            //     }),
            //   ),
            // ),

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
            Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                max: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                " ـ " + sliderValue.toStringAsFixed(0) + " ـ " + " " + "يوم",
                style: GoogleFonts.tajawal(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                //TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                ":التكرار",
                textAlign: TextAlign.right,
                style: GoogleFonts.tajawal(
                    color: Color.fromARGB(255, 122, 164, 186),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 0, 5, 0),
                    margin: EdgeInsets.only(right: 15),
                    child: TextField(
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: sliderValue2 == 1 ? '-' : 'لكل ـ ساعة',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      enabled: sliderValue2 == 1 ? false : true,
                      onChanged: (value) {
                        setState(() {
                          every_hours = value;
                          if (sliderValue2 == 1) every_hours = '0';
                        });
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
                      child: Slider(
                        divisions: 5,
                        value: sliderValue2,
                        onChanged: (value) {
                          setState(() {
                            sliderValue2 = value;
                          });
                        },
                        inactiveColor: Color.fromARGB(255, 241, 225, 225),
                        activeColor: Color.fromARGB(255, 122, 164, 186),
                        min: 1,
                        max: 5,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        // color: Colors.blue,
                        color: Color.fromRGBO(33, 150, 243, 0.1)),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          dateFormat.format(setDate),
                          style: TextStyle(fontSize: 27, color: Colors.grey,),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.calendar_month,
                          size: 27,
                          color: Color.fromARGB(255, 140, 167, 190),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final selectedTime = await selectTime(context);
                    if (selectedTime != null) {
                      setState(() {
                        setTime = selectedTime;
                        //     meds?.time = selectedTime;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Color.fromRGBO(33, 150, 243, 0.1)),
                    child: Row(
                      children: [
                        Text(
                          setTime.format(context),
                          style: TextStyle(fontSize: 27, color: Colors.grey,),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.alarm,
                          color: Color.fromARGB(255, 140, 167, 190),
                          size: 27,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),

                  Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextField(
                controller: description,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 239, 237, 237),
                  hintText: 'وصف الجرعة',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 236, 231, 231), width: 3)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(
                        color: Color.fromARGB(79, 255, 255, 255)),
                    borderRadius: new BorderRadius.circular(10),
                  ),
                ),
              ),
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
                    primary:Color.fromARGB(255, 140, 167, 190),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ]),
    );
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
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
  }

  Future<TimeOfDay?> selectTime(BuildContext context) {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

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

    if (compareTimeOfDay(setTime)) {
      for (int i = 0; i < sliderValue; i++) {
        for (int j = 0; j < sliderValue2; j++) {
          tz.initializeTimeZones();
          tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
          newTime = setTime.replacing(
              hour: setTime.hour + (int.parse(every_hours) * j));
          newTime.format(context);

          DateTime tempTimeDate = DateFormat("yyyy-MM-dd hh:mm a").parse(
              dateFormat.format(newDate).toString() +
                  " " +
                  newTime.format(context).toString());

          _firestore.collection('doses').add({
            'Day': newDate.day,
            'Month': newDate.month,
            'Year': newDate.year,
            'Time': tempTimeDate,
            'Date': dateFormatDisplayed.format(newDate).toString(),
            'TimeOnly': newTime.format(context).toString(),
            'amount': pillAmountController.text,
            'unit': selectType,
            'days': sliderValue.toString(),
            'name': nameController.text,
            //'type': medType,
            'freqPerDay': sliderValue2.toString(),
            'description': description.text,
            'color': int.parse(backColor.toString().substring(6,16)),
            'cheked': false,
            'caregiverID': caregiverID,
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
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'تمت إضافة الدواء وتحديد الجرعة',
            
              style: TextStyle(color: Colors.white, fontSize: 15),
               textAlign: TextAlign.right
            ),
            Icon(
              Icons.check,
              color: Colors.white,
            )
          ],
        ),
       // backgroundColor: Color.fromARGB(255, 140, 167, 190),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pop(context);
    } else {
      SnackBar error = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Error!! Check your Frequency and hours per day',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Icon(
              Icons.check,
              color: Colors.white,
            )
          ],
        ),
        backgroundColor: Colors.red,
      );

      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  bool compareTimeOfDay(TimeOfDay newTime) {
    double _doublenewTime = newTime.hour.toDouble() +
        (newTime.minute.toDouble() / 60) +
        double.parse(every_hours) * (sliderValue2 - 1);
    if (sliderValue2 == 1) return true;
    if (_doublenewTime > TimeOfDay.hoursPerDay.toDouble()) return false;

    return true;
  }
}

// class ImageContainer extends StatelessWidget {
//   final MedicineType medtype;
//   final Function onClick;
//   ImageContainer({required this.medtype, required this.onClick});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         onClick(medtype);
//       },
//       child: Container(
//         width: 150,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: medtype.isSelected ? const Color(0xff1F51FF) : Colors.white,
//         ),
//         margin: EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             medtype.image,
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               medtype.name,
//               style: TextStyle(
//                   color: medtype.isSelected ? Colors.white : Colors.black),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
