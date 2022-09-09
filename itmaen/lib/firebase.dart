import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(
    var username1, var email, var pass, var mobileNum) async {
  CollectionReference caregivers =
      FirebaseFirestore.instance.collection('caregivers');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? uid = auth.currentUser?.uid.toString();
  caregivers.add({
    'user name': username1,
    'email': email,
    'password': pass,
    'mobileNum': mobileNum,
    'uid': uid
  });
  return;
}
