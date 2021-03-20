import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/home/homePageBookList.dart';
import 'package:flutter_firebase_auth/screens/profile/profile.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  double _scrollOffset = 0.0;

  DatabaseService _db;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    super.initState();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    _db = DatabaseService(user: user);

    Map<String,dynamic> books = Provider.of<Map<String,dynamic>>(context);
    if(books != null) {
      books.removeWhere((key, value) {
        bool empty = books[key]['books'] == null ||
            books[key]['books'].length == 0;
        return key == null || value == null || empty;
      });
    }

    return CustomScrollView(
        controller: _scrollController,
        slivers: [
          for(int i = 0; i < books.length; i++)
            SliverPadding(
              padding: EdgeInsets.only(top: 20.0),
              sliver: SliverToBoxAdapter(
                child: HomePageBookList(
                    genre: books.keys.elementAt(i).toString(),
                    books: books[books.keys.elementAt(i).toString()]['books']),
              ),
            )
        ],
    );
  }
}
