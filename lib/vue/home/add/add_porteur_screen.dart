import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:positivesuite/common/Constants.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/user/MyUser.dart';

class AddPorteur extends StatefulWidget {
  final MyUser? user;

  const AddPorteur({Key? key, this.user}) : super(key: key);

  @override
  _AddPorteurState createState() => _AddPorteurState();
}

class _AddPorteurState extends State<AddPorteur> {
  bool _isChecked = false;

  var _formKeyPositiveur = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var qpController = TextEditingController();
  var commentsController = TextEditingController();
  var activitiesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.deepPurpleAccent,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          background(),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: Text(
              "Ajouter un coup \n de coeur",
              style: TextStyle(
                color: Colors.deepPurpleAccent,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: addPorteurForm(context),
          )),
        ],
      ),
    );
  }

  /// Formulaire d'ajout d'un porteur
  Container addPorteurForm(BuildContext context) {
    return Container(
      width: 500.0,
      padding: EdgeInsets.all(10.0),
      decoration: boxDecoration(Colors.white, 20.0),
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
              height: 30.0,
            ),
            Row(
              children: [
                Icon(Icons.home_work),
                SizedBox(
                  width: 18.0,
                ),
                Text(
                  "QP ? ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Checkbox(
                  value: _isChecked,
                  onChanged: (value) {
                    setState(() {
                      _isChecked = !_isChecked;
                    });
                  },
                ),
              ],
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
                    var qp = _isChecked ? "Oui" : "Non";
                    var comments = commentsController.value.text;
                    var activities = activitiesController.value.text;

                    /// CONNECTION WITH FIREBASE RIGHT HER
                    _auth
                        .savePorteur(widget.user!.uid, name, qp, 0, comments,
                            activities, false)
                        .then((value) => Navigator.of(context).pop());
                    _formKeyPositiveur.currentState!.reset();
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

  BoxDecoration boxDecoration(Color? colors, double? radius) {
    return BoxDecoration(
      color: colors,
      borderRadius: BorderRadius.circular(radius!),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 5.0, spreadRadius: 2.0),
        BoxShadow(color: Colors.white60, blurRadius: 5.0, spreadRadius: 2.0),
      ],
    );
  }
}
