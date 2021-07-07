import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:positivesuite/common/Constants.dart';
import 'package:positivesuite/common/myLoader.dart';
import 'package:positivesuite/common/porteur_list.dart';
import 'package:positivesuite/common/users_list.dart';
import 'package:positivesuite/common/users_porteurs_tile.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/services/authenticationService.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/model/user/Porteur.dart';
import 'package:positivesuite/vue/home/add/add_porteur_screen.dart';
import 'package:positivesuite/vue/home/edit/edit_porteur_screen.dart';
import 'package:positivesuite/vue/profile/profile_widget.dart';
import 'package:provider/provider.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:positivesuite/vue/profile/profile_widget.dart';

class EditProfilWidget extends StatefulWidget {
  final MyUser? user;

  EditProfilWidget({Key? key, this.user}) : super(key: key);

  @override
  _EditProfilWidgetState createState() => _EditProfilWidgetState();
}

class _EditProfilWidgetState extends State<EditProfilWidget> {
  TextEditingController? activitiesTextFieldController;
  TextEditingController? emailTextFieldController;
  TextEditingController? nameTextFieldController;
  TextEditingController? phoneTextFieldController;
  TextEditingController? antenneTextFieldController;
  TextEditingController? passwordTextFieldController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool? isNull = false;
  String? userID;

  var _formKeyPositiveur = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var locationController = TextEditingController();
  var nbLikeController = TextEditingController();
  var commentsController = TextEditingController();
  var activitiesController = TextEditingController();
  var portraitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    activitiesTextFieldController = TextEditingController();
    emailTextFieldController = TextEditingController();
    nameTextFieldController = TextEditingController();
    phoneTextFieldController = TextEditingController();
    antenneTextFieldController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nameTextFieldController!.dispose();
    emailTextFieldController!.dispose();
    phoneTextFieldController!.dispose();
    antenneTextFieldController!.dispose();

