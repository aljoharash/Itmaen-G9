import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itmaen/generateqr.dart';
import 'package:itmaen/secure-storage.dart';

class AddPatient extends StatefulWidget {
  @override
  _AddPatient createState() => _AddPatient();
}

class _AddPatient extends State<AddPatient> {

  final TextEditingController nameController = TextEditingController(); 
  StorageService st = StorageService(); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("إضافة مريض")),
      ),
      body: Column(children: [
        SizedBox(height:50)
        ,Text(
          'من فضلك قم بإدخال اسم المريض',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 118, 176, 186)),
          
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
          child: ElevatedButton(
            onPressed:()  {
              // String? id = await st.readSecureData("caregiverID");
              FirebaseFirestore.instance.collection('patients').add({'name': nameController.text, 'caregiverID':'123'});
              // FirebaseFirestore.instance.collection('patients').add({'caregiverID': '123'});
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GenerateQR()));
            },
            child: Text(
              "إضافة ",
              style: TextStyle(
                  color: Color.fromARGB(255, 245, 244, 244),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ]),
    );
  }
}
