import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooksBookList.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:provider/provider.dart';

class MyBooks extends StatefulWidget {

  bool self;
  String userUid;
  Map<int, dynamic> books;

  MyBooks({Key key, this.books, @required this.self, this.userUid});

  @override
  _MyBooksState createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  ScrollController _scrollController;
  double _scrollOffset = 0.0;

  //DatabaseService _db;

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

    Map<int,dynamic> books;

    if (widget.books != null)
      books = widget.books;
    else{
      books = Provider.of<BookPerGenreUserMap>(context) != null ?
      Provider.of<BookPerGenreUserMap>(context).result : null;
    }


    /*
    CustomUser user;
    if (widget.self) {
      AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
      user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    } else
      user = Provider.of<CustomUser>(context);
     */

    //_db = DatabaseService(user: user);

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

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
      userUid: widget.userUid,
      books: books,
    );
  }
}

