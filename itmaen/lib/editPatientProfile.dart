import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itmaen/generateqr.dart';
import 'package:itmaen/navigation.dart';
import 'package:itmaen/secure-storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EditPatientProfile extends StatefulWidget {
  List<String> data; 
  EditPatientProfile({Key? key , required this.data}):super(key: key);

  @override
  _EditPatientProfile createState() => _EditPatientProfile(this.data);
}

class _EditPatientProfile extends State<EditPatientProfile> {
 List<String> data; 
  _EditPatientProfile(this.data);
  final _auth = FirebaseAuth.instance;
  late User? loggedInUser = _auth.currentUser;
  String caregiverID = "";
  var _query;

  //User? loggedInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<String> getName() async {
    await FirebaseFirestore.instance
        .collection('patients')
        .where("caregiverID", isEqualTo: loggedInUser!.uid)
        .get()
        .then((value) {
      _query = value.docs[0].get('name');
    });
    return _query;
  }

  void getCurrentUser() async {
    //String qrData="";
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        caregiverID = loggedInUser!.uid;
        _query = await getName();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _isCollectionExits() async {
    QuerySnapshot<Map<String, dynamic>> _query = await FirebaseFirestore
        .instance
        .collection('patients')
        .where("caregiverID", isEqualTo: caregiverID)
        .get();

    if (_query.docs.isNotEmpty) {
      // Collection exits
      return true;
    } else {
      // Collection not exits
      return false;
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  StorageService st = StorageService();
  @override
  Widget build(BuildContext context) {
    nameController.text = data[0];
    ageController.text = data[1];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Navigation()),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 140, 167, 190),
        title: Center(
            child: Text(
          " تعديل",
          style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
        )),
      ),
      body: Column(children: [
        //SizedBox(height: 30),
       
        Padding(
          padding: EdgeInsets.all(30),
          child: Directionality(
              textDirection: TextDirection.rtl,
              child: QrImage(data: loggedInUser!.uid, size: 150)),
        ),
          Center(
        child: Text(
          ": بيانات مستقبل الرعاية",
          style: GoogleFonts.tajawal(fontSize: 25,
                color: Color.fromARGB(255, 140, 167, 190),
                fontWeight: FontWeight.bold,),
        )),
      SizedBox(height: 20),
        Container(
         // height: 110,
          width: 400,
        //  child: Padding(
           // padding: EdgeInsets.all(30),
           child:
             Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
                
                textAlign: TextAlign.center,
                controller: nameController,
                
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'الاسم ',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),

                //textAlign: TextAlign.center,
                //textAlign: TextAlign.right,
              ),
           // ),
          ),
       ),
       SizedBox(height:30),
        Container(
         // height: 110,
          width: 400,
         // child: Padding(
          //  padding: EdgeInsets.all(30),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextFormField(
               keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: ageController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '  العمر  (اختياري)',
                  labelStyle: TextStyle(
                    fontSize: 20,
                  ),
                ),

                //textAlign: TextAlign.center,
                //textAlign: TextAlign.right,
              ),
           // ),
          ),
        ),

        // Center(
        Padding(
          padding: EdgeInsets.all(30),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: 80,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 25, left: 24, right: 24),
              child: MaterialButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color.fromARGB(255, 140, 167, 190),
                onPressed: () async {
                  RegExp r1 = new RegExp(r'^["@$&^)(*&£%!?><_+]');
                  RegExp r = new RegExp(r'\s');
                  if (r.hasMatch(nameController.text)|| r.hasMatch(ageController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        // margin: EdgeInsets.only(right: 10),

                        content: Text('يرجى عدم وضع فراغات بالحقول ',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.right),
                      ),
                    );
                  }
                  else if(r1.hasMatch(nameController.text)){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        // margin: EdgeInsets.only(right: 10),

                        content: Text('يرجى عدم وضع رموز غريبة',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.right),
                      ),
                    );
                  }
                  // String? id = await st.readSecureData("caregiverID");
                  else if ((nameController.text.length >= 2 &&
                      nameController.text.length <= 20) && (ageController.text.length<=3)) {
                   
                    var id;
                    await FirebaseFirestore.instance
                        .collection('patients')
                        .where("caregiverID", isEqualTo: loggedInUser!.uid)
                        .get()
                        .then((value) {
                      id = value.docs[0].id;
                    });
                    FirebaseFirestore.instance
                        .collection('patients')
                        .doc(id)
                        .update(
                      {
                        'name': nameController.text,
                        'caregiverID': loggedInUser!.uid,
                        'age': ageController.text
                      },
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        // margin: EdgeInsets.only(right: 10),

                        content: Text('تم حفظ التعديلات بنجاح',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.right),
                      ),
                    );

                    // FirebaseFirestore.instance.collection('patients').add({'caregiverID': '123'});
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Navigation()));
                  }
                  // }
                  else {
                    if (nameController.text.length < 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          // margin: EdgeInsets.only(right: 10),

                          content: Text(
                              'يجب أن يحتوي اسم مستقبل الرعاية على حرفين أو أكثر ',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.right),
                        ),
                      );
                    } else if (nameController.text.length >= 20) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          // margin: EdgeInsets.only(right: 10),

                          content: Text(
                              'يجب أن يحتوي اسم مستقبل الرعاية على أقل من عشرين حرف  ',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.right),
                        ),
                      );
                    }
                    else if (ageController.text.length >= 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          // margin: EdgeInsets.only(right: 10),

                          content: Text(
                              'لا يجب أن يحتوي عمر مستقبل الرعاية على اكثر من ثلاثة أرقام    ',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.right),
                        ),
                      );
                    }

                  }
                },
                child: Text(
                  "حفظ",
                  style: GoogleFonts.tajawal(
                    color: Color.fromARGB(255, 245, 244, 244),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
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
