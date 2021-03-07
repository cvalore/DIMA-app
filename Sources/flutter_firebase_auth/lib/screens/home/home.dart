import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/TestPage.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/profile.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/addBookParameters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_auth/screens/profile/bookList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();


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
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      //backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.blueGrey[400];
                            }
                            else {
                              return Colors.blueGrey[600];
                            }
                          }),
                    ),
                    child: Text('To user profile', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      if(user != null && !user.isAnonymous) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profile()),
                        );
                      }
                      else {
                        final snackBar = SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                              'You need to be logged in to add a book'
                          ),
                        );
                        // Find the Scaffold in the widget tree and use
                        // it to show a SnackBar.
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                      //backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[700]),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.blueGrey[400];
                            }
                            else {
                              return Colors.blueGrey[600];
                            }
                          }),
                    ),
                    child: Text('To TEST PAGE', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TestPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
              floatingActionButton: FloatingActionButton(
                elevation: 0.0,
                backgroundColor: Colors.blueGrey[600],
                focusColor: Colors.blueGrey[400],
                hoverColor: Colors.blueGrey[400],
                onPressed: () {
                  if (user != null && !user.isAnonymous) {
                    AddBookParameters args = AddBookParameters(false,
                      bookIndex: -1,
                      editTitle: '',
                      editAuthor: '',
                      editPurpose: '',
                      editFictOrNot: '',
                      editGenre: '',
                    );
                    Navigator.pushNamed(context, '/addBook', arguments: args);
                  }
                  else {
                    final snackBar = SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text(
                          'You need to be logged in to add a book'
                      ),
                    );
                    // Find the Scaffold in the widget tree and use
                    // it to show a SnackBar.
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
                child: Icon(Icons.add),
              ),
          );
        },
      ),
    );
  }
}
