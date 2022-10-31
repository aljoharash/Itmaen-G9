import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'AppStyle.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Color(widget.doc['color']),
        appBar: AppBar(
          backgroundColor: Color(widget.doc['color']),
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Directionality(
            textDirection: ui.TextDirection.rtl,
            //  padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doc["note_title"],
                  style: AppStyle.mainTitle,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  "hh",
                  //  widget.doc["creation_date"],
                  style: AppStyle.dateTitle,
                ),
                SizedBox(
                  height: 28.0,
                ),
                Text(
                  widget.doc["note_content"],
                  style: AppStyle.mainContent,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ));
  }
}
