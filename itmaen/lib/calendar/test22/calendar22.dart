/*import 'dart:math';
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
    late User loggedUser;
  List<Color> _colorCollection = <Color>[];
  MeetingDataSource? events;
  final List<String> options = <String>['Add', 'Delete', 'Update'];
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
    getCurrentUser().then((value) => t = value);
    _initializeEventColor();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
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
/*
  Future<void> getDataFromFireStore() async {
        var data;
     FutureBuilder(
          builder: (ctx, snapshot) {
      // Checking if future is resolved or not
       if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                ); }
          else if (snapshot.hasData) {
                // Extracting data from snapshot object
                data = snapshot.data as bool;
                if (data == true) {
    print("first1" + cid_);
    var snapShotsValue = FirebaseFirestore.instance
        .collection("doses")
        .where('caregiverID', isEqualTo: cid_)
        .snapshots();
         builder: (BuildContext context,
         AsyncSnapshot<QuerySnapshot> snapshot) {
           if (!snapshot.hasData) {
      return Text("Loading...");
                       }
       final calendar = snapshot.data?.docs;
    List<Meeting> list = [];
        for (var data in calendar!) {
       final cal = data.get('name');
       
        final Caln = Meeting(cal);
          list.add(Caln);       }
    
      print("first" + cid_);
      final Random random = new Random();
        

      List<Meeting> list = snapShotsValue.data.docs
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
    } 
    else  {
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
        }  
        }//else 
       }
        return Center(
              child: CircularProgressIndicator(),
            );
          },
      future: getCurrentUser(), 
       );
  }
      */
  
          
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        ),
        body: SfCalendar(
          view: CalendarView.month,
          initialDisplayDate: DateTime(2022, 9, 25, 9, 0, 0),
          dataSource: events,
          monthViewSettings: MonthViewSettings(
            showAgenda: true,
          ),
        ),  child:Coulmn(context

        )
        ) ,
         
         )
        
        
        );
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


*/