import 'package:cloud_firestore/cloud_firestore.dart';
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
                doc["note_title"],
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                doc["creation_date"],
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
              Builder(
              builder: (context) => 
              Row(
                children: [
                GestureDetector(
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => editNote(
                      title: doc["note_title"] ,
                      note: doc["note_content"] ,
                      type: doc["type"],
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
                onTap: (){
                 
                },

              ),
              ]

              ),
             
              ),
            ],
          ),
        ),
      ));
}
