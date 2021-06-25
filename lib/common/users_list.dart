import 'package:flutter/material.dart';
import 'package:positivesuite/common/user_tile.dart';
import 'package:positivesuite/model/user/MyUser.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {

    final allUsers = Provider.of<List<MyUser>>(context);

    return ListView.builder(
      itemCount: allUsers.length,
      itemBuilder: (context, index){
        return UserTile(user: allUsers[index]);
      },
    );
  }
}
