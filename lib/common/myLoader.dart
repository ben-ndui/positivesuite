import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:positivesuite/model/services/authenticationService.dart';
import 'package:provider/provider.dart';

import 'Constants.dart';

class MyLoader extends StatelessWidget {
  const MyLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthenticationService>(context);

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Center(
            child: SpinKitDoubleBounce(
              color: kprimaryColor,
              size: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
