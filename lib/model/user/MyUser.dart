/// Author : Ben NDUI
/// Company : Smooth and Design
/// Current File : Class User
/// Comments : This class allows you to manage users data easy from the database

import 'package:flutter/material.dart';

class MyUser {
  ///User attibutes
  final String? uid, name, email, phone, location;

  ///__Constructor
  MyUser(this.uid, this.name, this.email, this.phone, this.location);



  /// Return user name
  getName() => this.name;

  /// Return user lastname
  getLastName() => this.email;

  /// Return user birthday
  getBirthDate() => this.phone;

  /// Return user location like (Nice, Lyon, Paris etc..) different than Zone
  getLocation() => this.location;

  /// Convertir en Map Json notre objet Utilisateur
  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'location': this.location
    };
  }

  /// Convert a Map object to a user object
  factory MyUser.fromMap(Map<String, dynamic> map) {
    return new MyUser(map['uid'], map['name'], map['email'],map['phone'], map['location']);
  }
}
