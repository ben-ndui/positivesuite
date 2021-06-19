import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/model/user/MyUser.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Transform Firebase User to my own MyUser object
  MyUser? _userFromFirebaseUser(User? user){
    return user != null ? MyUser(user.uid, user.displayName, user.email, user.phoneNumber, user.tenantId) : null;
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
  Future signUp(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
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
