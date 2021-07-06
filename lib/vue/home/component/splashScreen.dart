import 'package:flutter/material.dart';
import 'package:positivesuite/common/myLoader.dart';
import 'package:positivesuite/model/services/authenticationService.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/vue/profile/profile_widget.dart';
import 'package:positivesuite/vue/signIn/signIn.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyUser?>(
      stream: AuthenticationService().user,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return MyLoader();
        }else if(snapshot.hasData){
          return ProfileWidget(user: snapshot.data,);
        }else if (snapshot.hasError) {
          return Center(child: Text("Un probleme dans le code bro, go checker ca !!" + "\n " + snapshot.error.toString()),);
        }else{
          return SigningIn();
        }
      }
    );
  }
}
