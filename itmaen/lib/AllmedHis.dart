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

import 'ViewChecked.dart';
import 'ViewCheckedDaily.dart';
import 'ViewCheckedMonthly.dart';
import 'ViewCheckedWeekly.dart';
import 'ViewNotChecked.dart';
import 'ViewNotCheckedDaily.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({Key? key}) : super(key: key);

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController.animateTo(2);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: loggedInUser == null ? false : true,

        leading: IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Navigation())),
            icon: Icon(Icons.arrow_back)),

        backgroundColor: Color.fromARGB(255, 140, 167, 190),

        title: Center(
            child: Text(" الجرعات السابقة  ",
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold))),
      ),
      backgroundColor:  Color.fromARGB(255, 248, 249, 250),
      // appBar: AppBar(
      //   title: Text('Tab bar Without Appbar'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 25),
                Container(
                  // height: 50,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 249, 250),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: TabBar(
                          isScrollable: true,
                          unselectedLabelColor: Color.fromARGB(255, 70, 69, 69),
                          labelColor: Color.fromARGB(255, 248, 245, 245),
                          indicatorColor: Colors.white,
                          indicatorWeight: 2,
                          indicator: BoxDecoration(
                            color: Color.fromARGB(255, 140, 167, 190),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          controller: tabController,
                          tabs: [
                            Tab(
                                child: Row(
                              children: [
                                //SizedBox(width: 2,),
                                Text(' لم يتم أخذها  ',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    // ignore: prefer_const_constructors
                    children: [NestedTabBar2(), NestedTabBar3(),NestedTabBar()],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;
  @override
  void initState() {
    super.initState();
    _nestedTabController = new TabController(length:4 , vsync: this);
    _nestedTabController.animateTo(2);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
                  // height: 50,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 249, 250),
                      borderRadius: BorderRadius.circular(20)),
   child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Color.fromARGB(255, 140, 167, 190),
          labelColor:  Color.fromARGB(255, 140, 167, 190),
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
               Tab(
                child: Row(
              children: [
                //SizedBox(width: 2,),
              Text('  قبل ذلك  ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
               
              ],
            )),
            Tab(
                child: Row(
              children: [
                //SizedBox(width: 2,),
              Text('   طوال الشهر الماضي   ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
               
              ],
            )),
            Tab(
                child: Row(
              children: [
               Text('  طوال الأسبوع الماضي  ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                //         SizedBox(
                //   width: 5,
                // ),
                
              ],
            )),
            Tab(
                child: Row(
              children: [
                Text('   مؤخرا   ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 5,
                ),
               
              ],
            )),
          ],
        ),
        Container(
         height: screenHeight * 0.90,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: TabBarView(
            controller: _nestedTabController,
            children: [ViewAll(),ViewAllMonthly(), ViewAllWeekly(), ViewAllDaily()],
          ),
        )
      ],
    )
    );
  }
}


class NestedTabBar2 extends StatefulWidget {
  @override
  _NestedTabBar2State createState() => _NestedTabBar2State();
}

class _NestedTabBar2State extends State<NestedTabBar2>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;
  @override
  void initState() {
    super.initState();
    _nestedTabController = new TabController(length:4 , vsync: this);
    _nestedTabController.animateTo(2);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
                  // height: 50,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 249, 250),
                      borderRadius: BorderRadius.circular(20)),
   child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Color.fromARGB(255, 140, 167, 190),
          labelColor:  Color.fromARGB(255, 140, 167, 190),
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
             Tab(
                child: Row(
              children: [
                //SizedBox(width: 2,),
              Text('  قبل ذلك  ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
               
              ],
            )),
            Tab(
                child: Row(
              children: [
                //SizedBox(width: 2,),
               Text('   طوال الشهر الماضي   ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
               
              ],
            )),
            Tab(
                child: Row(
              children: [
               Text('  طوال الأسبوع الماضي  ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                //         SizedBox(
                //   width: 5,
                // ),
                
              ],
            )),
            Tab(
                child: Row(
              children: [
                Text('   مؤخرا   ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 5,
                ),
               
              ],
            )),
          ],
        ),
        Container(
         height: screenHeight * 0.90,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: TabBarView(
            controller: _nestedTabController,
            children: [ViewNotAllCheck(), ViewNotAllCheckMonthly(), ViewNotAllCheckWeekly(), ViewNotAllCheckDaily()],
          ),
        )
      ],
    )
    );
  }
}



class NestedTabBar3 extends StatefulWidget {
  @override
  _NestedTabBar3State createState() => _NestedTabBar3State();
}

class _NestedTabBar3State extends State<NestedTabBar3>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;
  @override
  void initState() {
    super.initState();
    _nestedTabController = new TabController(length:4, vsync: this);
    _nestedTabController.animateTo(2);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
                  // height: 50,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 249, 250),
                      borderRadius: BorderRadius.circular(20)),
   child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: Color.fromARGB(255, 140, 167, 190),
          labelColor:  Color.fromARGB(255, 140, 167, 190),
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
             Tab(
                child: Row(
              children: [
                //SizedBox(width: 2,),
              Text('  قبل ذلك  ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
               
              ],
            )),
            Tab(
                child: Row(
              children: [
                //SizedBox(width: 2,),
                Text('   طوال الشهر الماضي   ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
               
              ],
            )),
            Tab(
                child: Row(
              children: [
                Text('  طوال الأسبوع الماضي  ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                //         SizedBox(
                //   width: 5,
                // ),
                
              ],
            )),
            Tab(
                child: Row(
              children: [
                Text('   مؤخرا   ',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 5,
                ),
               
              ],
            )),
          ],
        ),
        Container(
         height: screenHeight * 0.90,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: TabBarView(
            controller: _nestedTabController,
            children: [ViewAllCheck(),ViewAllCheckMonthly(), ViewAllCheckWeekly(), ViewAllCheckDaily()],
          ),
        )
      ],
    )
    );
  }
}
