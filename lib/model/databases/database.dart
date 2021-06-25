import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/model/user/Porteur.dart';

class DatabaseService {
  var uid;

  /// Collection user
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  DatabaseService({this.uid});

  /// Save user
  Future<void> saveUser(String? uid, String? name, String? email, String? phone,
      String? location) async {
    return await userCollection.doc(uid).set(
      {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
      },
    );
  }

  Future<void> updateUserinfo(String? uid, String? name, String? email, String? phone,
      String? location) async {
    return await userCollection.doc(uid).update(
      {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
      },
    );
  }

  /// Save user
  Future<void> savePositiveur(String? uid, String? name, String? email, String? phone,
      String? location,  var nbLike, var comments, var activities, var monConseiller, var portrait) async {
    final CollectionReference userPositiveurs = FirebaseFirestore.instance.collection("users").doc(uid).collection("positiveurs");

    return await userPositiveurs.doc(name).set(
      {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'nbLike': nbLike,
        'comments': comments,
        'activities': activities,
        'monConseiller': monConseiller,
        'portrait':portrait,
      },
    );
  }

  MyUser _userFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);
    return MyUser(userData["uid"], userData["name"], userData["email"],
        userData["phone"], userData["location"]);
  }

  Porteur _porteurFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);
    return Porteur(userData["uid"], userData["name"], userData["email"],
        userData["phone"], userData["location"], userData["nbLike"], userData["comments"], userData["activities"], userData["monConseiller"], userData["portrait"]);
  }

  /// Stream to get current user
  Stream<MyUser> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<MyUser>> get allUser {
    return userCollection.snapshots().map(_userListFromSnapShot);
  }

  /// Stream list to get all user positiveurs
  Stream<List<Porteur>> get allUserPositiveurs {
    return userCollection.doc(uid).collection("positiveurs").snapshots().map(_porteurListFromSnapShot);
  }

  /// Stream to get current user positiveurs
  Stream<QuerySnapshot> getPorteurs() {
    return userCollection.doc(uid).collection('positiveurs').orderBy('name').snapshots();
  }

  List<MyUser> _userListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _userFromSnapShot(doc)).toList();
  }

  List<Porteur> _porteurListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _porteurFromSnapShot(doc)).toList();
  }
}
