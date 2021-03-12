import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/profile/profile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);

    return Scaffold(
      body: Center(
        child: Text('TODO:// Home page',
          style: TextStyle(color: Colors.blueGrey[300], fontStyle: FontStyle.italic),),
      ),
    );
  }
}
