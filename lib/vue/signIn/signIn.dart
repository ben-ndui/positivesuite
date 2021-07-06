import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:positivesuite/common/Constants.dart';
import 'package:positivesuite/common/myLoader.dart';
import 'package:positivesuite/model/services/authenticationService.dart';

class SigningIn extends StatefulWidget {
  const SigningIn({Key? key}) : super(key: key);

  @override
  _SigningInState createState() => _SigningInState();
}

class _SigningInState extends State<SigningIn> {
  final _formKey = GlobalKey<FormState>();

  String error = '';
  bool loading = false;

  String? testM;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  bool showSignIn = true;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState!.reset();
      error = '';
      emailController.text = '';
      nameController.text = '';
      passwordController.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? MyLoader()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () {
                      toggleView();
                    },
                    icon:
                        Icon(showSignIn ? Icons.person_add : Icons.person_pin),
                    label: Text(
                      showSignIn ? "Créer un compte" : "Me connecter",
                    ),
                  ),
                ),
              ],
            ),
            body: Stack(
              alignment: Alignment.topCenter,
              children: [
                SvgPicture.asset(
                  "assets/backgrounds/login_background.svg",
                  fit: BoxFit.cover,
                ),
                Container(
                  margin: EdgeInsets.only(top: 70.0),
                  width: 250.0,
                  height: 80.0,
                  child: Center(
                    child: Text("Positive + ", style: TextStyle(fontSize: 50.0, color: Colors.deepPurpleAccent,),),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: personalWidth,
                      height: !showSignIn ? 330.0 : personalHeight,
                      decoration: BoxDecoration(
                        color: kprimaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: const Offset(
                              0.0,
                              0.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: kMyGrey,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 5.0,
                            spreadRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 490.0,
                          height: !showSignIn ? 325.0 : 260.0,
                          margin: EdgeInsets.only(left: 5.0, right: 5.0),
                          padding: EdgeInsets.all(30.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: !showSignIn ? TextFormField(
                                    textAlign: TextAlign.center,
                                    obscureText: false,
                                    controller: nameController,
                                    validator: (value) => value!.isEmpty
                                        ? "Entrez un nom d\'utilisateur"
                                        : null,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.drive_file_rename_outline),
                                      labelText: 'Nom d\'utilisateur',
                                    ),
                                  ) : Container(),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Center(
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    obscureText: false,
                                    controller: emailController,
                                    validator: (value) {

                                      List<String> test = value!.split("@");

                                      if(test[1].contains("positiveplanet.ngo")){
                                        setState(() {
                                          testM = value;
                                        });
                                        return null;
                                      }
                                      return "Veuillez entrer un email PPF s'il vous plait";
                                    },
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.account_circle_outlined),
                                      labelText: 'Adresse email',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Center(
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: passwordController,
                                    validator: (value) => value!.length < 6
                                        ? "Mot de passe fragile"
                                        : null,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      labelText: 'Mot de passe',
                                      icon: Icon(Icons.password),
                                    ),
                                  ),
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
                                        setState(() {
                                          loading = true;
                                        });
                                        String password =
                                            passwordController.value.text;
                                        String name =
                                            nameController.value.text;
                                        String email = testM!;
                                        final _auth = AuthenticationService();

                                        /// CONNECTION WITH FIREBASE RIGHT HER
                                        dynamic res = showSignIn
                                            ? await _auth.signIn(
                                                email, password)
                                            : await _auth.signUp(name, email, password);
                                        //print(res.toString());
                                        if (res == null) {
                                          setState(() {
                                            loading = false;
                                            error =
                                                "Veuillez saisir une adresse email valide s'il vous plait !";
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      showSignIn
                                          ? "Me connecter"
                                          : "Créer un compte",
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
