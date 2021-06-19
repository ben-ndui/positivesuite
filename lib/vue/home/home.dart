import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:positivesuite/model/services/authenticationService.dart';
import 'package:positivesuite/model/user/MyUser.dart';

class Home extends StatefulWidget {
  final MyUser? user;

  const Home({Key? key, required this.user}) : super(key: key);

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
          ? SingleChildScrollView(child: portraitDisplay())
          : landScapeDisplay(),
    );
  }

  Stack portraitDisplay() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        background(),
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

  Center background() {
    return Center(
        child: SvgPicture.asset(
          "assets/backgrounds/login_background.svg",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      );
  }

  Container landScapeDisplay() {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
                child: SvgPicture.asset(
              "assets/backgrounds/login_background.svg",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            )),
            Row(
              children: [
                leftPanel(),
                rightPanel(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding rightPanel() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Membre(s) connecté(e)s',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              width: 300.0,
              height: 580.0,
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
          ],
        ),
      ),
    );
  }

  Expanded leftPanel() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mes Positiveurs + ",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 580.0,
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
            ],
          ),
        ),
      ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      title: Text("Positive + "),
      elevation: 0.0,
      leading: Icon(Icons.menu_rounded),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text("${widget.user!.email}"),
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
