import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:positivesuite/common/Constants.dart';
import 'package:responsive_grid/responsive_grid.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          background(width, height, "assets/backgrounds/gallery2.jpeg"),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              myAppBar(),
              Expanded(
                /// Porteur Listview
                child: Center(
                  child: Container(
                    /// White center background
                    width: 800,
                    height: 500,
                    margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: shadowDecoration(30.0),
                    child: myListView(context),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Center background(double width, double height, String url) {
    return Center(
      child: Image.asset(
        url,
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
    );
  }

  MediaQuery myListView(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ResponsiveGridList(
          desiredItemWidth: 200,
          minSpacing: 10,
          children: [1, 2, 3, 4, 5].map((e) {
            return Container(
              /// My CustomCard
              height: 100,
              decoration: BoxDecoration(
                color: kMyGrey,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Stack(
                children: [
                  Container(
                    ///Top purple bar
                    height: 15,
                    decoration: BoxDecoration(
                      color: kprimaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                  ),
                  Container(
                    /// Profile icon
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(top: 30.0, left: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    child: Center(child: Icon(Icons.account_circle_outlined)),
                  ),
                  customCard(),
                ],
              ),
            );
          }).toList()),
    );
  }

  Center customCard() {
    return Center(
      child: Container(
        //color: Colors.blueGrey,
        height: 90,
        width: 200,
        margin: EdgeInsets.only(top: 10.0, left: 45.0),
        child: Row(
          children: [
            userInfoDisplay(),
            editDeleteContainer(),
          ],
        ),
      ),
    );
  }

  Center editDeleteContainer() {
    return Center(
      child: Container(
        //color: Colors.red,
        margin: EdgeInsets.only(right: 0.0),
        height: 80,
        width: 30.0,
        padding: EdgeInsets.all(4.0),
        child: Column(
          /// Profile icon
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.edit,
              color: kprimaryColor,
            ),
            SizedBox(
              height: 10.0,
            ),
            Icon(
              Icons.delete_forever_rounded,
              color: kprimaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Center userInfoDisplay() {
    return Center(
      child: Container(
        //color: Colors.red,
        width: 120,
        margin: EdgeInsets.only(left: 25.0),
        padding: EdgeInsets.all(4.0),
        child: Column(
          /// Profile icon
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom"),
            SizedBox(
              height: 5.0,
            ),
            Text("Prénom"),
            SizedBox(
              height: 5.0,
            ),
            Text("Activité"),
          ],
        ),
      ),
    );
  }

  Container myAppBar() {
    return Container(
      ///My appbar
      width: 800,
      height: 80.0,
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.only(top: 50.0),
      decoration: shadowDecoration(100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            /// My search bar
            child: Container(
              width: 550,
              height: 80,
              //color: Colors.yellow,
              alignment: Alignment.center,
              child: ListTile(
                title: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    fillColor: kprimaryColor,
                    icon: Icon(
                      Icons.search_outlined,
                      color: kprimaryColor,
                    ),
                  ),
                  style: TextStyle(
                    color: kprimaryColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Container(
            width: 100,
            height: 100,
            //color: Colors.yellow,
            child: Center(
              child: ListTile(
                subtitle: Text(
                  "Jean Luc",
                  style: TextStyle(color: kprimaryColor),
                ),
                title: Icon(
                  Icons.account_circle,
                  size: 40.0,
                  color: kprimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration shadowDecoration(double radius) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: const Offset(
            0.0,
            0.0,
          ),
          blurRadius: 5.0,
          spreadRadius: 2.0,
        ), //BoxShadow
        BoxShadow(
          color: kMyGrey,
          offset: const Offset(0.0, 0.0),
          blurRadius: 5.0,
          spreadRadius: 2.0,
        ),
      ],
    );
  }
}
