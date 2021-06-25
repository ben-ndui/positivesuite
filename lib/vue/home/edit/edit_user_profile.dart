import 'package:flutter/material.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/services/authenticationService.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/vue/home/home.dart';
import 'package:provider/provider.dart';

class EditUserProfile extends StatefulWidget {
  final MyUser? user;

  const EditUserProfile({Key? key, this.user}) : super(key: key);

  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState!.reset();
      nameController.text = '';
      emailController.text = '';
      phoneController.text = '';
      locationController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    return Scaffold(
      appBar: myAppBar(widget.user),
      body: Center(
        child: Container(
          width: 800.0,
          height: 400.0,
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Enregistrer mon nom" : null,
                      textAlign: TextAlign.center,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom d\'utilisateur',
                        hintText: "${widget.user!.name}",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: TextFormField(
                      validator: (value) => value!.isEmpty
                          ? "Enregistrer mon adresse email"
                          : null,
                      textAlign: TextAlign.center,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Adresse email',
                        hintText: "${widget.user!.email}",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Enregistrer mon téléphone" : null,
                      textAlign: TextAlign.center,
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                        hintText: "${widget.user!.phone}",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: TextFormField(
                      validator: (value) =>
                          value!.isEmpty ? "Enregistrer mon mon antenne" : null,
                      textAlign: TextAlign.center,
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Mon antenne',
                        hintText: "${widget.user!.location}",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final _auth = DatabaseService(uid: widget.user!.uid);

                        var name = nameController.value.text;
                        var email = emailController.value.text;
                        var phone = phoneController.value.text;
                        var location = locationController.value.text;

                        final res = _auth.saveUser(
                            widget.user!.uid, name, email, phone, location);

                        res.whenComplete(
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Home(user: widget.user),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Enregistrer",
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 2.0, spreadRadius: 2.0)
            ],
          ),
        ),
      ),
    );
  }

  AppBar myAppBar(MyUser? user) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Home(user: user),
            ),
          );
        },
        child: Text("Positive + "),
      ),
      elevation: 0.0,
      leading: Icon(Icons.menu_rounded),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text("${user!.name}"),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Icon(
                Icons.account_circle,
                size: 40.0,
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
              icon: Icon(
                Icons.edit,
                size: 20.0,
                color: Colors.white,
              ),
              label: Text(""),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
        ),
      ],
    );
  }
}
