import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/myBooks/bookList.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooksBookList.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:provider/provider.dart';

class MyBooks extends StatefulWidget {
  static const routeName = '/profile';

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

    CustomUser user = Provider.of<CustomUser>(context);
    _db = DatabaseService(user: user);

    Map<String,dynamic> books = Provider.of<BookPerGenreUserMap>(context) != null ?
      Provider.of<BookPerGenreUserMap>(context).result : null;

    Map<String,dynamic> booksPerGenre = books.entries.fold(
        <String, dynamic>{},
        (result, entry) => result..putIfAbsent(entry.key, () => <dynamic>{})
            .add(entry.value));

    return (booksPerGenre == null || booksPerGenre.length == 0 || booksPerGenre.keys.length == 0) ?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('No books yet, the books you add will appear here',
            style: TextStyle(color: Colors.white),),
          Icon(Icons.menu_book_rounded, color: Colors.white,),
        ],
      ),
    ) :
    CustomScrollView(
      controller: _scrollController,
      slivers: [
        for(int i = 0; i < books.length; i++)
          SliverPadding(
            padding: EdgeInsets.only(top: 8.0),
            sliver: SliverToBoxAdapter(
              child: MyBooksBookList(
                genre: booksPerGenre.keys.elementAt(i),
                books: booksPerGenre[booksPerGenre.keys.elementAt(i)].elementAt(0),
              ),
            ),
          )
      ],
    );
  }
}

