import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showSignIn = true;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _formKey.currentState!.reset();
      error = '';
      emailController.text = '';
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
                    onPressed: () => toggleView(),
                    icon:
                        Icon(showSignIn ? Icons.person_add : Icons.person_pin),
                    label: Text(
                      showSignIn ? "Créer un compte" : "Me connecter",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: (){

                      toggleView();
                    },
                    icon:
                        FaIcon(FontAwesomeIcons.google),
                    label: Text("Compte",),
                  ),
                ),
              ],
            ),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SvgPicture.asset(
                  "assets/backgrounds/login_background.svg",
                  fit: BoxFit.cover,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: personalWidth,
                      height: personalHeight,
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
                          height: 260.0,
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
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    obscureText: false,
                                    controller: emailController,
                                    validator: (value) => value!.isEmpty
                                        ? "Entrer une adresse email"
                                        : null,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.account_circle_outlined),
                                      labelText: 'Nom d\'utilisateur',
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
                                        var password =
                                            passwordController.value.text;
                                        var useremail =
                                            emailController.value.text;
                                        final _auth = AuthenticationService();

                                        /// CONNECTION WITH FIREBASE RIGHT HER
                                        dynamic res = showSignIn
                                            ? await _auth.signIn(useremail, password)
                                            : await _auth.signUp(useremail, password);
                                        print(res.toString());
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
