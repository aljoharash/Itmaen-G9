import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor:  Colors.white,
        color: Color.fromARGB(255, 140, 167, 190) ,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index){
          //page index
        },
        items: [
          Icon(Icons.person_add, color: Colors.white,),
          Icon(Icons.list , color: Colors.white,),
          Icon(Icons.add , color: Colors.white,),
          Icon(Icons.home , color: Colors.white,),
        ],



      ),

    );

  }
}