import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:positivesuite/common/Constants.dart';
import 'package:positivesuite/common/myLoader.dart';
import 'package:positivesuite/common/porteur_list.dart';
import 'package:positivesuite/common/users_list.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/services/authenticationService.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/vue/home/edit/edit_user_profile.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final MyUser? user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var qpController = TextEditingController();
  var nbLikeController = TextEditingController();
  var commentsController = TextEditingController();
  var activitiesController = TextEditingController();
  var portraitController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    qpController.dispose();
    nbLikeController.dispose();
    commentsController.dispose();
    activitiesController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState!.reset();
      nameController.text = '';
      qpController.text = '';
      nbLikeController.text = '';
      activitiesController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: myAppBar(widget.user),
      body: orientation == Orientation.portrait
          ? SingleChildScrollView(child: portraitDisplay())
          : landScapeDisplay(),
    );
  }

  Stack portraitDisplay() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        background(),
        Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Mes Porteurs de projet",
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: mesPositiveursList(),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Tous les membres",
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200.0,
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: listMembres(),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Ajouter un porteur de projet",
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            formulairePositiveur(),
          ],
        ),
      ],
    );
  }

  Center background() {
    return Center(
      child: SvgPicture.asset(
        "assets/backgrounds/login_background.svg",
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        fit: BoxFit.cover,
      ),
    );
  }

  Container landScapeDisplay() {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                "assets/backgrounds/login_background.svg",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                firstPanel(),
                leftPanel(),
                rightPanel(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding rightPanel() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: membreConnectee(),
      ),
    );
  }

  Column membreConnectee() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Membre(s) connecté(e)s',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          width: 300.0,
          height: 580.0,
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
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

  Padding firstPanel() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ajouter un porteur Favorie',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(
              height: 20.0,
            ),
            formulairePositiveur(),
          ],
        ),
      ),
    );
  }

  Container formulairePositiveur() {
    return Container(
      width: 400.0,
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Form(
          key: _formKey,
          child: Column(
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
                    icon: Icon(Icons.drive_file_rename_outline),
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
                  validator: (value) =>
                  value!.length < 6 ? "Activité(s)" : null,
                  decoration: InputDecoration(
                    labelText: 'Activité(s) du porteur',
                    icon: Icon(Icons.drive_file_rename_outline),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: TextFormField(
                  obscureText: false,
                  controller: qpController,
                  validator: (value) =>
                      value!.length < 6 ? "QP ?" : null,
                  decoration: InputDecoration(
                    labelText: 'QP ?',
                    icon: Icon(Icons.drive_file_rename_outline),
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
                  validator: (value) =>
                      value!.length < 6 ? "Commentaires" : null,
                  decoration: InputDecoration(
                    labelText: 'Commentaires',
                    icon: Icon(Icons.drive_file_rename_outline),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                ),
                margin: EdgeInsets.only(top: 4),
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final _auth = DatabaseService(uid: widget.user!.uid);

                      var name = nameController.value.text;
                      var qp = qpController.value.text;
                      var comments = commentsController.value.text;
                      var activities = activitiesController.value.text;

                      /// CONNECTION WITH FIREBASE RIGHT HER
                      _auth.savePorteur(
                          widget.user!.uid,
                          name,
                          qp,
                          0,
                          comments,
                          activities,
                          false);
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
        child: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService(uid: widget.user!.uid).getPorteurs(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return MyLoader();
            return PorteursList();
          },
        ),
      ),
    );
  }

  AppBar myAppBar(MyUser? user) {
    return AppBar(
      title: Text("Positive + "),
      centerTitle: true,
      elevation: 0.0,
      leading: Icon(Icons.menu_rounded),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          "${user!.name}",
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Text("${user.email}"),
                      ],
                    ),
                    Icon(
                      Icons.account_circle,
                      size: 40.0,
                      color: Colors.deepPurpleAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Center(
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditUserProfile(
                    user: widget.user,
                  ),
                ),
              );
            },
            icon: Center(
              child: Icon(
                Icons.edit,
                size: 20.0,
                color: Colors.white,
              ),
            ),
            label: Text(""),
          ),
        ),
        Center(
          child: TextButton.icon(
            onPressed: () {
              final _auth = AuthenticationService();
              _auth.signOut();
            },
            icon: Icon(
              Icons.logout,
              size: 20.0,
              color: Colors.white,
            ),
            label: Text(""),
          ),
        ),
      ],
    );
  }
}
