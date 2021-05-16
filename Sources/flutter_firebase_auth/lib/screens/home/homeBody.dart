import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchPage.dart';
import 'package:flutter_firebase_auth/screens/forum/forumMainPage.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/screens/profile/profileMainPage.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bottomTabs.dart';
import 'package:flutter_firebase_auth/utils/myVerticalTabs.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

import 'package:flutter_firebase_auth/utils/constants.dart';


import 'homePage.dart';

class HomeBody extends StatefulWidget {

  const HomeBody({Key key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool _isTablet;

  DatabaseService _db;

  final AuthService _auth = AuthService();

  TextButtonThemeData _textButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.transparent;
          }),
    ),
  );

  int _selectedBottomTab = 0;
  int _selectedVerticalTabMain = 0;
  int _selectedVerticalTab = 0;

  void setIndex(int newIndex) {
    setState(() {
      this._selectedBottomTab = newIndex;
    });
  }

  int getIndex() {
    return this._selectedBottomTab;
  }
  
  int getIndexVerticalTabMain() {
    return this._selectedVerticalTabMain;
  }
  
  void setIndexVerticalTabMain(int newIndex) {
    this._selectedVerticalTabMain = newIndex;
  }

  int getIndexVerticalTab() {
    return this._selectedVerticalTab;
  }

  void setIndexVerticalTab(int newIndex) {
    this._selectedVerticalTab = newIndex;
  }

  void updateDiscussionView() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    GlobalKey scaffoldKey = GlobalKey();
    List<Widget> _widgetsBottomOptions = <Widget> [
      Container(),
      Container(),
      Container(),
      ForumMainPage(updateDiscussionView: updateDiscussionView,),
      ProfileMainPage(),
    ];

    AuthCustomUser userFromAuth;
    try {
      userFromAuth = Provider.of<AuthCustomUser>(context);
    } catch(Exception) {
      print("Cannot read value from AuthCustomUser stream provider");
    }
    CustomUser user = CustomUser(
        userFromAuth != null ? userFromAuth.uid : "",
        email: userFromAuth != null ? userFromAuth.email : "",
        isAnonymous: userFromAuth != null ? userFromAuth.isAnonymous : false);
    _db = DatabaseService(user: user);


    //done in bottom tabs if is portrait
    Map<String,dynamic> booksMap;
    List<dynamic> books = List<dynamic>();
    if(!_isPortrait) {
      booksMap = Provider.of<BookPerGenreMap>(context) != null ?
      Provider.of<BookPerGenreMap>(context).result : null;

      if(booksMap != null && booksMap.length != 0) {
        booksMap.removeWhere((key, value) {
          bool empty = booksMap[key]['books'] == null ||
              booksMap[key]['books'].length == 0;
          return key == null || value == null || empty;
        });
      }
      //books passed to search book page
      for(int i = 0; booksMap != null && i < booksMap.length; i++) {
        books.addAll(booksMap[booksMap.keys.elementAt(i).toString()]['books']);
      }
    }


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.black,
        appBar: AppBar(
          //backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text('BookYourBook', style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            letterSpacing: 1.0,
          ),),
          actions: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                textButtonTheme: _textButtonThemeData,
              ),
              child: TextButton.icon(
                icon: Icon(Icons.logout, color: Colors.white,),
                label: Text(''),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ),
          ],
          bottom: _isPortrait ? _selectedBottomTab == 0 ?
          TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Container(
                  height: _isTablet ? 60.0 : 40.0,
                  child: Center(child: Text('For Sale',
                    style: TextStyle(fontSize: _isTablet ? 20.0 : 14.0),))
              ),
              Container(
                  key: ValueKey("prova"),
                  height: _isTablet ? 60.0 : 40.0,
                  child: Center(child: Text('My Books',
                    style: TextStyle(fontSize: _isTablet ? 20.0 : 14.0),))
              ),
            ],
          ) :
          null : null,
        ),
        body: Builder(
          builder: (BuildContext context) {
            if(_isPortrait) {
              return _selectedBottomTab != 0 ?
              _widgetsBottomOptions.elementAt(_selectedBottomTab) :
              TabBarView(
                  children: [
                    HomePage(),
                    MyBooks(self: true),
                  ]
              );
            }
            else {
              return MyVerticalTabs(
                user: userFromAuth,
                getIndex: getIndexVerticalTabMain,
                setIndex: setIndexVerticalTabMain,
                books: books,
                disabledChangePageFromContentView: true,
                tabBarSide: TabBarSide.right,
                indicatorSide: IndicatorSide.end,
                tabBarHeight: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
                tabBarWidth: 55,
                tabsWidth: 55,
                indicatorColor: Colors.white,
                selectedTabBackgroundColor: Colors.white10,
                tabBackgroundColor: Colors.black26,
                selectedTabTextStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    child: Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                    height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(getIndex() == 0 ? Icons.home : Icons.home_outlined,
                          size: _isTablet ? 28.0 : 21.0,),
                        //getIndex() == 0 ? Text("Home") : Container(),
                        Text("Home", style: TextStyle(fontSize: 13),),
                      ],
                    ),
                  ),),
                  Tab(child: Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                    height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(getIndex() == 1 ? Icons.find_in_page : Icons.find_in_page_outlined,
                          size: _isTablet ? 28.0 : 21.0,),
                        //getIndex() == 1 ? Text("Search") : Container(),
                        Text("Search", style: TextStyle(fontSize: 13),),
                      ],
                    ),
                  ),),
                  Tab(child: Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                    height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(getIndex() == 2 ? Icons.add_circle : Icons.add_circle_outline_outlined,
                          size: _isTablet ? 45.0 : 32.0,),
                        //getIndex() == 2 ? Text("Insert Book") : Container(),
                        //Text("Insert Book", style: TextStyle(fontSize: 13),),
                      ],
                    ),
                  ),),
                  Tab(child: Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                    height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(getIndex() == 3 ? Icons.forum : Icons.forum_outlined,
                          size: _isTablet ? 28.0 : 21.0,),
                        //getIndex() == 3 ? Text("Forum") : Container(),
                        Text("Forum", style: TextStyle(fontSize: 13),),
                      ],
                    ),
                  ),),
                  Tab(child: Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                    height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(getIndex() == 4 ? Icons.person : Icons.person_outlined,
                          size: _isTablet ? 28.0 : 21.0,),
                        //getIndex() == 4 ? Text("Profile") : Container(),
                        Text("Profile", style: TextStyle(fontSize: 13),),
                      ],
                    ),
                  ),),
                ],
                contents: [
                  MyVerticalTabs(
                    //tabBarHeight: 120,
                    setIndex: setIndexVerticalTab,
                    getIndex: getIndexVerticalTab,
                    tabBarHeight: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
                    tabBarWidth: 85,
                    tabsWidth: 85,
                    indicatorColor: Colors.blue,
                    selectedTabBackgroundColor: Colors.white10,
                    tabBackgroundColor: Colors.black26,
                    selectedTabTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: <Tab>[
                      Tab(child: Container(
                          //height: 50,
                          height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/2,
                          //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('For Sale', textAlign: TextAlign.center,),
                              Icon(Icons.attach_money),
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
                              Text('My Books', textAlign: TextAlign.center,),
                              Icon(Icons.collections_bookmark),
                            ],
                          ))
                      )),
                    ],
                    contents: <Widget>[
                      HomePage(),
                      MyBooks(self: true),
                    ],
                  ),
                  Container(),
                  Container(),
                  ForumMainPage(updateDiscussionView: updateDiscussionView,),
                  ProfileMainPage(),
                ],
                onTaps: [
                  trueFunction,
                  onTapSearch,
                  onTapInsert,
                  trueFunction,
                  onTapProfile,
                ],
              );
            }
          },
        ),
        bottomNavigationBar: _isPortrait ? BottomTabs(
          getIndex: getIndex,
          setIndex: setIndex,
        ) : null,
      ),
    );
  }

  bool trueFunction(AuthCustomUser user, BuildContext buildContext, List<dynamic> books, int index) {
    //setIndex(index);
    //_selectedBottomTab = index;
    return true;
  }

  bool onTapSearch(AuthCustomUser user, BuildContext buildContext, List<dynamic> books, int index) {
    Navigator.push(
        buildContext,
        MaterialPageRoute(builder: (BuildContext context) {
          return SearchPage(books: books,);
        })
    );
    return false;
  }

  bool onTapInsert(AuthCustomUser user, BuildContext buildContext, List<dynamic> books, int index) {
    if(isAnonymous(user)) {
      Utils.showNeedToBeLogged(buildContext, 1);
      return false;
    }
    Navigator.push(
        buildContext,
        MaterialPageRoute(builder: (BuildContext context) {
          return BookInsert(
            insertedBook: InsertedBook(),
            edit: false,
            editIndex: -1,
          );
        })
    );
    return false;
  }

  bool onTapProfile(AuthCustomUser user, BuildContext buildContext, List<dynamic> books, int index) {
    if(isAnonymous(user)) {
      Utils.showNeedToBeLogged(buildContext, 1);
      return false;
    }
    //setIndex(index);
    //_selectedBottomTab = index;
    return true;
  }

  bool isAnonymous(AuthCustomUser user) {
    return user == null || user.isAnonymous;
  }
}
