import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/common/myLoader.dart';
import 'package:positivesuite/model/services/GoogleSignInProvider.dart';
import 'package:positivesuite/model/services/authenticationService.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/vue/home/home.dart';
import 'package:positivesuite/vue/signIn/signIn.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyUser?>(
      stream: AuthenticationService().user,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return MyLoader();
        }else if(snapshot.hasData){
          return Home();
        }else if (snapshot.hasError) {
          return Center(child: Text("Un probleme dans le code bro, go checker ca !!" + "\n " + snapshot.error.toString()),);
        }else{
          return SigningIn();
        }
      }
    );
  }
}
