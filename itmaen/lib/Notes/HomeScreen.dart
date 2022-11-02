import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../setting.dart';
import 'AppStyle.dart';
import 'NoteEditorScreen.dart';
import 'NoteReaderScreen.dart';
import 'note_card.dart';
import 'addNotes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String caregiverID = "";
  late User loggedInUser;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getCurrentUser();
    print("caregiverID");
    print(caregiverID);
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser.uid;
        print("inside" + caregiverID);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Directionality(
            textDirection: ui.TextDirection.rtl,
            //debugShowCheckedModeBanner: false,
            child: Scaffold(
              drawer: NavBar(),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 140, 167, 190),
                title: Center(
                    child: Text(
                  " ملاحظاتي ",
                  style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                )),
              ),
              body: SafeArea(
                  child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      // padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("Notes")
                                  .where('caregiverID',
                                      isEqualTo: _auth.currentUser?.uid)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasData) {
                                  return GridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                    ),
                                    children: snapshot.data!.docs
                                        .map((note) => noteCard(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        NoteReaderScreen(note),
                                                  ));
                                            }, note))
                                        .toList(),
                                  );
                                }
/*

    Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => editNote(
                                title: doc["note_title"],
                                note: doc["note_content"],
                                type: doc["type"],
                              )));
                    },
                  ),
 */

                                return Text(
                                  "لايوجد ملاحظات",
                                  style:
                                      GoogleFonts.nunito(color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ],
                      ))),
              floatingActionButton: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => addNote()));
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(15),
                  //backgroundColor: Color.fromARGB(255, 140, 167, 190),
                  primary: Color.fromARGB(255, 140, 167, 190),
                  surfaceTintColor: Color.fromARGB(255, 84, 106, 125),
                ),
              ),
            )));
  }
}
