import 'package:flutter/material.dart';
import 'file:///C:/Users/cvalo/OneDrive%20-%20Politecnico%20di%20Milano/Documenti/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/home/homePage.dart';
import 'package:flutter_firebase_auth/screens/profile/profile.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/addBookParameters.dart';
import 'package:flutter_firebase_auth/utils/bottomTabs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_auth/screens/profile/bookList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();

  int _selectedBottomTab = 0;
  static List<Widget> _widgetsBottomOptions = <Widget> [
    HomePage(),
    Center(child: Text('TODO:// Search books',
      style: TextStyle(color: Colors.blueGrey[300], fontStyle: FontStyle.italic),)),
    BookInsert(),
    Profile(),
  ];

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


    CustomUser user = Provider.of<CustomUser>(context);
    GlobalKey scaffoldKey = GlobalKey();

    return Scaffold(
      key: scaffoldKey,
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
      ),
      body: Builder(
        builder: (BuildContext context) {
          return _widgetsBottomOptions.elementAt(_selectedBottomTab);
        },
      ),
      bottomNavigationBar: BottomTabs(
          getIndex: getIndex,
          setIndex: setIndex,
      ),
    );
  }
}
