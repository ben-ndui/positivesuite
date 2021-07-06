/// Author : Ben NDUI
/// Company : Smooth and Design
/// Current File : Class Porteur
/// Comments : This class allows you to manage Porteur data easily from the database

import 'package:flutter/material.dart';
import 'package:positivesuite/model/user/MyUser.dart';

class Porteur extends MyUser {
  var nbLike, comments, activities, portrait;
  bool? zone;

  /// __Constructor
  Porteur(var uid, var name, var qp, var comments,
      var activities, var portrait)
      : super(
          uid,
          name,
          "",
          "",
          qp,
        ) {
    this.nbLike = nbLike;
    this.comments = comments;
    this.activities = activities;
    this.portrait = portrait;
  }

  /// Return the Porteur likes on this profile
  getNbLike() => this.nbLike;

  /// Return comments on this Porteur
  getComments() => this.comments;

  /// Return this Porteur activities
  getActivity() => this.activities;

  /// This return a boolean
  /// Just to let you know if this Porteur already have a pdf presentation or non
  /// in our system
  getPortrait() => this.portrait;

  /// This return a boolean
  /// To let you know if this Porteur location is risky or not
  getZone() => this.zone;
}
