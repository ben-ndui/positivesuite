import 'package:flutter/material.dart';
import 'package:positivesuite/model/user/MyUser.dart';

class UserTile extends StatelessWidget {
  final MyUser user;

  const UserTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: ListTile(
          title: Text("${user.name}"),
          subtitle: Text("${user.email}"),
          trailing: Icon(Icons.account_circle, size: 30.0,),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 2.0, spreadRadius: 2.0),
            BoxShadow(color: Colors.white54, blurRadius: 2.0, spreadRadius: 2.0),
          ],
        ),
      ),
    );
  }
}
