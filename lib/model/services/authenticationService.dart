import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/model/user/Porteur.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Transform Firebase User to my own MyUser object
  MyUser? _userFromFirebaseUser(User? user){
    return user != null ? MyUser(user.uid, user.displayName, user.email, user.phoneNumber, '') : null;
  }

  Stream<MyUser?> get user => _auth.authStateChanges().map(_userFromFirebaseUser);

  Future signIn(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  /// Register
  Future signUp(String? name, String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      await user!.updateDisplayName(name).then((value) => DatabaseService(uid: user.uid).saveUser(user.uid, name, user.email, user.phoneNumber, ""));

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  /// Save user information
  Future update(String? name, String? phone, String? location, String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      await user!.updateDisplayName(name);
      await user.updateEmail(email);

      await DatabaseService(uid: user.uid).updateUserinfo(user.uid, name, user.email, phone, location);

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  /// Signing out
  Future<void> signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print("SignOut ERROR" + e.toString());
      return null;
    }
  }
}
