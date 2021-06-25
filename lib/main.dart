import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/services/GoogleSignInProvider.dart';
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
        StreamProvider(create: (context) => context.read<AuthenticationService>().user, initialData: null),
        StreamProvider(create: (context) => context.read<DatabaseService>().user, initialData: null, child: SplashScreen(),),
        StreamProvider(create: (context) => context.read<DatabaseService>().allUserPositiveurs, initialData: null, child: SplashScreen(),),
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider(), child: SplashScreen(),)
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
