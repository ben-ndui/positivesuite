import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/model/user/MyUser.dart';

class Database {
  var uid;

  /// Collection user
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Database({this.uid});

  /// Save user
  Future<void> saveUser(
      String name, String lastname, String birthday, String location) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'lastname': lastname,
      'birthday': birthday,
      'location': location
    });
  }

  MyUser _userFromSnapShot(DocumentSnapshot snapshot) {
    return MyUser("", "", "");
  }

  /// Stream to get current user
  Stream<MyUser> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapShot);
  }

  List<MyUser> _userListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _userFromSnapShot(doc)).toList();
  }

  /// Stream list to get all user
  Stream<List<MyUser>> get allUser {
    return userCollection.snapshots().map(_userListFromSnapShot);
  }
}
