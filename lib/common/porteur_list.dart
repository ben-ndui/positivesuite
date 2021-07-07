import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/common/myLoader.dart';
import 'package:positivesuite/common/users_porteurs_tile.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:positivesuite/model/user/Porteur.dart';
import 'package:provider/provider.dart';

class PorteursList extends StatefulWidget {
  final MyUser? user;

  const PorteursList({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<PorteursList> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseService(uid: widget.user!.uid).getPorteurs(),
      builder: (context, snapshot) {
        if (snapshot.hasData)
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return UserPorteurTile(user: snapshot.data!.docs[index]);
            },
          );
        else
          return MyLoader();
      },
    );
  }
}