    nameController.dispose();
    locationController.dispose();
    nbLikeController.dispose();
    commentsController.dispose();
    activitiesController.dispose();
    portraitController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState!.reset();
      nameTextFieldController!.text = '';
      emailTextFieldController!.text = '';
      phoneTextFieldController!.text = '';
      antenneTextFieldController!.text = '';
    });
  }

  fetchUserInfo() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userID = getUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFEEEEEE),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, 1.16),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  'assets/images/profile_back.svg',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    child: Align(
                      alignment: orientation == Orientation.portrait
                          ? Alignment.topCenter
                          : Alignment.center,
                      child: Container(
                        width: 240,
                        height: 240,
                        margin: EdgeInsets.only(
                          top: 50.0,
                        ),
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: Icon(
                                            Icons.arrow_back_ios_rounded,
                                            color: Color(0xFFFF3A72),
                                            size: 30,
                                          ),
                                          iconSize: 30,
                                        ),
                                        Text("Retour")
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _showMyDialog();
                                          },
                                          icon: Icon(
                                            Icons.group,
                                            color: Color(0xFF00DBF9),
                                            size: 30,
                                          ),
                                          iconSize: 30,
                                        ),
                                        Text("Teams")
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            myFavorites();
                                            //print('Edit profil');
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.heart,
                                            color: Color(0xFFFF3A72),
                                            size: 30,
                                          ),
                                          iconSize: 30,
                                        ),
                                        Text("Mes ❤️"),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.account_circle_rounded,
                                            color: Color(0xFFEB00EA),
                                            size: 30,
                                          ),
                                          iconSize: 30,
                                        ),
                                        Text("Mon profil")
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPorteur(user: widget.user,)));
                                    },
                                    icon: Icon(
                                      Icons.add_circle,
                                      color: Color(0xFF1CFFC5),
                                      size: 30,
                                    ),
                                    iconSize: 30,
                                  ),
                                  Text("Ajouter un Positiveur")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Align(
                    ///Formulaire modification infos perso
                    alignment: Alignment.center,
                    child: Center(
                      child: Container(
                        width: orientation == Orientation.portrait ? 325 : 650,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color(0xFFF2F2F2),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              child: Text(
                                "Modifier mes informations \n personnels",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 15.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              margin: EdgeInsets.all(20.0),
                            ),
                            StreamBuilder<MyUser>(
                                stream:
                                    DatabaseService(uid: widget.user!.uid).user,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final user = snapshot.data;
                                    return Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 20, 20, 20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 50.0,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      nameTextFieldController,
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? "Veuillez saisir votre nom d'utilisateur"
                                                      : null,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText: user!.name != null
                                                        ? user.name
                                                        : "Saisir mon nom et prénom",
                                                    hintStyle: FlutterFlowTheme
                                                        .title3
                                                        .override(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16.0,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black12,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(1),
                                                        bottomRight:
                                                            Radius.circular(1),
                                                        topLeft:
                                                            Radius.circular(1),
                                                        topRight:
                                                            Radius.circular(1),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(1),
                                                        bottomRight:
                                                            Radius.circular(1),
                                                        topLeft:
                                                            Radius.circular(1),
                                                        topRight:
                                                            Radius.circular(1),
                                                      ),
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.title3
                                                      .override(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16.0,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      emailTextFieldController,
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? "Veuillez saisir votre adresse email"
                                                      : null,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText: user.email != null
                                                        ? user.email
                                                        : "Saisir mon adresse email",
                                                    hintStyle: FlutterFlowTheme
                                                        .title3
                                                        .override(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16.0,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black12,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(1),
                                                        bottomRight:
                                                            Radius.circular(1),
                                                        topLeft:
                                                            Radius.circular(1),
                                                        topRight:
                                                            Radius.circular(1),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(1),
                                                        bottomRight:
                                                            Radius.circular(1),
                                                        topLeft:
                                                            Radius.circular(1),
                                                        topRight:
                                                            Radius.circular(1),
                                                      ),
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.title3
                                                      .override(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16.0,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      phoneTextFieldController,
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? "Veuillez saisir votre numéro de téléphone"
                                                      : null,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText: user.phone != null
                                                        ? user.phone
                                                        : "Saisir mon numéro de téléphone",
                                                    hintStyle: FlutterFlowTheme
                                                        .title3
                                                        .override(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16.0,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black12,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(1),
                                                        bottomRight:
                                                            Radius.circular(1),
                                                        topLeft:
                                                            Radius.circular(1),
                                                        topRight:
                                                            Radius.circular(1),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(1),
                                                        bottomRight:
                                                            Radius.circular(1),
                                                        topLeft:
                                                            Radius.circular(1),
                                                        topRight:
                                                            Radius.circular(1),
                                                      ),
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.title3
                                                      .override(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16.0,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                TextFormField(
                                                  controller:
                                                      antenneTextFieldController,
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? "Veuillez saisir votre antenne PPF"
                                                      : null,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText: user
                                                            .location!.isEmpty
                                                        ? "Saisir le nom de mon antenne PPF"
                                                        : user.location!.trim(),
                                                    hintStyle: FlutterFlowTheme
                                                        .title3
                                                        .override(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16.0,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black12,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(1),
                                                        bottomRight:
                                                            Radius.circular(1),
                                                        topLeft:
                                                            Radius.circular(1),
                                                        topRight:
                                                            Radius.circular(1),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(1),
                                                        bottomRight:
                                                            Radius.circular(1),
                                                        topLeft:
                                                            Radius.circular(1),
                                                        topRight:
                                                            Radius.circular(1),
                                                      ),
                                                    ),
                                                  ),
                                                  style: FlutterFlowTheme.title3
                                                      .override(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 16.0,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          StreamBuilder<MyUser>(
                                              stream: DatabaseService(
                                                      uid: widget.user!.uid)
                                                  .user,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return FFButtonWidget(
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        var name =
                                                            nameTextFieldController!
                                                                .value.text;
                                                        var email =
                                                            emailTextFieldController!
                                                                .value.text;
                                                        var phone =
                                                            phoneTextFieldController!
                                                                .value.text;
                                                        var location =
                                                            antenneTextFieldController!
                                                                .value.text;

                                                        await DatabaseService(
                                                                uid: widget
                                                                    .user!.uid)
                                                            .updateUserinfo(
                                                                widget
                                                                    .user!.uid,
                                                                name,
                                                                email,
                                                                phone,
                                                                location)
                                                            .whenComplete(
                                                              () => AlertDialog(
                                                                content: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Text("Enregistré"),
                                                                    Icon(Icons.check_circle_rounded, color: Colors.lightGreen,),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                      }
                                                      //print('EnregistrerButton pressed ...');
                                                    },
                                                    text: 'Enregistrer',
                                                    options: FFButtonOptions(
                                                      width: 130,
                                                      height: 40,
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                      textStyle:
                                                          FlutterFlowTheme
                                                              .title3
                                                              .override(
                                                        fontFamily: 'Poppins',
                                                        color: Colors.white,
                                                      ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        width: 1,
                                                      ),
                                                      borderRadius: 12,
                                                    ),
                                                  );
                                                } else {
                                                  return MyLoader();
                                                }
                                              }),
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return MyLoader();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField([
    String? unString,
    String? errorMessage,
    String? validMessage,
    TextEditingController? controller,
    String? fieldType,
    bool obscured = false,
  ]) {
    setState(() {
      controller = TextEditingController();
    });
    return TextFormField(
      controller: controller,
      validator: (value) => value!.isEmpty ? errorMessage : null,
      obscureText: obscured,
      decoration: InputDecoration(
        hintText: unString != null ? unString : validMessage,
        hintStyle: FlutterFlowTheme.title3.override(
          fontFamily: 'Poppins',
          fontSize: 16.0,
          fontStyle: FontStyle.italic,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(1),
            bottomRight: Radius.circular(1),
            topLeft: Radius.circular(1),
            topRight: Radius.circular(1),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.deepPurpleAccent,
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(1),
            bottomRight: Radius.circular(1),
            topLeft: Radius.circular(1),
            topRight: Radius.circular(1),
          ),
        ),
      ),
      style: FlutterFlowTheme.title3.override(
        fontFamily: 'Poppins',
        fontSize: 16.0,
      ),
      textAlign: TextAlign.start,
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            child: const Text(
              'PPF Teams',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              child: membreConnectee(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> myFavorites() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            child: const Text(
              'Mes coups de coeurs',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: 300.0,
              height: 400.0,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: DatabaseService(uid: widget.user!.uid).getPorteurs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return UserPorteurTile(
                            user: snapshot.data!.docs[index]);
                      },
                    );
                  else
                    return MyLoader();
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addPositiveur() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            child: const Text(
              'Ajouter \n un coup de coeur',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: firstPanel(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Column membreConnectee() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: 500.0,
          height: 500.0,
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: listMembres(),
        ),
      ],
    );
  }

  Container listMembres() {
    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: StreamProvider<List<MyUser>>.value(
        value: DatabaseService().allUser,
        initialData: [],
        child: UsersList(),
      ),
    );
  }

  Container mesPositiveursList() {
    return Container(
      height: 580.0,
      alignment: Alignment.center,
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: StreamProvider<List<Porteur>>.value(
          initialData: [],
          value: DatabaseService(uid: widget.user!.uid).allPorteurs,
          child: PorteursList(),
        ),
      ),
    );
  }

  Expanded leftPanel() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mes Positiveurs + ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              SizedBox(
                height: 20.0,
              ),
              mesPositiveursList(),
            ],
          ),
        ),
      ),
    );
  }

  Center firstPanel() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
          ),
          formulairePositiveur(),
        ],
      ),
    );
  }

  Container formulairePositiveur() {
    return Container(
      width: 500.0,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Form(
          key: _formKeyPositiveur,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: TextFormField(
                  obscureText: false,
                  controller: nameController,
                  validator: (value) =>
                  value!.isEmpty ? "Nom du porteur de projet" : null,
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_circle_sharp),
                    labelText: 'Nom du porteur',
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: TextFormField(
                  obscureText: false,
                  controller: activitiesController,
                  validator: (value) => value!.isEmpty ? "Activité(s)" : null,
                  decoration: InputDecoration(
                    labelText: 'Activité(s) du porteur',
                    icon: Icon(Icons.work),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: TextFormField(
                  obscureText: false,
                  controller: locationController,
                  validator: (value) => value!.isEmpty ? "QP ?" : null,
                  decoration: InputDecoration(
                    labelText: 'QP ?',
                    icon: Icon(Icons.location_city),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: TextFormField(
                  obscureText: false,
                  controller: commentsController,
                  validator: (value) => value!.isEmpty ? "Commentaires" : null,
                  decoration: InputDecoration(
                    labelText: 'Commentaires',
                    icon: Icon(Icons.drive_file_rename_outline),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                ),
                margin: EdgeInsets.only(top: 4),
                child: TextButton(
                  onPressed: () async {
                    if (_formKeyPositiveur.currentState!.validate()) {
                      final _auth = DatabaseService(uid: widget.user!.uid);

                      var name = nameController.value.text;
                      var activities = activitiesController.value.text;
                      var qp = locationController.value.text;
                      var comments = commentsController.value.text;

                      /// CONNECTION WITH FIREBASE RIGHT HER
                      _auth
                          .savePorteur(widget.user!.uid, name, qp, 0,
                          comments, activities, false)
                          .then((value) => Navigator.of(context).pop());
                    }
                  },
                  child: Text(
                    "Ajouter",
                    style: TextStyle(
                      color: kprimaryColor,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
