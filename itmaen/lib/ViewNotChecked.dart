import 'dart:async';

import 'dart:convert';

import 'dart:core';

import 'dart:ffi';

import 'dart:io';

//import 'dart:html';

import 'dart:ui' as ui;

import 'package:audioplayers/audioplayers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:itmaen/add-patient.dart';

import 'package:itmaen/callP.dart';

import 'package:itmaen/editprofile.dart';

import 'package:itmaen/navigation.dart';

import 'package:itmaen/navigationPatient.dart';

import 'package:itmaen/patient-login.dart';

import 'package:path_provider/path_provider.dart';

//import 'package:workmanager/workmanager.dart';

import 'package:itmaen/setting.dart';

//import 'package:workmanager/workmanager.dart';

import 'alert_dialog.dart';

import 'package:itmaen/model/medicines.dart';

import 'controller/TextToSpeechAPI.dart';

import 'generateqr.dart';

import 'login.dart';

import 'model/Voice.dart';

import 'scanqr.dart';

import 'addMedicinePages/addmedicine.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'package:firebase_storage/firebase_storage.dart';

//import 'pages/adddialog.dart';

import 'package:itmaen/secure-storage.dart';

//import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:intl/intl.dart';

class ViewNotAllCheck extends StatefulWidget {
  const ViewNotAllCheck({Key? key}) : super(key: key);

  @override
  _ViewNotAllCheckPageState createState() => _ViewNotAllCheckPageState();
}

class _ViewNotAllCheckPageState extends State<ViewNotAllCheck> {
  final NavigationPatient nv =
      new NavigationPatient(); // to take notifications method

  String title = 'AlertDialog';

  bool tappedYes = false;

  StorageService st = StorageService();

  final _auth = FirebaseAuth.instance;

  late User? loggedInUser = _auth.currentUser;

  AudioPlayer audioPlayer = AudioPlayer();

  /*

 

    code for voice and google api : start

 

  */

  List<Voice> _voices = [];

  Voice? _selectedVoice;

  /*

 

    code for voice and google api : end

 

  */

  /*

 

    code for voice and google api : end

 

  */

  Timer? timer;

  late String id = '';

  static var id_ = '';

  //var Cid;

  static String cid_ = '';

  var caregiverID;

  static var t;

  //getCurrentUser();

  _ViewPageState() {
    //ViewD();

    //assignboolean();
  }

  //}

  @override
  void initState() {
    super.initState();

    //HomePage();

    if (Platform.isIOS) {
      final AudioContext audioContext = AudioContext(
        iOS: AudioContextIOS(
          defaultToSpeaker: true,
          category: AVAudioSessionCategory.ambient,
          options: [
            AVAudioSessionOptions.defaultToSpeaker,
            AVAudioSessionOptions.mixWithOthers,
          ],
        ),
        android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.assistanceSonification,
          audioFocus: AndroidAudioFocus.none,
        ),
      );

      AudioPlayer.global.setGlobalAudioContext(audioContext);
    }

    getCurrentUser().then((value) => t = value);

    //   timer = Timer.periodic(const Duration(seconds: 50), (Timer t) {

    //     callbackDispatcher();

