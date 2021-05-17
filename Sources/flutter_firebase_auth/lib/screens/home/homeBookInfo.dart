import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/home/homeBookInfoBody.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';

class HomeBookInfo extends StatefulWidget {

  final PerGenreBook book;

  const HomeBookInfo({Key key, this.book}) : super(key: key);

  @override
  _HomeBookInfoState createState() => _HomeBookInfoState();
}

class _HomeBookInfoState extends State<HomeBookInfo> {

  DatabaseService _db;
  CustomUser user;

  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth;
    try {
      userFromAuth = Provider.of<AuthCustomUser>(context);
    } catch(Exception) {
      print("Cannot read value from AuthCustomUser stream provider");
    }
    user = CustomUser(
        userFromAuth == null ? "" : userFromAuth.uid,
        email: userFromAuth == null ? "" : userFromAuth.email,
        isAnonymous: userFromAuth == null ? false : userFromAuth.isAnonymous
    );
    _db = DatabaseService(user: user);

    //dynamic result = _db.getGeneralBookInfo(widget.book);

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(widget.book.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: HomeBookInfoBody(
        db: _db,
        book: widget.book,
      ),
    );
  }
}
