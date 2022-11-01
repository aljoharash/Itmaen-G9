import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/Notes/editNote.dart';
import 'dart:ui' as ui;
import 'AppStyle.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(doc['color']),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // DateTime dateTime = documents[i].data["duedate"].toDate();

                doc["creation_date"],
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                doc["note_title"],
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                doc["note_content"],
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 50,
              ),
              Builder(
                builder: (context) => Row(children: [
                  GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => editNote(
                                title: doc["note_title"],
                                note: doc["note_content"],
                                type: doc["type"],
                                photo: doc["photo"]
                              )));
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () async {
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
                                        style: GoogleFonts.tajawal(),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        var collectionNotes = FirebaseFirestore
                                            .instance
                                            .collection('Notes');
                                        var snapshotNotes =
                                            await collectionNotes
                                                .where(
                                                  "note_title",
                                                  isEqualTo: doc["note_title"],
                                                )
                                                .where("caregiverID",
                                                    isEqualTo: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid)
                                                .get();

                                        for (var doc in snapshotNotes.docs) {
                                          await doc.reference.delete();
                                        }
                                        ;
                                      },
                                      child: Text(
                                        "نعم",
                                        style: GoogleFonts.tajawal(),
                                      ),
                                    ),
                                  ],
                                  content: Text(
                                    "هل أنت متأكد من رغبتك في حذف الملاحظة؟",
                                    style: GoogleFonts.tajawal(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                  )));
                    },
                  ),
                  SizedBox(
                    width: 60,
                  ),
                    Container(
                      height: 40,
                      width: 40,                      
                    child: doc['photo'] == " " ? SizedBox()
                    : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(doc['photo']),
                  ),

                  )
                ]),
              ),
            ],
          ),
        ),
      ));
}
