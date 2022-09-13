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
        title: Center(child: Text("إضافة مستقبل الرعاية", style: TextStyle(fontFamily: 'Madani Arabic Black'),)),
      ),
      body: Column(children: [
        SizedBox(height:50),
        Padding(
              padding: EdgeInsets.all(30),
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child:Text(
          'من فضلك قم بإدخال اسم مستقبل الرعاية : ',
          style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 118, 176, 186),
              fontFamily: 'Madani Arabic Black'),
          
        ),),)
        ,
        SizedBox(height: 50),
        Container(
          height: 200,
          width: 400,
          child:Padding(
              padding: EdgeInsets.all(30),
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child:TextFormField(
              textAlign: TextAlign.center,
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'اسم مستقبل الرعاية',
               labelStyle: TextStyle(fontSize: 20, ),
              
                
              ),
               //textAlign: TextAlign.center,
                //textAlign: TextAlign.right,
            ),
          ),
        ),
        ),
       // Center(
 Padding(
              padding: EdgeInsets.all(30),
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child:Container(
                      height: 80,
                      width: double.infinity,
                      padding:
                      const EdgeInsets.only(top: 25, left: 24, right: 24),
                      child: MaterialButton(
                      elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.blueGrey,
            onPressed:()  {
              // String? id = await st.readSecureData("caregiverID");
              if(nameController.text.length>=2){
              FirebaseFirestore.instance.collection('patients').add({'name': nameController.text, 'caregiverID':caregiverID});
              // FirebaseFirestore.instance.collection('patients').add({'caregiverID': '123'});
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GenerateQR()));
                  }
                  else{
                     ScaffoldMessenger.of(context).showSnackBar(
                      
                              const SnackBar(
                               // margin: EdgeInsets.only(right: 10),
                                
                                content: Text(
                                  
                                    'يجب أن يحتوي اسم مستقبل الرعاية على حرفين أو أكثر ',
                                    style: TextStyle(fontSize: 20),
                                    textAlign:TextAlign.right),
                                    
                              ),
                     );
                  }
            },
            child: Text(
              "إضافة ",
                 style: TextStyle(
                  color: Color.fromARGB(255, 245, 244, 244),
                  fontSize: 25,
                  fontFamily: 'Madani Arabic Black'),
                  textAlign: TextAlign.center,
            ),
          ),
                  ),
              ),
        ),
      ]),
    );
  }
}
