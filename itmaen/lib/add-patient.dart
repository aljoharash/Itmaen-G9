import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itmaen/generateqr.dart';
import 'package:itmaen/secure-storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPatient extends StatefulWidget {
  @override
  _AddPatient createState() => _AddPatient();
}

class _AddPatient extends State<AddPatient> {
  
  final _auth = FirebaseAuth.instance ; 
   String caregiverID="";
  late User loggedInUser; 
  @override
  void initState(){
    super.initState(); 
    getCurrentUser(); 
  }

  void getCurrentUser() async{
    //String qrData=""; 
    try{
      final user = await _auth.currentUser; 
      if(user!=null){
        loggedInUser = user ; 
        caregiverID=loggedInUser.uid ; 
      }
    }
    catch(e){
      print(e); 
    }
  }

  final TextEditingController nameController = TextEditingController(); 
  StorageService st = StorageService(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("إضافة مريض", style: TextStyle(fontFamily: 'Madani Arabic Black'),)),
      ),
      body: Column(children: [
        SizedBox(height:50)
        ,Text(
          'من فضلك قم بإدخال اسم المريض',
          style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 118, 176, 186),
              fontFamily: 'Madani Arabic Black'),
          
        ),
        SizedBox(height: 50),
        Container(
          height: 150,
          width: 150,
          
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'اسم المريض',
              ),
            ),
          ),
       
        Center(
          child: MaterialButton(
             elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        color: Colors.blueGrey,
            onPressed:()  {
              // String? id = await st.readSecureData("caregiverID");
              FirebaseFirestore.instance.collection('patients').add({'name': nameController.text, 'caregiverID':caregiverID});
              // FirebaseFirestore.instance.collection('patients').add({'caregiverID': '123'});
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GenerateQR()));
            },
            child: Text(
              "إضافة ",
              style: TextStyle(
                  color: Color.fromARGB(255, 245, 244, 244),
                  fontSize: 15,
                  fontFamily: 'Madani Arabic Black'),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ]),
    );
  }
}
