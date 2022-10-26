import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/navigation.dart';
import 'package:itmaen/viewD.dart';
import 'package:itmaen/view.dart';
import 'package:itmaen/viewAlldoses.dart';

import 'ViewChecked.dart';
import 'ViewNotChecked.dart';

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

           leading: IconButton(onPressed: ()=>  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Navigation())), 
           icon: Icon(Icons.arrow_back)),

            backgroundColor: Color.fromARGB(255, 140, 167, 190),

            title: Center(child:Text(" تاريخ الجرعات ",

                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold))),

          ),
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Tab bar Without Appbar'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  // height: 50,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 248, 249, 250),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: TabBar(
                          unselectedLabelColor: Color.fromARGB(255, 70, 69, 69),
                          labelColor: Color.fromARGB(255, 248, 245, 245),
                          indicatorColor: Colors.white,
                          indicatorWeight: 2,
                          indicator: BoxDecoration(
                            color: Color.fromARGB(255, 140, 167, 190),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          controller: tabController,
                          tabs: [
                            
                             Tab(
                                  child: Row(
                              children: [
                               
                                //SizedBox(width: 2,),
                                Text('لم يتم أخذها',
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
                               
                                 
                                Text('تم أخذها',
                                    style: GoogleFonts.tajawal(
                                        fontWeight: FontWeight.bold)),
                                        SizedBox(
                                  width: 5,
                                ),
                                 Icon(
                                  Icons.check,
                                  color: Color.fromARGB(255, 40, 228, 131),
                                ),
                               
                              ],
                            )),
                           
                             Tab(
                                child: Row(
                              children: [
                                
                             
                                Text('    الكل',
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
                    children: [ViewNotAllCheck(), ViewAllCheck(), ViewAll()],
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
