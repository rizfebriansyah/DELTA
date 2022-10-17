import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore databaseReference = FirebaseFirestore.instance;

abstract class BaseLeave {
  Future retrieveLeaves();
  Future insertLeave(String from, String to, String title, String userid);
  Future updateLeave(String id, String from, String to, String title);
}

class Leave implements BaseLeave {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future retrieveLeaves() async {
    var ref = await databaseReference.collection("LeaveRequest").get();
    ref.docs.forEach((element) {
      var d = element.data();
    });
  }

  Future insertLeave(
      String from, String to, String title, String userid) async {
    var ref = await databaseReference.collection("LeaveRequest");
    ref.add({"user": userid, "title": title, "from": from, "to": to});
  }

  Future updateLeave(String id, String from, String to, String title) async {
    var ref = await databaseReference.collection("LeaveRequest");
    ref.doc(id).update({"title": title, "from": from, "to": to});

  }
}
