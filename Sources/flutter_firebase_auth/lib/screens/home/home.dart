import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/home/homePage.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/addBookParameters.dart';
import 'package:flutter_firebase_auth/utils/bottomTabs.dart';
import 'package:flutter_firebase_auth/screens/profile/profile.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  DatabaseService _db;

  int _selectedBottomTab = 0;

  void setIndex(int newIndex) {
    setState(() {
      this._selectedBottomTab = newIndex;
    });
  }

  int getIndex() {
    return this._selectedBottomTab;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetsBottomOptions = <Widget> [
      Container(),
      Center(child: Text('TODO:// Search books',
        style: TextStyle(color: Colors.blueGrey[300], fontStyle: FontStyle.italic),)),
      BookInsert(
        param: AddBookParameters(false,
          bookIndex: -1,
          editPurpose: "",
          editGenre: "",
        ),
        setIndex: setIndex,
      ),
      Center(child: Text('TODO:// Forum',
        style: TextStyle(color: Colors.blueGrey[300], fontStyle: FontStyle.italic),)),
      Profile(),
    ];

    CustomUser user = Provider.of<CustomUser>(context);
    GlobalKey scaffoldKey = GlobalKey();
    _db = DatabaseService(user: user);

    return StreamProvider<Map<String,dynamic>>.value(
      value: _db.perGenreBooks,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: false,
          //backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
            //backgroundColor: Colors.blueGrey[700],
            elevation: 0.0,
            title: Text('BookYourBook'),
            actions: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.logout, color: Colors.white,),
                label: Text(''),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ],
            bottom: _selectedBottomTab == 0 ?
              TabBar(
                tabs: <Widget>[
                  Container(height: 40.0, child: Center(child: Text('For Sale',))),
                  Container(height: 40.0, child: Center(child: Text('My Books',))),
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
                    MyBooks(),
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
