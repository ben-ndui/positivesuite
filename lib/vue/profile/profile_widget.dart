import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:positivesuite/common/myLoader.dart';
import 'package:positivesuite/common/porteur_list.dart';
import 'package:positivesuite/common/users_list.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/model/user/Porteur.dart';
import 'package:positivesuite/vue/details/porteur_details.dart';
import 'package:positivesuite/vue/edit_profil/edit_profil_widget.dart';
import 'package:positivesuite/vue/home/add/add_porteur_screen.dart';
import 'package:positivesuite/vue/home/component/splashScreen.dart';
import 'package:positivesuite/vue/home/edit/edit_porteur_screen.dart';
import 'package:provider/provider.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'landscape_profile_widget.dart';

class ProfileWidget extends StatefulWidget {
  final MyUser? user;

  ProfileWidget({Key? key, this.user}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? userMap;
  late TextEditingController searchController = TextEditingController();

  bool searchState = false;
  bool _visible = true;
  bool? _isChecked = false;
  bool? activities;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  var queryResultSet = [];
  var tempSearchStore = [];

  late AnimationController _controller;
  late Animation<double> _animation;
  late QuerySnapshot snapshotData;

  String temp = "";

  var nameController = TextEditingController();
  var lastNameController = TextEditingController();
  var qpController = TextEditingController();
  var nbLikeController = TextEditingController();
  var commentsController = TextEditingController();
  var activitiesController = TextEditingController();
  var monConseillerController = TextEditingController();

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.redAccent;
    }
    return Colors.redAccent;
  }

  initiateSearch(String value) {
    if (value.length <= 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizeValue = value.isNotEmpty
        ? value.substring(0, 1).toUpperCase() + value.substring(1)
        : "";

    if (queryResultSet.length == 0 && value.length == 1) {
      DatabaseService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; i++) {
          var use = docs.docs[i].data() as dynamic;
          setState(() {
            queryResultSet.add(use);
            _visible = !_visible;
          });
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach(
        (element) {
          if (capitalizeValue != null) {
            if (element['activities'].startsWith(capitalizeValue)) {
              setState(() {
                tempSearchStore.add(element);
              });
            }
          }
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10))
          ..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.text = "";
    searchController.dispose();

    nameController.dispose();
    qpController.dispose();
    nbLikeController.dispose();
    activitiesController.dispose();
    monConseillerController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _isChecked = !_isChecked!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    _controller.forward();

    return StreamBuilder<MyUser>(
        stream: DatabaseService(uid: widget.user!.uid).user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              key: scaffoldKey,
              backgroundColor: Color(0xFFEEEEEE),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  final _auth = FirebaseAuth.instance;
                  _auth.signOut();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                  //print('Deconnexion pressed ...');
                },
                backgroundColor: Colors.redAccent,
                elevation: 8,
                label: Text(
                  'Déconnexion',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.title2.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              body: SafeArea(
                child: orientation == Orientation.portrait
                    ? buildPortraitView()
                    : buildLandScapeView(),
              ),
            );
          } else {
            return MyLoader();
          }
        });
  }

  StreamBuilder buildPortraitView() {
    /// PORTRAIT VIEW
    return StreamBuilder<MyUser>(
      stream: DatabaseService(uid: widget.user!.uid).user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final currentUser = snapshot.data;
          return Stack(
            children: [
              background(),
              messageAccueil(currentUser!),
              menuBlock(context),
              buildFloatingSearchBar(),
            ],
          );
        } else {
          return MyLoader();
        }
      },
    );
  }

  ClipRRect searchResultContainer(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: tempSearchStore.map((e) {
            return GestureDetector(
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(
                      "${e['name']}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    content: Flex(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      direction: Axis.vertical,
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Activité(s) : ",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 14.0,
                              ),
                            ),
                            Text("${e['activities']}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Email : ",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 14.0,
                              ),
                            ),
                            Text("${e['email']}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Mobile : ",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 14.0,
                              ),
                            ),
                            Text("${e['phone']}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Location : ",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 14.0,
                              ),
                            ),
                            Text("${e['location']}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Suivi(e) par : ",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 14.0,
                              ),
                            ),
                            Text("${e['monConseiller']}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Text(
                              "Commentaires : ",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 14.0,
                              ),
                            ),
                            Text("${e['comments']}",
                                style: TextStyle(
                                  fontSize: 14.0,
                                )),
                          ],
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => callNumber(e['phone'] as String),
                        child: const Text('Appeller'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
              child: buildCard(e),
            );
          }).toList(),
        ),
      ),
    );
  }

  Container background() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        'assets/images/profile_back.svg',
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Align menuBlock(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 200,
        height: 150,
        margin: EdgeInsets.only(top: 50.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Color(0xFFCCCCCC),
              offset: Offset(0, 0),
              spreadRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: Alignment(-0.95, 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              myFavorites();
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
                        children: [
                          IconButton(
                            onPressed: () {
                              _showMyDialog();
                              //print('TeamButton pressed ...');
                            },
                            icon: Icon(
                              Icons.group,
                              color: Color(0xFF2A80FF),
                              size: 30,
                            ),
                            iconSize: 30,
                          ),
                          Text("Teams"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream: DatabaseService(uid: widget.user!.uid)
                                  .getPorteurs(),
                              builder: (context, snapshot) {
                                return IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => AddPorteur(
                                                  user: widget.user,
                                                )));
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.edit,
                                    color: Colors.redAccent,
                                    size: 30,
                                  ),
                                  iconSize: 30,
                                );
                              }),
                          Text("Ajouter")
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                            /// Profil button icon
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditProfilWidget(
                                        user: widget.user,
                                      )));
                              //print('Profil button pressed ...');
                            },
                            icon: Icon(
                              Icons.account_circle,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Container messageAccueil(MyUser currentUser) {
    return Container(
      /// Message d'accueil
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Bienvenue,",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 40.0,
              fontFamily: "Roboto",
            ),
            textAlign: TextAlign.left,
          ),
          Text(
            "${currentUser.name}",
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 18.0,
              fontFamily: "Roboto",
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 100.0),
    );
  }

  Align buildMySearchBar() {
    return Align(
      alignment: Alignment(0, 0),
      child: Container(
        width: 700,
        height: 70,
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: Image.asset(
              'assets/backgrounds/login_background.png',
            ).image,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black12,
              offset: Offset(0, 0),
              spreadRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(100),
        ),
        child: TextField(
          controller: searchController,
          obscureText: false,
          onChanged: (value) {
            initiateSearch(value);
          },
          decoration: InputDecoration(
            hintText: 'Chercher un utilisateur',
            hintStyle: FlutterFlowTheme.title2.override(
              fontFamily: 'Roboto',
              color: Color(0xFFCCCCCC),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepPurpleAccent,
                width: 1,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.deepPurpleAccent,
                width: 1,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
            ),
            prefixIcon: Icon(
              Icons.search,
            ),
          ),
          style: FlutterFlowTheme.title2.override(
            fontFamily: 'Roboto',
            color: Color(0xFFCCCCCC),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// ---------- LANDSCAPE VIEW ---------------
  Stack buildLandScapeView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: SvgPicture.asset(
            'assets/images/profile_back.svg',
            fit: BoxFit.contain,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Positive +",
                    style: TextStyle(
                      fontSize: 50.0,
                      fontFamily: 'Roboto',
                      color: Colors.black54,
                    ),
                  ),
                  StreamBuilder<MyUser>(
                    stream: DatabaseService(uid: widget.user!.uid).user,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return MyLoader();
                      final userCurrent = snapshot.data;
                      return Container(
                        margin: EdgeInsets.only(top: 10.0, left: 150.0),
                        child: Text(
                          "Bonjour, ${userCurrent!.name}",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Roboto',
                            color: Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 80.0),
                    width: 850,
                    height: 300,
                    child: buildFloatingSearchBar(),
                  ),
                  myMenuBar(),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildCard(data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(data['name']),
        leading: Icon(Icons.account_circle_sharp),
        subtitle: data != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("QP ? " + data['qp']),
                  Text("Activité : " + data['activities']),
                  Text("Commentaires : " + data['comments']),
                ],
              )
            : Container(
                child: Center(
                  child: Text("Chargement en cours.."),
                ),
              ),
      ),
    );
  }

  Container landScapeSearchBar() {
    return Container(
      padding: EdgeInsets.only(left: 30.0),
      child: Row(
        ///SEARCH BAR
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 600.0,
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 6.5,
                  right: 50.0,
                ),
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.0),
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/backgrounds/login_background.png',
                    ).image,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0,
                        spreadRadius: 2.0),
                    BoxShadow(
                        color: Colors.white60,
                        blurRadius: 5.0,
                        spreadRadius: 2.0),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  obscureText: false,
                  onChanged: (value) {
                    initiateSearch(value);
                  },
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    hintText: 'Chercher un utilisateur',
                    hintStyle: FlutterFlowTheme.title2.override(
                      fontFamily: 'Roboto',
                      color: Color(0xFFCCCCCC),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepPurpleAccent,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.deepPurpleAccent,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                  ),
                  style: FlutterFlowTheme.title2.override(
                    fontFamily: 'Roboto',
                    color: Color(0xFFCCCCCC),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          myMenuBar(),
        ],
      ),
    );
  }

  Container myMenuBar() {
    return Container(
      width: 80.0,
      height: 400.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  myFavorites();
                  //print('IconButton pressed ...');
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
          SizedBox(
            height: 35.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _showMyDialog();
                  //print('IconButton pressed ...');
                },
                icon: Icon(
                  Icons.group,
                  color: Color(0xFF2A80FF),
                  size: 30,
                ),
                iconSize: 30,
              ),
              Text("PPF Team️")
            ],
          ),
          SizedBox(
            height: 35.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  //print('HomeButton pressed ...');
                },
                icon: FaIcon(
                  FontAwesomeIcons.home,
                  color: Color(0xFF00DBF9),
                  size: 30,
                ),
                iconSize: 30,
              ),
              Text("Accueil️")
            ],
          ),
          SizedBox(
            height: 35.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                /// Profil button icon
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LandScapeProfileWidget(
                            user: widget.user,
                          )));
                  //print('Profil button pressed ...');
                },
                icon: Icon(
                  Icons.account_circle,
                  color: Color(0xFFEB00EA),
                  size: 30,
                ),
                iconSize: 30,
              ),
              Text("Mon profil️")
            ],
          )
        ],
      ),
      decoration: boxDecoration(Colors.white),
    );
  }


  AlertDialog _editPorteurView(BuildContext context, porteur) {
    return new AlertDialog(
      contentPadding: EdgeInsets.all(8.0),
      backgroundColor: Colors.white,
      elevation: 4.0,
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.deepPurpleAccent,
              height: 4.0,
            ),
            SizedBox(
              height: 4.0,
            ),
            Text("${porteur['name']}"),
            SizedBox(
              height: 4.0,
            ),
            Text("Activité : ${porteur['activities']}"),
            SizedBox(
              height: 4.0,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: DatabaseService().getNbPorteurLike(porteur['name']),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Text("Nombre de like : ${snapshot.data!.docs.length}")
                      : Text("");
                }),
            SizedBox(
              height: 4.0,
            ),
            Text("QP ? : ${porteur['qp']}"),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 20.0,
              child: Text("Commentaires"),
            ),
            Container(
              color: Colors.deepPurpleAccent,
              height: 4.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("${porteur['comments']}"),
          ],
        ),
      ),
    );
  }

  BoxDecoration boxDecoration(Color? colors) {
    return BoxDecoration(
      color: colors,
      borderRadius: BorderRadius.circular(100.0),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 5.0, spreadRadius: 2.0),
        BoxShadow(color: Colors.white60, blurRadius: 5.0, spreadRadius: 2.0),
      ],
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
          contentPadding: EdgeInsets.all(8.0),
          title: Container(
            width: 500.0,
            child: const Text(
              'Mes coups de coeurs',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: StreamBuilder<QuerySnapshot>(
              stream: DatabaseService(uid: widget.user!.uid).getPorteurs(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: 300,
                    height: 300,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditPorteur(
                                          user: widget.user,
                                          porteur: snapshot.data!.docs[index],
                                        ))),
                            child: _editPorteurView(
                                context, snapshot.data!.docs[index]));
                      },
                    ),
                  );
                } else
                  return MyLoader();
              },
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

  Future<void> displaySearch() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            child: const Text(
              'Résultat de la recherche',
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
                  stream: DatabaseService()
                      .getAllPorteurs(searchController.value.text),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final data =
                              snapshot.data!.docs[index].data() as dynamic;

                          return ListTile(
                            title: Text("${data['name']}"),
                            subtitle: Text("${data['email']}"),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
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
        child: StreamBuilder<List<Porteur>>(
          stream: DatabaseService().allPorteurs,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return MyLoader();
            return PorteursList();
          },
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

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Chercher un coup de coeur...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      borderRadius: BorderRadius.circular(100),
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : 0.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 800,
      height: 70,
      debounceDelay: const Duration(milliseconds: 50),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
        initiateSearch(query);
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tempSearchStore.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PorteurDetails(
                              user: widget.user,
                              porteur: tempSearchStore[index],
                            ),
                          ),
                        );
                      },
                      child: buildCard(tempSearchStore[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  callNumber(String number) async {
    const hidePhoneNumber = '#31#'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(hidePhoneNumber + number);
  }
}
