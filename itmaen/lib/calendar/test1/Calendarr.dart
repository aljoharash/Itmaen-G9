// @dart=2.9
// ignore_for_file: deprecated_member_use

import 'dart:collection';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';


class LoadDataFromFireStore extends StatefulWidget {
  @override
  LoadDataFromFireStoreState createState() => LoadDataFromFireStoreState();
}

class LoadDataFromFireStoreState extends State<LoadDataFromFireStore> {
  DataSnapshot querySnapshot;
  dynamic data;
  List<Color> _colorCollection;
  final List<String> options = <String>['Add', 'Delete'];

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String caregiverID = "";
  User loggedInUser;

  
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
  void initState() {
     getCurrentUser();
    _initializeEventColor();
    getDataFromDatabase().then((results) {
      setState(() {
        if (results != null) {
          querySnapshot = results;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              final dbRef =
                  FirebaseDatabase.instance.reference().child("doses");
              dbRef.push().set({
                "StartTime": '25/09/2022 07:00:00',
                "EndTime": '25/09/2022 08:00:00',
                "Subject": 'NewMeeting',
                "ResourceId": '0001'
              }).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully Added')));
              }).catchError((onError) {
                print(onError);
              });
            } else if (value == 'Delete') {
              final dbRef =
                  FirebaseDatabase.instance.reference().child("doses");
              dbRef.remove();
            }
          },
        ),
      ),
      body: _showCalendar(),
    );
  }

  _showCalendar() {
    if (querySnapshot != null) {
      List<Meeting> collection;
      var showData = querySnapshot.value;
      Map<dynamic, dynamic> values = showData;
      List<dynamic> key = values.keys.toList();
      if (values != null) {
        for (int i = 0; i < key.length; i++) {
          data = values[key[i]];
          collection ??= <Meeting>[];
          final Random random = new Random();
          collection.add(Meeting(
              eventName: data['Subject'],
              isAllDay: false,
              from: DateFormat('dd/MM/yyyy HH:mm:ss').parse(data['StartTime']),
              to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(data['EndTime']),
              background: _colorCollection[random.nextInt(9)],
              resourceId: data['ResourceId']));
        }
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return SfCalendar(
        view: CalendarView.timelineDay,
        allowedViews: [
          CalendarView.timelineDay,
          CalendarView.timelineWeek,
          CalendarView.timelineWorkWeek,
          CalendarView.timelineMonth,
        ],
        initialDisplayDate: DateTime(2022, 9, 25, 9, 0, 0),
        dataSource: _getCalendarDataSource(collection),
        monthViewSettings: MonthViewSettings(showAgenda: true),
      );
    }
  }

  void _initializeEventColor() {
    this._colorCollection = new List<Color>();
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
}

MeetingDataSource _getCalendarDataSource([List<Meeting> collection]) {
  List<Meeting> meetings = collection ?? <Meeting>[];
  List<CalendarResource> resourceColl = <CalendarResource>[];
  resourceColl.add(CalendarResource(
    displayName: 'John',
    id: '0001',
    color: Colors.red,
  ));
  return MeetingDataSource(meetings, resourceColl);
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  List<Object> getResourceIds(int index) {
    return [appointments[index].resourceId];
  }
}

getDataFromDatabase() async {
  var value = FirebaseDatabase.instance.reference();
}

class Meeting {
  Meeting(
      {this.eventName,
      this.from,
      this.to,
      this.background,
      this.isAllDay,
      this.resourceId});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String resourceId;
}