import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_auth/screens/profile/BookList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);

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
      body: Center(
        child: ElevatedButton(
          child: Text('To user profile'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookList()),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (user != null) {
            Navigator.pushNamed(context, '/addBook');
          } else {
            //TODO: display something saying that login is needed to insert content
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
