import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'generateqr.dart';
import 'login.dart';
import 'scanqr.dart';

class HomePage extends StatefulWidget {
@override
_HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

@override
Widget build(BuildContext context) {
	return Scaffold(
    appBar: AppBar(
		title: Center(child: Text("إطمئن")),

    // actions: <Widget>[
      //    MaterialButton(
        //    child: Text('Log Out',style: TextStyle(fontSize: 18,color: Colors.white),),
          //  color: Colors.blue,
            //onPressed: () async{
             // await FirebaseAuth.instance.signOut();
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            //}
          //),
       // ],
	),
	
	body: Container(
		width: 200,
		height: 200,
    
		child: Column(
		mainAxisAlignment: MainAxisAlignment.center,
		crossAxisAlignment: CrossAxisAlignment.stretch,
		children: [
			//Display Image
			// Image(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQyYwscUPOH_qPPe8Hp0HAbFNMx-TxRFubpg&usqp=CAU")),
			// Center(
			// //First Button
			// child:ElevatedButton(
			
			// onPressed: (){
			// 	Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ScanQR()));
			// },
			// 	child: Text("مسح الكود", style: TextStyle(color: Color.fromARGB(255, 245, 244, 244), fontSize: 15 , fontWeight:FontWeight.bold ),textAlign: TextAlign.center,),
			// // shape: RoundedRectangleBorder(
			// // 	borderRadius: BorderRadius.circular(20),
			// // 	side: BorderSide(color: Color.fromARGB(255, 122, 130, 215)),
			// // ),
			// ),
      // ),
			SizedBox(height: 10),

			//Second Button
      Center(
			child:ElevatedButton(
        
			
			onPressed: (){
				Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
															GenerateQR()));
			},
			child: Text("إضافة مريض", style: TextStyle(color: Color.fromARGB(255, 245, 244, 244), fontSize: 15 , fontWeight:FontWeight.bold ),textAlign: TextAlign.center,),
			
			),
      )
		],
		),
	)
	);
}
}

