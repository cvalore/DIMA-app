import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/forum/forumMainPage.dart';
import 'package:flutter_firebase_auth/screens/home/homePage.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/screens/profile/profileMainPage.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/bottomTabs.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  DatabaseService _db;
  bool _isTablet;

  int _selectedBottomTab = 0;

  void setIndex(int newIndex) {
    setState(() {
      this._selectedBottomTab = newIndex;
    });
  }

  int getIndex() {
    return this._selectedBottomTab;
  }

  TextButtonThemeData _textButtonThemeData = TextButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.transparent;
          }),
    ),
  );

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _isTablet =
        _isPortrait ?
        MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    List<Widget> _widgetsBottomOptions = <Widget> [
      Container(),
      Container(),//SearchBookPage(),
      /*BookInsert(
        param: AddBookParameters(false,
          bookIndex: -1,
          editPurpose: "",
          editGenre: "",

        ),
        setIndex: setIndex,
      ),*/
      Container(),
      ForumMainPage(),
      ProfileMainPage(),
    ];

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(
        userFromAuth != null ? userFromAuth.uid : "",
        email: userFromAuth != null ? userFromAuth.email : "",
        isAnonymous: userFromAuth != null ? userFromAuth.isAnonymous : false);
    _db = DatabaseService(user: user);
    GlobalKey scaffoldKey = GlobalKey();

   return userFromAuth == null ?
      Container() :
      MultiProvider(
        providers: [
          StreamProvider<BookPerGenreMap>.value(value: _db.perGenreBooks),
          StreamProvider<BookPerGenreUserMap>.value(value: _db.userBooksPerGenre)
        ],
        child: DefaultTabController(
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
                bottom: _selectedBottomTab == 0 ?
                  TabBar(
                    indicatorColor: Colors.white,
                    tabs: <Widget>[
                      Container(
                        height: _isTablet ? 60.0 : 40.0,
                        child: Center(child: Text('For Sale',
                          style: TextStyle(fontSize: _isTablet ? 20.0 : 14.0),))
                      ),
                      Container(
                        height: _isTablet ? 60.0 : 40.0,
                        child: Center(child: Text('My Books',
                          style: TextStyle(fontSize: _isTablet ? 20.0 : 14.0),))
                      ),
                    ],
                  ) :
                  null,
              ),
              body: Builder(
                builder: (BuildContext context) {
                  return _selectedBottomTab != 0 ?
                    _widgetsBottomOptions.elementAt(_selectedBottomTab) :
                    TabBarView(
                      children: [
                        HomePage(),
                        MyBooks(self: true),
                      ]
                    );

                  return _widgetsBottomOptions.elementAt(_selectedBottomTab);
                  /*return _selectedBottomTab != 0 ?
                  _widgetsBottomOptions.elementAt(_selectedBottomTab) :
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: UpperTabs(),
                      ),
                      Expanded(
                        flex: 10,
                        child: _widgetsBottomOptions.elementAt(_selectedBottomTab),
                      ),
                    ],
                  );*/
                },
              ),
              bottomNavigationBar: BottomTabs(
                getIndex: getIndex,
                setIndex: setIndex,
              ),
            ),
          ),
      );
  }
}
