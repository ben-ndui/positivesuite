import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/model/user/Porteur.dart';

class DatabaseService {
  var uid;
  final FirebaseFirestore _f_instance = FirebaseFirestore.instance;

  /// Collection user
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  /// Collection user
  final CollectionReference porteurCollection =
      FirebaseFirestore.instance.collection("porteurs");

  DatabaseService({this.uid});

  /// Permet de récupérer les donnée de n'importe quel collection de firebase
  Future getUsersFromFirebase(String collection) async {
    QuerySnapshot snapshot = await _f_instance.collection(collection).get();

    return snapshot.docs;
  }

  /// Permet de récupérer les positiveurs de l'utilisateur courant
  getPositiveurDataFrom(String? userThatYouLookingFor) async {
    var data = await _f_instance
        .collection("users")
        .doc(uid)
        .collection("positiveurs")
        .where("name", isEqualTo: userThatYouLookingFor)
        .get();

    return data.docs;
  }

  Future queryData(String? queryString) async {
    return porteurCollection.where('name', isEqualTo: queryString).get();
  }

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
        'searchKey': name!.substring(0, 1),
      },
    );
  }

  /// Like a porter
  Future<bool> likePorteur(String? name, String? whoLike, bool? like, bool toggle) async {
    if(toggle){
      porteurCollection.doc(name).update({'nbLike': like});
      await porteurCollection.doc(name).collection("like").doc(whoLike).set({
        'uid': uid,
        'name': whoLike,
      });
      return true;
    }
    porteurCollection.doc(name).update({
      'nbLike': like
    });
    await porteurCollection.doc(name).collection("like").doc(whoLike).delete();
    return false;
  }

  Future<bool> unLikePorteur(String? name, String? whoLike, bool? like) async {
    porteurCollection.doc(name).update({
      'nbLike': like
    });
    await porteurCollection.doc(name).collection("like").doc(whoLike).delete();
    return false;
  }

  Stream<QuerySnapshot> getNbPorteurLike(String name){
    return porteurCollection.doc(name).collection('like').snapshots();
  }

  Future<void> updateUserinfo(String? uid, String? name, String? email,
      String? phone, String? location) async {
    return await userCollection.doc(uid).update(
      {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'searchKey': name!.substring(0, 1),
      },
    );
  }

  /// Save user
  Future<void> savePorteur(
    String? uid,
    String? name,
    var qp,
    int? nbLike,
    String? comments,
    String? activities,
    bool? portrait,
  ) async {
    return await porteurCollection.doc(name).set(
      {
        'uid': uid,
        'name': name,
        'qp': qp,
        'nbLike': nbLike,
        'comments': comments,
        'activities': activities,
        'portrait': portrait,
        'searchKey': activities!.substring(0, 1).toUpperCase(),
      },
    );
  }

  /// Update Porteur infos
  Future<void> updatePorteur(
    String? uid,
    String? name,
    var qp,
    int? nbLike,
    String? comments,
    String? activities,
    bool? portrait,
  ) async {
    return await porteurCollection.doc(name).update(
      {
        'uid': uid,
        'name': name,
        'qp': qp,
        'nbLike': nbLike,
        'comments': comments,
        'activities': activities,
        'portrait': portrait,
        'searchKey': activities!.substring(0, 1).toUpperCase(),
      },
    );
  }

  MyUser _userFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);
    return MyUser(userData["uid"], userData["name"], userData["email"],
        userData["phone"], userData["location"]);
  }

  Porteur _porteurFromSnapShot(DocumentSnapshot snapshot) {
    final porteur = (snapshot.data() as dynamic);
    //print("From Database services " + porteur["name"]);
    return Porteur(
      porteur["uid"],
      porteur["name"],
      porteur["qp"],
      porteur["comments"],
      porteur["activities"],
      porteur["portrait"],
    );
  }

  /// Stream to get current user
  Stream<MyUser> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapShot);
  }

  /// Stream to get current user
  Stream<Porteur> get porteur {
    return porteurCollection.doc(uid).snapshots().map(_porteurFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<MyUser>> get allUser {
    return userCollection.snapshots().map(_userListFromSnapShot);
  }

  /// Stream list to get all user positiveurs
  Stream<List<Porteur>> get allPorteurs {
    return porteurCollection.snapshots().map(_porteurListFromSnapShot);
  }

  /// Stream to get current user positiveurs
  Stream<QuerySnapshot> getPorteurs() {
    return porteurCollection.where('uid', isEqualTo: uid).snapshots();
  }

  /// Stream to get current user positiveurs
  Stream<QuerySnapshot> getAllPorteurs(String? name) {
    return porteurCollection
        .where("searchKey", isEqualTo: name!.substring(0, 1).toUpperCase())
        .snapshots();
  }

  searchByName(searchField) {
    return _f_instance
        .collection('porteurs')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }

  searchByUserName(searchField) {
    return _f_instance
        .collection('users')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }

  List<MyUser> _userListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _userFromSnapShot(doc)).toList();
  }

  List<Porteur> _porteurListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _porteurFromSnapShot(doc)).toList();
  }
}
