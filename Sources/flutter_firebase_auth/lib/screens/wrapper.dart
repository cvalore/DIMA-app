import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/authenticate/authenticate.dart';
import 'package:flutter_firebase_auth/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthCustomUser>(context);

    return OrientationBuilder(
      builder: (context, orientation) {
        if(orientation == Orientation.portrait) {
          if(user == null) {
            return Container(
                child: Authenticate()
            );
          }
          else {
            return Container(
              child: Home(),
            );
          }
        }
        else {
          return Center(
            child: Text('Landscape mode still WIP',
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }
}
