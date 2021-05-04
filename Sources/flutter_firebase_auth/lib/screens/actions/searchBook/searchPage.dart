import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchBookPage.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchUserPage.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/myVerticalTabs.dart';

class SearchPage extends StatelessWidget {

  final List<dynamic> books;

  const SearchPage({Key key, this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.black,
        appBar: AppBar(
          //backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text("Search", style: TextStyle(fontSize: _isTablet ? 24.0 : 20.0),),
          bottom: _isPortrait ?
          TabBar(
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
          ) : null,
        ),
        body:
        _isPortrait ?
        TabBarView(
            children: [
              SearchBookPage(books: books,),
              SearchUserPage(),
            ]
        ) :
        Builder(builder: (BuildContext context) {
          return MyVerticalTabs(
            tabBarHeight: MediaQuery.of(context).size.height,
            tabBarWidth: 85,
            tabsWidth: 85,
            indicatorColor: Colors.blue,
            selectedTabBackgroundColor: Colors.white10,
            tabBackgroundColor: Colors.black26,
            selectedTabTextStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: <Tab>[
              Tab(child: Container(
                //height: 50,
                  height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/2.2,
                  //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Books', textAlign: TextAlign.center,),
                      Icon(Icons.book),
                    ],
                  ))
              )),
              Tab(child: Container(
                //height: 50,
                  height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/2,
                  //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Users', textAlign: TextAlign.center,),
                      Icon(Icons.person_outlined),
                    ],
                  ))
              )),
            ],
            contents: [
              SearchBookPage(books: books,),
              SearchUserPage(),
            ],
          );
        },),
      ),
    );
  }
}
