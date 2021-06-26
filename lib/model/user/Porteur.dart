/// Author : Ben NDUI
/// Company : Smooth and Design
/// Current File : Class Porteur
/// Comments : This class allows you to manage Porteur data easily from the database

import 'package:flutter/material.dart';
import 'package:positivesuite/model/user/MyUser.dart';

class Porteur extends MyUser {
  String? uid, name, email, phone, location;
  var nbLike, comments, activities, monConseiller, portrait;
  bool? zone;

  /// __Constructor
  Porteur(
      String? uid,
      String? name,
      String? email,
      String? phone,
      String? location,
      var nbLike,
      var comments,
      var activities,
      var monConseiller,
      var portrait)
      : super(
          uid,
          name,
          email,
          phone,
          location,
        ) {
    this.nbLike = nbLike;
    this.comments = comments;
    this.activities = activities;
    this.monConseiller = monConseiller;
    this.portrait = portrait;
  }

  /// Return the Porteur likes on this profile
  getNbLike() => this.nbLike;

  /// Return comments on this Porteur
  getComments() => this.comments;

  /// Return this Porteur activities
  getActivity() => this.activities;

  /// Return this Porteur Conseiller
  /// "This porteur is manage by (Conseiller)"
  getMonConseiller() => this.monConseiller;

  /// This return a boolean
  /// Just to let you know if this Porteur already have a pdf presentation or non
  /// in our system
  getPortrait() => this.portrait;

  /// This return a boolean
  /// To let you know if this Porteur location is risky or not
  getZone() => this.zone;
}
