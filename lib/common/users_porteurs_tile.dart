import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/user/Porteur.dart';

class UserPorteurTile extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> user;

  const UserPorteurTile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final porteur = user.data() as dynamic;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: GestureDetector(
          child: ListTile(
            title: porteur['name'] != null ? Text("${porteur['name']}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),) : null,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                porteur['activities'] != null ? Text("${porteur['activities']}", style: TextStyle(color: Colors.deepPurpleAccent)) : Text(""),
                porteur['comments'] != null ? Text("${porteur['comments']}", style: TextStyle(color: Colors.deepPurpleAccent)) : Text(""),
                SizedBox(height: 10.0,),
                StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService().getNbPorteurLike(porteur['name']),
                  builder: (context, snapshot) {
                    return snapshot.hasData ? Text("❤️ ${snapshot.data!.docs.length}", style: TextStyle(color: Colors.deepPurpleAccent)) : Text("Chargement");
                  }
                ),
              ],
            ),
            trailing: Icon(Icons.account_circle, size: 30.0,),
          ),
          onTap: (){
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(context, user),
            );
          },
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

  AlertDialog _buildPopupDialog(BuildContext context, porteur) {
    return new AlertDialog(
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(color: Colors.deepPurpleAccent, height: 4.0,),
          SizedBox(height: 4.0,),
          Text("${porteur['name']}"),
          SizedBox(height: 4.0,),
          Text("Activité : ${porteur['activities']}"),
          SizedBox(height: 4.0,),
          Text("Nombre de like : ${porteur['nbLike']}"),
          SizedBox(height: 4.0,),
          Text("QP ? : ${porteur['qp']}"),
          SizedBox(height: 30.0,),
          Container(height: 20.0, child: Text("Commentaires"),),
          Container(color: Colors.deepPurpleAccent, height: 4.0,),
          SizedBox(height: 20.0,),
          Text("${porteur['comments']}"),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}