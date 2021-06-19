/// Author : Ben NDUI
/// Company : Smooth and Design
/// Current File : Class Conseiller
/// Comments : This class is extended from User, it can do the same things
/// but it had a speciality over here

import 'package:flutter/material.dart';

import 'MyUser.dart';
import 'Porteur.dart';

class Conseiller extends MyUser{
  List<Porteur> porteurList = [];
  final String antenne;

  ///__Constructor
  Conseiller({required this.antenne}) : super('', '', '');

  /// Return The Conseiller Team (PPF Nice, Lyon, Paris or others..)
  getAntenne() => this.antenne;

  /// Return this Conseiller Porteur list
  getListPorteur() => this.porteurList;
}