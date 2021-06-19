import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:positivesuite/model/services/authenticationService.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: myAppBar(),
      body: orientation == Orientation.portrait
          ? portraitDisplay()
          : landScapeDisplay(),
    );
  }

  Stack portraitDisplay() {
    return Stack(
      children: [
        Center(child: SvgPicture.asset("assets/backgrounds/login_background.svg", width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,fit: BoxFit.cover,)),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container landScapeDisplay() {
    return Container(
      child: Stack(
        children: [
          Center(child: SvgPicture.asset("assets/backgrounds/login_background.svg", width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,fit: BoxFit.cover,)),
          Row(
            children: [
              leftPanel(),
              rightPanel(),
            ],
          ),
        ],
      ),
    );
  }

  Padding rightPanel() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Container(
          width: 200.0,
          height: 450.0,
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
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
          child: Container(
            height: 450.0,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      title: Text("Positive + "),
      leading: Icon(Icons.menu_rounded),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text("Username"),
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
