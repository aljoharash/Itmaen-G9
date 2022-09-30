//import 'dart:js';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:itmaen/secure-storage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadDataFromFireStoree extends StatefulWidget {
  @override
  LoadDataFromFireStoreeState createState() => LoadDataFromFireStoreeState();
}

class LoadDataFromFireStoreeState extends State<LoadDataFromFireStoree> {
  StorageService st = StorageService();
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  List<Color> _colorCollection = <Color>[];
  MeetingDataSource? events;
  //final List<String> options = <String>['Add', 'Delete', 'Update'];
  final databaseReference = FirebaseFirestore.instance;

  late String id = '';
  static var id_ = '';
  //var Cid;
  static String cid_ = '';
  var caregiverID;
  static var t;

  LoadDataFromFireStoreeState() {
    LoadDataFromFireStoree();
  }
  

  @override
  void initState() {
    super.initState();
    //getCurrentUser();
    //getCurrentUser().then((value) => t = value);
    _initializeEventColor();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
  }

   var description;
   var amount;
   var namee;
   var checked;
   var unit;
   String? _subjectText ;
   List <String>  doseDes = <String> [];
   List <String>  doseAmount = <String> [];
   List <String>  doseName = <String> [];
   List <bool>  doseCheck = <bool> [];
   List <String>  doseUnit= <String> [];
   var currDes;
   var currAmount;
   var currCheck;
   var currUnit;
   var isChecked;
   int count = 0;

   retrieve(QuerySnapshot snapshot) {
          snapshot.docs.forEach((doc) {
            count++;
            namee = doc['name'];
            description = doc['description'];
            amount = doc['amount'];
            checked = doc['cheked'];
            unit = doc['unit'];
            doseDes.add(description);
            doseAmount.add(amount);
            doseName.add(namee);
            doseCheck.add(checked);
            doseUnit.add(unit);
            print("$description + $amount");
            
           });

        } 

    intoList(){
      for(int i = 0 ; i < count; i++){
        if(doseName[i] == _subjectText ){
          currDes = doseDes[i];
          currAmount = doseAmount[i];
          currCheck = doseCheck[i];
          currUnit = doseUnit[i];
        }

        if(currCheck == true){
          isChecked = "تم أخذ الدواء";
        }else{
          isChecked = "لم يتم أخذ الدواء";
        }


      }

    }

  Future<void> getDataFromFireStore() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
    // print("first" + caregiverID);
    //StreamBuilder(  stream:(
       var snapShotsValue = await FirebaseFirestore.instance
        .collection("doses")
        .where('caregiverID', isEqualTo: caregiverID)
        .get();

        retrieve(snapShotsValue);

    final Random random = new Random();
    List<Meeting> list = snapShotsValue.docs
        .map((e) => Meeting(
            eventName: e.data()['name'],
            //freqPerDay: e.data()['freqPerDay'],
            from: DateFormat('dd/MM/yyyy').parse(e.data()['Date']),
            to: DateFormat('dd/MM/yyyy').parse(e.data()['Date']),
            background: _colorCollection[random.nextInt(9)],
            isAllDay: false))
        .toList();
    setState(() {
      events = MeetingDataSource(list);
    });

  }

         

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            ),
        body: SfCalendar(
          view: CalendarView.month,
          initialDisplayDate: DateTime.now(),
          dataSource: events,
          onTap: calendarTapped,
          monthViewSettings: MonthViewSettings(
            showAgenda: true,
          ),
        ));
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  Future<void> calendarTapped(CalendarTapDetails details) async {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda && details != null) {
      final Meeting appointmentDetails = details.appointments[0];
      _subjectText = appointmentDetails.eventName;
      var date = DateFormat('MMMM dd, yyyy');
      var name = Meeting().eventName;
      intoList();
      // var description = Doses().description;
      // var amount = Doses().amount;
      // print("$amount + $description");
       



      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(child: new Text('$_subjectText')),
              content: Container(
                height: 80,
                child: Column(
                  children: <Widget>[
                    // Row(
                    //   children: <Widget>[
                    //     Text(
                    //       '$name',
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.w400,
                    //         fontSize: 20,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: <Widget>[
                        Text('$currDes',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    ),
                    Row(
                      children: [Text('$currUnit $currAmount')],
                    ),
                    Row(
                      children: [Text('$isChecked')],
                    ),
                  ],
                ),
              ),
              /*
 actions: <Widget>[
 new FlatButton(
 onPressed: () {
 Navigator.of(context).pop();
 },
 child: new Text('close'))
 ],*/
            );
          });
    }
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

//CalendarDataSource

/*
  @override
  String freqPerDay(int index) {
    return appointments![index].freqPerDay;
  }*/

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

class Meeting {
  String? eventName;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;

  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay});
}
//this.eventName,

class Doses{
  String? description;
  String? amount;

  Doses(
    {this.description,
    this.amount}
  );

}

