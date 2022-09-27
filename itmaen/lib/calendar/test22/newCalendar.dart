import 'dart:js';
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
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
  }
/*
  Future<bool> getstatu() async {
    bool val = await getCurrentUser();
    bool val2 = val;
    return val2;
  }*/
/*
  void getCurrentUser() async {
    //String qrData="";
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }*/

/*

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
  }*/

/*
  Future<void> details() async {
  CollectionReference doses =
      FirebaseFirestore.instance.collection('doses');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid.toString();
  doses.get().['kk'];
  });
*/
/*
QuerySnapshot snap = await Firestore.instance.collection('collection').getDocuments();
snap.documents.forEach((document) { 
  print(document.documentID);
  });*/

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
    var snapShotsValue = await databaseReference
        .collection("doses")
        .where('caregiverID', isEqualTo: caregiverID)
        .get();
    //if (snapShotsValue != null) {
    // print("first" + caregiverID);
//print('testinh'+))
    final Random random = new Random();
    List<Meeting> list = snapShotsValue.docs
        .map((e) => Meeting(
            eventName: e.data()['unit'],
            //freqPerDay: e.data()['freqPerDay'],
            from: DateFormat('dd/MM/yyyy').parse(e.data()['Date']),
            to: DateFormat('dd/MM/yyyy').parse(e.data()['EndTime']),
            background: _colorCollection[random.nextInt(9)],
            isAllDay: false))
        .toList();
    setState(() {
      events = MeetingDataSource(list);
    });
    /* } else {
      var snapShotsValue = await databaseReference
          .collection("doses")
          .where('caregiverID', isEqualTo: cid_)
          .get();
      print("second" + id_);
      final Random random = new Random();
      List<Meeting> list = snapShotsValue.docs
          .map((e) => Meeting(
              eventName: e.data()['name'],
              //freqPerDay: e.data()['freqPerDay'],
              from: DateFormat('dd/MM/yyyy').parse(e.data()['Date']),
              to: DateFormat('dd/MM/yyyy').parse(e.data()['EndTime']),
              background: _colorCollection[random.nextInt(9)],
              isAllDay: false))
          .toList();
      setState(() {
        events = MeetingDataSource(list);
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            /*
            leading: PopupMenuButton<String>(
          icon: Icon(Icons.settings),
          itemBuilder: (BuildContext context) => options.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList(),
          onSelected: (String value) {
            if (value == 'Add') {
              databaseReference.collection("testCalendar").doc("1").set({
                'Subject': 'Mastering Flutter',
                'StartTime': '26/09/2022 06:25:00',
                'EndTime': '26/09/2022 09:25:00'
              });
            } else if (value == "Delete") {
              try {
                databaseReference.collection('testCalendar').doc('1').delete();
              } catch (e) {}
            } else if (value == "Update") {
              try {
                databaseReference
                    .collection('testCalendar')
                    .doc('1')
                    .update({'Subject': 'Meeting'});
              } catch (e) {}
            }
          },
        )*/
            ),
        body: SfCalendar(
          view: CalendarView.month,
          initialDisplayDate: DateTime(2022, 9, 25, 9, 0, 0),
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

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Meeting appointmentDetails = details.appointments[0];
      String? _subjectText = appointmentDetails.eventName;
      var date = DateFormat('MMMM dd, yyyy');

      showDialog(
          context: this.context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(child: new Text('$_subjectText')),
              content: Container(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'deem',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('test2',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    ),
                    Row(
                      children: [Text("Id:")],
                    )
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
  //String? freqPerDay;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;

  Meeting(
      {this.eventName,
      //this.freqPerDay,
      this.from,
      this.to,
      this.background,
      this.isAllDay});
}
//this.eventName,