    // });
  }

  Future<bool> getstatu() async {
    bool val = await getCurrentUser();

    bool val2 = val;

    return val2;
  }

  _callNumber() async {
    const number = '08592119XXXX'; //set the number here

    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
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

  //late User? loggedInUser = _auth.currentUser;

  @override
  Widget build(BuildContext context) {
    var data;

    void dispose() {
      audioPlayer.stop();

      audioPlayer.dispose();
    }

    return SafeArea(
      top: false,
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          // drawer: loggedInUser == null ? null : NavBar(),

          body: FutureBuilder(
            builder: (ctx, snapshot) {
              // Checking if future is resolved or not

              if (snapshot.connectionState == ConnectionState.done) {
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

                  data = snapshot.data as bool;

                  if (data == true) {
                    var j = 0;

                    return SafeArea(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('doses')
                                .where('caregiverID', isEqualTo: id_)
                                .orderBy('Time')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Text("");
                              } //else {

                              final medicines = snapshot.data?.docs;

                              List<medBubble> medBubbles = [];

                              String x = DateFormat('dd/MM/yyyy')
                                  .format(DateTime.now());

                              for (var med in medicines!) {
                                //final medName = med.data();

                                final medDate = med.get('Date');

                                //  if (x == medDate) {

                                final medName = med.get('name');

                                final checked = med.get('cheked');

                                final id = med.get('caregiverID');

                                final doc = med.id;

                                final time = med.get('TimeOnly');

                                final MedAmount = med.get('amount');

                                final meddescription = med.get('description');

                                final MedUnit = med.get('unit');

                                final medColor = med.get('color');

                                final m = med.get('Time');

                                final picture = med.get('picture');

                                bool send = true;

                                // final pic = med.get("picture");

                                final timechecked = med.get('Timecheked');

                                // var i = 0;

                                Navigation nv = Navigation();

                                var x = DateTime.now();

                                String format =
                                    DateFormat('yyy-MM-dd - kk:mm').format(x);

                                String format2 = DateFormat('yyy-MM-dd - kk:mm')
                                    .format(timechecked.toDate());

                                // print(format);

                                // print(format2);

                                // print(x == timechecked.toDate());

                                // print(x);

                                // print(timechecked.toDate());

                                // print('herree');

                                // if (format == format2 && send == false) {

                                //   nv.sendNotificationchecked2(

                                //       ' جرعة ${medName} ');

                                // }

                                final MedBubble = medBubble(
                                    medName,
                                    checked,
                                    caregiverID,
                                    doc,
                                    time,
                                    MedAmount,
                                    meddescription,
                                    MedUnit,
                                    medColor,
                                    x,
                                    m,
                                    picture,
                                    send,
                                    timechecked,
                                    audioPlayer,
                                    medDate);

                                medBubbles.add(MedBubble);
                              }

                              //  }

                              return Expanded(
                                child: Scrollbar(
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    children: medBubbles,
                                  ),
                                ),
                              );

                              // }
                            })
                      ],
                    ));
                  } else {
                    var i = 0;

                    return SafeArea(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        LinearProgressIndicator(
                          backgroundColor:
                              ui.Color.fromARGB(255, 119, 122, 122),
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              ui.Color.fromARGB(255, 54, 244, 130)),
                          value: 0.5,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text('${(0.1 * 100).round()}%',
                              style: GoogleFonts.tajawal(
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [],
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('doses')
                                .where('caregiverID', isEqualTo: cid_)
                                .orderBy('Time')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Text("");
                              } //else {

                              final medicines = snapshot.data?.docs;

                              List<medBubble> medBubbles = [];

                              String x = DateFormat('dd/MM/yyyy')
                                  .format(DateTime.now());

                              for (var med in medicines!) {
                                final medDate = med.get('Date');

                                final medName = med.get('name');

                                final checked = med.get('cheked');

                                final id = med.get('caregiverID');

                                final doc = med.id;

                                final time = med.get('TimeOnly');

                                final MedAmount = med.get('amount');

                                final meddescription = med.get('description');

                                final MedUnit = med.get('unit');

                                final medColor = med.get('color');

                                final m = med.get('Time');

                                final picture = med.get("picture");

                                bool send = false;

                                // final pic = med.get("picture");

                                //final timechecked;

                                final timechecked = med.get('Timecheked');

                                Navigation nv = Navigation();

                                var x = DateTime.now();

                                String format =
                                    DateFormat('yyy-MM-dd - kk:mm').format(x);

                                String format2 = DateFormat('yyy-MM-dd - kk:mm')
                                    .format(timechecked.toDate());

                                //  print(format);

                                // print(format2);

                                // print(x == timechecked.toDate());

                                // print(x);

                                // print(timechecked.toDate());

                                print('herree');

                                if (format == format2 && send == false) {
                                  nv.sendNotificationchecked2(
                                      ' جرعة ${medName} ');
                                }

                                final MedBubble = medBubble(
                                    medName,
                                    checked,
                                    caregiverID,
                                    doc,
                                    time,
                                    MedAmount,
                                    meddescription,
                                    MedUnit,
                                    medColor,
                                    x,
                                    m,
                                    picture,
                                    send,
                                    timechecked,
                                    audioPlayer,
                                    medDate);

                                if (checked == false) {
                                  medBubbles.add(MedBubble);
                                }

                                //  }

                              }

                              return Expanded(
                                child: Scrollbar(
                                  child: ListView(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    children: medBubbles,
                                  ),
                                ),
                              );

                              // }
                            })
                      ],
                    ));
                  }
                }
              }

              // Displaying LoadingSpinner to indicate waiting state

              return Center(
                child: CircularProgressIndicator(),
              );
            },

            // Future that needs to be resolved

            // inorder to display something on the Canvas

            future: getCurrentUser(),
          ),
        ),
      ),
    );
  }
}

