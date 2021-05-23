import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/home/homePageBookList.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  double _scrollOffset = 0.0;
  bool _isTablet;

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

    AuthCustomUser userFromAuth;
    try {
      userFromAuth = Provider.of<AuthCustomUser>(context);
    } catch(Exception) {
      print("Cannot read value from AuthCustomUser stream provider");
    }
    CustomUser user = CustomUser(
        userFromAuth == null ? "" : userFromAuth.uid,
        email: userFromAuth == null ? "" : userFromAuth.email,
        isAnonymous: userFromAuth == null ? false : userFromAuth.isAnonymous
    );
    _db = DatabaseService(user: user);
    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    Map<String,dynamic> books =
    Provider.of<BookPerGenreMap>(context) != null ?
      Provider.of<BookPerGenreMap>(context).result :
      Utils.mockedDb ?
        Utils.mockedInsertedBooksMap.length > 0 ? Utils.mockedInsertedBooksMap : null :
        null;

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
            style: TextStyle(color: Colors.white, fontSize: _isTablet ? 20.0 : 14.0,),
            textAlign: TextAlign.center,),
          Icon(Icons.menu_book_rounded, color: Colors.white, size: _isTablet ? 30.0 : 20.0,),
        ],
      ),
    ) :
    CustomScrollView(
        controller: _scrollController,
        slivers: [
          for(int i = 0; i < books.length; i++)
            SliverPadding(
              padding: EdgeInsets.only(top: 24.0),
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

  void rebuildForTest() {
    setState(() {

    });
  }
}
