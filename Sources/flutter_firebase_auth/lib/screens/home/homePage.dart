import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/home/homePageBookList.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
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

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, userFromAuth.email, userFromAuth.isAnonymous);
    _db = DatabaseService(user: user);

    Map<String,dynamic> books = Provider.of<BookPerGenreMap>(context) != null ?
      Provider.of<BookPerGenreMap>(context).result : null;

    if(books != null && books.length != 0) {
      books.removeWhere((key, value) {
        bool empty = books[key]['books'] == null ||
            books[key]['books'].length == 0;
        return key == null || value == null || empty;
      });
    }

    return (books == null || books.length == 0) ?
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('No books yet, the books for sale will appear here',
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
                child: HomePageBookList(
                    genre: books.keys.elementAt(i).toString(),
                    books: books[books.keys.elementAt(i).toString()]['books']
                ),
              ),
            )
        ],
    );
  }
}
