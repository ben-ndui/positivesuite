import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:positivesuite/common/myLoader.dart';
import 'package:positivesuite/model/databases/database.dart';
import 'package:positivesuite/model/user/MyUser.dart';

class PorteurDetails extends StatefulWidget {
  final MyUser? user;
  final porteur;

  const PorteurDetails({Key? key, this.porteur, this.user}) : super(key: key);

  @override
  _PorteurDetailsState createState() => _PorteurDetailsState();
}

class _PorteurDetailsState extends State<PorteurDetails> {
  bool _like = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void toggleView() {
    setState(() {
      _like = !_like;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.deepPurpleAccent,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            background(),
            Text(
              "Positive +",
              style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent),
            ),
            View(),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder<QuerySnapshot>(
          stream: DatabaseService().getNbPorteurLike(widget.porteur['name']),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              _like = snapshot.data!.docs.length == 0 ? false : true;
            }else{
              MyLoader();
            }
            return snapshot.hasData
                ? FloatingActionButton(
                    backgroundColor:
                        _like ? Colors.green : Colors.deepPurpleAccent,
                    onPressed: () {
                      toggleView();
                      DatabaseService(uid: widget.user!.uid).likePorteur(
                        widget.porteur['name'],
                        widget.user!.name,
                        _like,
                        _like,
                      );
                    },
                    child: _like
                        ? Icon(Icons.thumb_up_alt_rounded)
                        : Icon(Icons.thumb_up_alt_rounded),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }

  Widget View() {
    return Center(
      child: Container(
        width: 500.0,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Color(0xFFCCCCCC),
              offset: Offset(0, 0),
              spreadRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Color(0xFFCCCCCC),
                    offset: Offset(0, 0),
                    spreadRadius: 2,
                  )
                ],
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text("${widget.porteur['name']}"),
            SizedBox(
              height: 12.0,
            ),
            Text("Activité : ${widget.porteur['activities']}"),
            SizedBox(
              height: 12.0,
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    DatabaseService().getNbPorteurLike(widget.porteur['name']),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Text("Nombre de like : ${snapshot.data!.docs.length}")
                      : Text("");
                }),
            SizedBox(
              height: 12.0,
            ),
            Text("QP ? : ${widget.porteur['qp']}"),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 20.0,
              child: Text("Commentaires"),
            ),
            Center(
              child: Container(
                color: Colors.deepPurpleAccent,
                width: 150,
                height: 4.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("${widget.porteur['comments']}"),
          ],
        ),
      ),
    );
  }

  Container background() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        'assets/images/profile_back.svg',
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}
