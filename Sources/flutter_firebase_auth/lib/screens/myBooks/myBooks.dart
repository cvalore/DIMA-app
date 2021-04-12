import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooksBookList.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:provider/provider.dart';

class MyBooks extends StatefulWidget {

  bool self;

  MyBooks({Key key, @required this.self});

  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
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

    CustomUser user;

    if (widget.self) {
      AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
      user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    } else
      user = Provider.of<CustomUser>(context);

    _db = DatabaseService(user: user);

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    Map<int,dynamic> books = Provider.of<BookPerGenreUserMap>(context) != null ?
      Provider.of<BookPerGenreUserMap>(context).result : null;

    /*Map<String,dynamic> booksPerGenre = books.entries.fold(
        <String, dynamic>{},
        (result, entry) => result..putIfAbsent(entry.key, () => <dynamic>{})
            .add(entry.value));*/

    return (books == null || books.length == 0) ?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('No books yet, the books you add will appear here',
            style: TextStyle(color: Colors.white,  fontSize: _isTablet ? 20.0 : 14.0,),),
          Icon(Icons.menu_book_rounded, color: Colors.white, size: _isTablet ? 30.0 : 20.0,),
        ],
      ),
    ) :
    MyBooksBookList(
      self: widget.self,
      books: books,
    );
  }
}

