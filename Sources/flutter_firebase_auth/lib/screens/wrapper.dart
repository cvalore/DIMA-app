import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/authenticate/authenticate.dart';
import 'package:flutter_firebase_auth/screens/home/home.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  WrapperState createState() => WrapperState();
}

class WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    if(!Utils.mockedDb) {
      final user = Provider.of<AuthCustomUser>(context);
      if (user == null) {
        return Container(
            child: Authenticate()
        );
      }
      else {
        Utils.initDatabaseService(user);
        return Container(
          child: Home(),
        );
      }
    }
    else {
      if(Utils.mockedLoggedUser == null) {
        return Container(
            child: Authenticate()
        );
      }
      else {
        Utils.initDatabaseService(Utils.mockedLoggedUser);
        return Container(
          child: Home(),
        );
      }
    }

    /*return OrientationBuilder(
      builder: (context, orientation) {
        if(orientation == Orientation.portrait) {
          if(user == null) {
            return Container(
                child: Authenticate()
            );
          }
          else {
            Utils.initDatabaseService(user);
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
    );*/


  }

  void rebuildForTest() {
    setState(() {

    });
  }
}
