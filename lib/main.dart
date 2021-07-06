import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/common/porteur_list.dart';
import 'package:positivesuite/common/users_list.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/services/GoogleSignInProvider.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/model/user/Porteur.dart';
import 'package:positivesuite/vue/home/component/splashScreen.dart';
import 'package:positivesuite/vue/home/home.dart';
import 'package:provider/provider.dart';

import 'model/services/authenticationService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(create: (_) => AuthenticationService()),
        Provider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
        Provider<DatabaseService>(create: (_) => DatabaseService(), child: SplashScreen(),),
        StreamProvider<List<MyUser>>.value(
          value: DatabaseService().allUser,
          initialData: [],
          child: UsersList(),
        ),
        StreamProvider<List<Porteur>>.value(
          value: DatabaseService().allPorteurs,
          initialData: [],
          child: PorteursList(),
        ),
      ],
      child: MaterialApp(
        title: "Positive +",
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
