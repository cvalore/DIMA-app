import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchBookPage.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchUserPage.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class SearchPage extends StatelessWidget {

  final List<dynamic> books;

  const SearchPage({Key key, this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.black,
        appBar: AppBar(
          //backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text("Search", style: TextStyle(fontSize: _isTablet ? 24.0 : 20.0),),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Container(
                  height: _isTablet ? 60.0 : 40.0,
                  child: Center(child: Text('Books',
                    style: TextStyle(fontSize: _isTablet ? 20.0 : 14.0),))
              ),
              Container(
                  height: _isTablet ? 60.0 : 40.0,
                  child: Center(child: Text('Users',
                    style: TextStyle(fontSize: _isTablet ? 20.0 : 14.0),))
              ),
            ],
          ),
        ),
        body: TabBarView(
            children: [
              SearchBookPage(
                books: books,
              ),
              SearchUserPage(

              ),
            ]
        ),
      ),
    );
  }
}
