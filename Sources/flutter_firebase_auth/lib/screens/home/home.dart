import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        title: Text('BookYourBook'),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.logout, color: Colors.white,),
            label: Text(''),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Text('You are signed in as ' + _auth.currentUser(context).toString()),
        ],
      ),
    );
  }
}
