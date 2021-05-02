import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/home/homeBody.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(
        userFromAuth != null ? userFromAuth.uid : "",
        email: userFromAuth != null ? userFromAuth.email : "",
        isAnonymous: userFromAuth != null ? userFromAuth.isAnonymous : false);
    DatabaseService _db = DatabaseService(user: user);

    return userFromAuth == null ?
    Container() :
    MultiProvider(
      providers: [
        StreamProvider<BookPerGenreMap>.value(value: _db.perGenreBooks),
        StreamProvider<BookPerGenreUserMap>.value(value: _db.userBooksPerGenre)
      ],
      child: HomeBody(),
    );
  }
}

