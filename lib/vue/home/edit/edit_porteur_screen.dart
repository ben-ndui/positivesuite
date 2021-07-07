import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:positivesuite/common/Constants.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/user/MyUser.dart';

class EditPorteur extends StatefulWidget {
  final MyUser? user;
  final porteur;

  const EditPorteur({Key? key, this.user, this.porteur}) : super(key: key);

  @override
  _EditPorteurState createState() => _EditPorteurState();
}

class _EditPorteurState extends State<EditPorteur> {
  bool? _isChecked;

  var _editFormKeyPositiveur = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var qpController = TextEditingController();
  var commentsController = TextEditingController();
  var activitiesController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isChecked = widget.porteur['qp'] == 'Oui' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: GestureDetector(onTap: (){
        Navigator.of(context).pop();
      },child: Icon(Icons.arrow_back_ios_rounded, color: Colors.deepPurpleAccent,)), backgroundColor: Colors.transparent, elevation: 0.0,),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          background(),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            child: Text(
              "Modifier les infos de \n ${widget.porteur['name']}",
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
            child: SingleChildScrollView(child: editPorteurForm(widget.porteur)),
          )),
        ],
      ),
    );
  }

  /// Formulaire de modification d'un porteur
  Container editPorteurForm(porteur) {
    bool checked = false;
    const double padding = 30.0;

    return Container(
      width: 500.0,
      padding:
          EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0, bottom: 20.0),
      decoration: boxDecoration(Colors.white, 30.0),
      child: Form(
        key: _editFormKeyPositiveur,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: TextFormField(
                obscureText: false,
                controller: nameController..text = porteur['name'],
                validator: (value) =>
                    value!.isEmpty ? "Nom du porteur de projet" : null,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_circle_sharp),
                  labelText: porteur['name'] != null
                      ? '${porteur['name']}'
                      : 'Nom du porteur ?',
                ),
              ),
            ),
            SizedBox(
              height: padding,
            ),
            Center(
              child: TextFormField(
                obscureText: false,
                controller: activitiesController..text = porteur['activities'],
                validator: (value) => value!.isEmpty ? "Activité(s)" : null,
                decoration: InputDecoration(
                  labelText: porteur['activities'] != null
                      ? 'Activité(s) : ${porteur['activities']}'
                      : 'Activité(s) ?',
                  icon: Icon(Icons.work),
                ),
              ),
            ),
            SizedBox(
              height: padding,
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
                      _isChecked = !_isChecked!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: TextFormField(
                obscureText: false,
                controller: commentsController..text = porteur['comments'],
                validator: (value) => value!.isEmpty ? "Commentaires" : null,
                decoration: InputDecoration(
                  labelText: porteur['comments'] != null
                      ? 'Commentaire : ${porteur['comments']}'
                      : 'Commentaires',
                  icon: Icon(Icons.drive_file_rename_outline),
                ),
              ),
            ),
            SizedBox(
              height: padding,
            ),
            Container(
              padding: EdgeInsets.only(
                left: padding,
                right: padding,
              ),
              margin: EdgeInsets.only(top: 4),
              child: TextButton(
                onPressed: () async {
                  if (_editFormKeyPositiveur.currentState!.validate()) {
                    final _auth = DatabaseService(uid: widget.user!.uid);

                    var name = nameController.value.text;
                    var qp = _isChecked! ? "Oui" : "Non";
                    var comments = commentsController.value.text;
                    var activities = activitiesController.value.text;

                    /// CONNECTION WITH FIREBASE RIGHT HER
                    _auth
                        .updatePorteur(widget.user!.uid, name, qp, 0, comments,
                            activities, false)
                        .then((value) => Navigator.of(context).pop());
                  }
                },
                child: Text(
                  "Enregistrer",
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
}