class medBubble extends StatefulWidget {
  AudioPlayer audioPlayer;

  medBubble(
      this.medicName,
      this.checked,
      this.ID,
      this.doc,
      this.time,
      this.MedAmount,
      this.meddescription,
      this.MedUnit,
      this.medColor,
      this.x,
      this.m,
      this.picture,
      this.send,
      this.timechecked,
      this.audioPlayer,
      this.medDate);

  // اي الله يدضر عليك

  var medicName;

  var checked;

  var ID;

  var doc;

  var time;

  var MedAmount;

  var meddescription;

  var MedUnit;

  var medDate;

  var medColor;

  var x;

  var m;

  var picture;

  var send;

  var timechecked;

  @override
  State<medBubble> createState() => _medBubbleState();
}

class _medBubbleState extends State<medBubble> {
  bool _value = false;

  bool _valu = false;

  var msg = "hh";

  final Navigation nv = new Navigation();

  //bool yarab = false;

  Color color = Colors.black;

  Future<void> dialog(String? x) async {
    return showDialog<void>(
      context: context,

      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              '  تم تناول الجرعة مسبقا ',
              style: GoogleFonts.tajawal(
                  fontSize: 20,
                  color: ui.Color.fromARGB(255, 24, 25, 25),
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(
                  Icons.health_and_safety,
                  size: 35,
                  color: ui.Color.fromARGB(255, 111, 161, 200),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(x!,
                      style: GoogleFonts.tajawal(
                          fontSize: 18,
                          color: ui.Color.fromARGB(255, 99, 163, 206),
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(widget.MedUnit + ' ' + widget.MedAmount,
                      style: GoogleFonts.tajawal(
                          fontSize: 18,
                          color: ui.Color.fromARGB(255, 81, 99, 110),
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text('${widget.meddescription}',
                      style: GoogleFonts.tajawal(
                          fontSize: 18,
                          color: ui.Color.fromARGB(255, 81, 99, 110),
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: Text('حسنا',
                    style: GoogleFonts.tajawal(
                        fontSize: 18,
                        color: ui.Color.fromARGB(255, 24, 25, 25),
                        fontWeight: FontWeight.bold)),
              ),
              onPressed: () {
                //Navigator.of(context).pop();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var time = DateTime.now();

    //var q = DateTime.parse(widget.m);

    final q = widget.m;

    var dosetime = q.toDate();

    var diff = (dosetime).difference(time).inMinutes;

    /*

 

    code for voice and google api : start

 

  */

    // List<Voice> _voices = [];

    // Voice? _selectedVoice;

    // AudioPlayer audioPlugin = AudioPlayer();

    // void synthesizeText(String text) async {

    //   if (audioPlugin.state == AudioPlayer().state) {

    //     await audioPlugin.stop();

    //   }

    //   final String audioContent = await TextToSpeechAPI().synthesizeText(text);

    //   if (audioContent == null) return;

    //   final bytes =

    //       Base64Decoder().convert(audioContent, 0, audioContent.length);

    //   final AudioContext audioContext = AudioContext(

    //     iOS: AudioContextIOS(

    //       defaultToSpeaker: true,

    //       category: AVAudioSessionCategory.ambient,

    //       options: [

    //         AVAudioSessionOptions.defaultToSpeaker,

    //         AVAudioSessionOptions.mixWithOthers,

    //       ],

    //     ),

    //     android: AudioContextAndroid(

    //       isSpeakerphoneOn: true,

    //       stayAwake: true,

    //       contentType: AndroidContentType.sonification,

    //       usageType: AndroidUsageType.assistanceSonification,

    //       audioFocus: AndroidAudioFocus.none,

    //     ),

    //   );

    //   AudioPlayer.global.setGlobalAudioContext(audioContext);

    //   if (Platform.isAndroid) {

    //     final dir = await getTemporaryDirectory();

    //     final file = File('${dir.path}/wavenet.mp3');

    //     await file.writeAsBytes(bytes);

    //     UrlSource fileSource = new UrlSource(file.path);

    //     await audioPlugin.play(fileSource);

    //   } else if (Platform.isIOS) {

    //     final dir = await getApplicationDocumentsDirectory();

    //     final file = File('${dir.path}/wavenet.mp3');

    //     await file.writeAsBytes(bytes);

    //     print(file.path);

    //     UrlSource fileSource = new UrlSource(file.path);

    //     DeviceFileSource deviceFileSource = new DeviceFileSource(file.path);

    //     await audioPlugin.play(deviceFileSource);

    //   }

    // }

    /*

 

    code for voice and google api : end

 

  */

    Future<void> _showMyDialog(String? x) async {
      return showDialog<void>(
        context: context,

        barrierDismissible: false, // user must tap button!

        builder: (BuildContext context) {
          return

              // textDirection: ui.TextDirection.rtl,

              AlertDialog(
            title: Center(
              child: Text(
                ' أخذ الجرعة',
                style: GoogleFonts.tajawal(
                    fontSize: 20,
                    color: ui.Color.fromARGB(255, 24, 25, 25),
                    fontWeight: FontWeight.bold),
              ),
            ),

            content: SingleChildScrollView(
              // child: Directionality(

              // textDirection: ui.TextDirection.rtl,

              child: ListBody(
                children: <Widget>[
                  Icon(
                    Icons.health_and_safety,
                    size: 35,
                    color: ui.Color.fromARGB(255, 111, 161, 200),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  Center(
                    child: Text(x!,
                        style: GoogleFonts.tajawal(
                            fontSize: 18,
                            color: ui.Color.fromARGB(255, 99, 163, 206),
                            fontWeight: FontWeight.bold)),
                  ),

                  SizedBox(
                    height: 15,
                  ),

//                   Container(

//                       alignment: Alignment.topLeft,

//                       child: GestureDetector(

//                         onTap: () async {

//                           //??

//

//                           if (widget.audioPlayer.state == PlayerState.playing) {

//                             TextToSpeechAPI().AppShowToast(

//                                 text: "يرجى الانتضار حتى انتهاء الامر السابق");

//                             return;

//                           }

//                           //  function  to call the api but it in any button action it will work

//                           setState(() {

//                             TextToSpeechAPI().isPlaying = widget.doc;

//                           });

//                           TextToSpeechAPI().playVoice(

//                               widget.doc,

//                               " تفاصيل الجرعة " +

//                                   " الكمية " +

//                                   widget.MedAmount +

//                                   " " +

//                                   widget.MedUnit +

//                                   " الوقت " +

//                                   " " +

//                                   widget.time +

//                                   " " +

//                                   widget.meddescription,

//                               widget.audioPlayer);

//                           // .then((value) => {

//                           //       widget.audioPlayer.onPlayerComplete

//                           //           .listen((event) {

//                           //         setState(() {

//                           //           TextToSpeechAPI().isPlaying = "";

//                           //         });

//                           //       })

//                           //     });

//                           widget.audioPlayer.onPlayerComplete.listen((event) {

//                             setState(() {

//                               TextToSpeechAPI().isPlaying = "";

//                             });

//                           });

//

//                            */

//                           //         /*٫playVoice(" تفاصيل الجرعة " +

//                           //             " الكمية " +

//                           //             widget.MedAmount +

//                           //             " " +

//                           //             widget.MedUnit +

//                           //             " الوقت " +

//                           //             " " +

//                           //             widget.time +

//                           //             " " +

//                           //             widget.meddescription, AudioPlayer());*/

//                           //         // print("مرحبا بك ");

//                         },

//                         child: Icon(

//                           TextToSpeechAPI().isPlaying != widget.doc

//                               ? Icons.volume_mute

//                               : Icons.volume_up,

//                           color: Color.fromARGB(255, 111, 161, 200),

//                           size: 30,

//                         ),

//                       )),

                  Center(
                    child: Text(widget.MedAmount + ' ' + widget.MedUnit,
                        style: GoogleFonts.tajawal(
                            fontSize: 15,
                            color: ui.Color.fromARGB(255, 81, 99, 110),
                            fontWeight: FontWeight.bold)),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Center(
                    child: Text(" الساعة ${widget.time}  ",
                        style: GoogleFonts.tajawal(
                            fontSize: 15,
                            color: ui.Color.fromARGB(255, 81, 99, 110),
                            fontWeight: FontWeight.bold)),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Center(
                    child: Text('${widget.meddescription}',
                        style: GoogleFonts.tajawal(
                            fontSize: 15,
                            color: ui.Color.fromARGB(255, 81, 99, 110),
                            fontWeight: FontWeight.bold)),
                  ),

                  SizedBox(
                    height: 22,
                  ),

                  Center(
                    child: Text(
                      'هل تم أخذ الدواء ؟',
                      style: GoogleFonts.tajawal(
                          fontSize: 22,
                          color: ui.Color.fromARGB(255, 24, 25, 25),
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(
                    height: 18,
                  ),
                ],
              ),

              // ),
            ),

            actions: <Widget>[
              //  Directionality(

              //  textDirection: ui.TextDirection.rtl,

              TextButton(
                child: Text('ليس بعد',
                    style: GoogleFonts.tajawal(
                        fontSize: 18,
                        color: ui.Color.fromARGB(255, 24, 25, 25),
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  //Navigator.of(context).pop();

                  Navigator.of(context).pop();
                },
              ),

              //  ),

              //  Directionality(

              // textDirection: ui.TextDirection.rtl,

              TextButton(
                  child: Text('نعم',
                      style: GoogleFonts.tajawal(
                          fontSize: 18,
                          color: ui.Color.fromARGB(255, 24, 25, 25),
                          fontWeight: FontWeight.bold)),

                  // onPressed: () {

                  //Navigator.of(context).pop();

                  onPressed: widget.checked
                      ? null
                      : () {
                          FirebaseFirestore.instance
                              .collection('doses')
                              .doc(widget.doc)
                              .update({'cheked': true});

                          if (widget.send) {
                            // if edited by the patient

                            FirebaseFirestore.instance
                                .collection('doses')
                                .doc(widget.doc)
                                .update({'Timecheked': DateTime.now()});
                          }

                          if (diff == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    ' "تم أخذ الجرعة على الموعد تماما " ',
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.right),
                              ),
                            );
                          } else if (diff > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    ' " تم أخذ الجرعة قبل الموعد ب ${diff.abs()} دقائق" ',
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.right),
                              ),
                            );
                          } else if (diff < 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    ' " تم أخذ الجرعة بعد الموعد ب ${diff.abs()} دقائق" ',
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.right),
                              ),
                            );
                          }

                          Navigator.of(context).pop();
                        }),

              //),
            ],

            // ),
          );
        },
      );
    }

    // var x = DateTime.now();

    // String format = DateFormat('yyy-MM-dd - kk:mm').format(x);

    // String format2 =

    //     DateFormat('yyy-MM-dd - kk:mm').format(widget.timechecked.toDate());

    // print(format);

    // print(format2);

    // print(x == widget.timechecked.toDate());

    // print(x);

    // print(widget.timechecked.toDate());

    // print('herree');

    // if (format == format2 && widget.send == false) {

    //   nv.sendNotificationchecked2(' جرعة ${widget.medicName} ');

    // }

    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        //  child: SizedBox(width: 130 ,height:15, child: DecoratedBox(decoration: BoxDecoration(color: Colors.red))),

        decoration: BoxDecoration(),

        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          child: SizedBox(
            width: 130,

            height: 225,

            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(0.0),

                child: Column(
                  children: [
                    // ],
                    // )

                    //  ),
                    //  ),
                    // ),

                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Material(
                          borderRadius: BorderRadius.circular(20.0),

                          //RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),

                          // shape: Border(

                          //shape: const BorderRadius.all(Radius.circular(20.0)),

                          // top: BorderSide(  color: Color(widget.medColor), width: 20 ,),

                          // ),

                          //borderRadius: BorderRadius.all(Radius.circular(20.0),),

                          elevation: 7,
                          color: Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
                              child: Column(
                                children: [
                                  Container(
                                    width: 1000,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Color(widget.medColor)
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  Row(children: [
                                    Container(
                                        child: Column(
                                      children: [
                                        MaterialButton(
                                          onPressed: null,
                                          color: ui.Color.fromARGB(
                                              255, 183, 221, 243),
                                          child: widget.checked
                                              ? Icon(
                                                  Icons.check_outlined,
                                                  size: 30,
                                                  color: ui.Color.fromARGB(
                                                      255, 81, 212, 81),
                                                )
                                              : Icon(
                                                  Icons.close,
                                                  size: 30,
                                                  color: ui.Color.fromARGB(
                                                      255, 245, 4, 4),
                                                ),
                                          padding: EdgeInsets.all(16),
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  width: 5,
                                                  style: BorderStyle.solid,
                                                  color: Color.fromARGB(
                                                      255, 140, 167, 190))),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )),

                                    // if(widget.checked == true){

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Container(
                                      child: Container(
                                          child: Column(
                                        children: [
                                          // SizedBox(height: 7,width:30),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '   ' +
                                                    '\n' +
                                                    '${widget.medicName}' +
                                                    "    ",
                                                style: GoogleFonts.tajawal(
                                                    fontSize: 17,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),

                                              // button for audio google api

                                              //change the button style to be like the app style
                                            ],
                                          ),

                                          Text(
                                            '   ' +
                                                '\n' +
                                                ' تفاصيل الجرعة:' +
                                                '\n' +
                                                '   ' +
                                                'الوقت: ' +
                                                '${widget.time}' +
                                                '\n' +
                                                '   ' +
                                                'الكمية: ' +
                                                '${widget.MedAmount}' +
                                                '\n' +
                                                '   ' +
                                                'الوحدة: ' +
                                                '${widget.MedUnit}' +
                                                '\n',
                                            style: GoogleFonts.tajawal(
                                                fontSize: 15,
                                                color: ui.Color.fromARGB(
                                                    255, 83, 87, 87),
                                                fontWeight: FontWeight.w600),
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),

                                          Row(children: [
                                            Text(
                                              '${widget.medDate}',
                                              style: GoogleFonts.tajawal(
                                                  fontSize: 15,
                                                  color: ui.Color.fromARGB(
                                                      255, 5, 187, 8),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.history,
                                              color: Colors.grey,
                                            )
                                          ]),

                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )),
                                    ),

                                    // }

                                    SizedBox(width: 15),

                                    SizedBox(
                                      child: Image.asset(
                                          widget.picture.toString(),
                                          height: 70,
                                          width: 70),
                                    ),

                                    // image here
                                  ]),
                                ],
                              ))),
                    ),

                    SizedBox(
                      height: 0,
                    ),

                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                          color: Colors.green,
                          width: 5,
                        )),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,

                            offset: const Offset(
                              1.0,
                              1.0,
                            ), //Offset

                            blurRadius: 15.0,

                            spreadRadius: 2.0,
                          ), //BoxShadow

                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                      ), //BoxDecoration
                    ),
                  ],
                ), //Container
              ), //Padding
            ), //Center
          ),
        ), //SizedBox
      ),
    );
  }
}
