import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/ViewAllDosesDaily.dart';
import 'package:itmaen/ViewAllDosesMonthly.dart';
import 'package:itmaen/ViewAllDosesWeekly.dart';
import 'package:itmaen/ViewNotCheckedMonthly.dart';
import 'package:itmaen/ViewNotCheckedWeekly.dart';
import 'package:itmaen/navigation.dart';
import 'package:itmaen/viewD.dart';
import 'package:itmaen/view.dart';
import 'package:itmaen/viewAlldoses.dart';

import 'AllmedHis.dart';
import 'ViewChecked.dart';
import 'ViewCheckedDaily.dart';
import 'ViewCheckedMonthly.dart';
import 'ViewCheckedWeekly.dart';
import 'ViewNotChecked.dart';
import 'ViewNotCheckedDaily.dart';


class MyTabbedPage extends StatelessWidget {
  const MyTabbedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provides a TabController for TabBar and TabBarView
    return 
    Scaffold(body:DefaultTabController(
      length: 3,
      initialIndex:2,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // The flexible app bar with the tabs
          SliverAppBar(
            title: Center(
            child: Text(" الجرعات السابقة  ",
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold))),
            expandedHeight: 100,
            pinned: true,
            leading: IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Navigation(data: 4,))),
            icon: Icon(Icons.arrow_back)),

        backgroundColor: Color.fromARGB(255, 140, 167, 190),
            forceElevated: innerBoxIsScrolled,
            bottom: TabBar( isScrollable: true,
            //backgroundColor:Color.fromARGB(255, 140, 167, 190),
                          unselectedLabelColor: Color.fromARGB(255, 248, 249, 250),
                          labelColor: Color.fromARGB(255, 140, 167, 190),
                          indicatorColor:Color.fromARGB(255, 140, 167, 190),
                          indicatorWeight: 2,
                          indicator: BoxDecoration(
                            color:Color.fromARGB(255, 248, 249, 250),
                            borderRadius: BorderRadius.circular(25),
                            border:Border.all(color:Color.fromARGB(255, 140, 167, 190), width:3)),
              tabs: [
             Tab(
                                child: Row(
                              children: [
                                //SizedBox(width: 2,),
                                Text(' لم يتم أخذها ',
                                    style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold)),
                                Icon(
                                  Icons.close,
                                  color: Color.fromARGB(255, 228, 68, 40),
                                ),
                              ],
                            )),
                            Tab(
                                child: Row(
                              children: [
                                Text(' تم أخذها   ',
                                    style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold)),
                                //         SizedBox(
                                //   width: 5,
                                // ),
                                Icon(
                                  Icons.check,
                                  color: Color.fromARGB(255, 40, 228, 131),
                                ),
                              ],
                            )),
                            Tab(
                                child: Row(
                              children: [
                                Text('    الكل     ',
                                    style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.list,
                                  color: Color.fromARGB(255, 184, 186, 187),
                                ),
                              ],
                            )),
            ]),
          )
        ],
        // The content of each tab
        body: TabBarView(
          children: [NestedTabBar2(), NestedTabBar3(),NestedTabBar()],
        ),
      ),
    )
    );
  }
}
