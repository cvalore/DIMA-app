import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchBookPage.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:provider/provider.dart';

import 'bookPerGenreMap.dart';


class BottomTabs extends StatelessWidget {

  final int Function() getIndex;
  final void Function(int) setIndex;
  bool _isTablet;

  BottomTabs({Key key, this.getIndex, this.setIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    AuthCustomUser user = Provider.of<AuthCustomUser>(context);

    _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    Map<String,dynamic> booksMap = Provider.of<BookPerGenreMap>(context) != null ?
    Provider.of<BookPerGenreMap>(context).result : null;

    if(booksMap != null && booksMap.length != 0) {
      booksMap.removeWhere((key, value) {
        bool empty = booksMap[key]['books'] == null ||
            booksMap[key]['books'].length == 0;
        return key == null || value == null || empty;
      });
    }
    //books passed to search book page
    List<dynamic> books = List<dynamic>();
    for(int i = 0; booksMap != null && i < booksMap.length; i++) {
      books.addAll(booksMap[booksMap.keys.elementAt(i).toString()]['books']);
    }

    return BottomNavigationBar(
      backgroundColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: true,
      selectedLabelStyle: TextStyle(fontSize: _isTablet ? 18.0 : 11.0),
      unselectedLabelStyle: TextStyle(fontSize: _isTablet ? 18.0 : 11.0),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(getIndex() == 0 ? Icons.home : Icons.home_outlined,
            size: _isTablet ? 32.0 : 21.0,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: Icon(getIndex() == 1 ? Icons.find_in_page : Icons.find_in_page_outlined,
              size: _isTablet ? 32.0 : 21.0,),
            label: 'Search'
        ),
        BottomNavigationBarItem(
            icon: Icon(getIndex() == 2 ? Icons.add_circle : Icons.add_circle_outline_outlined,
              size: _isTablet ? 46.0 : 32.0,),
            label: 'Insert Book'
        ),
        BottomNavigationBarItem(
            icon: Icon(getIndex() == 3 ? Icons.forum : Icons.forum_outlined,
              size: _isTablet ? 32.0 : 21.0,),
            label: 'Forum'
        ),
        BottomNavigationBarItem(
            icon: Icon(getIndex() == 4 ? Icons.person : Icons.person_outlined,
              size: _isTablet ? 32.0 : 21.0,),
            label: 'Profile'
        ),
      ],
      currentIndex: getIndex(),
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      //add line below if wanted, probably better if not, since icons are not equally spaced
      //showUnselectedLabels: true,
      onTap: (index) {
        bool success = true;

        //add every page you can NOT access without being logged
        if(index == 2 || index == 4) {
          if(user == null || user.isAnonymous) {
            success = false;
          }
        }

        if(success) {
          if(index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return BookInsert(
                  insertedBook: InsertedBook(),
                  edit: false,
                  editIndex: -1,
                );
              })
            );
            //setIndex(0);
          }
          else if(index == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return Scaffold(
                    resizeToAvoidBottomInset: false,
                    //backgroundColor: Colors.black,
                    appBar: AppBar(
                      //backgroundColor: Colors.black,
                      elevation: 0.0,
                      title: Text("Search books"),
                    ),
                    body: SearchBookPage(
                      books: books,
                    ),
                  );
                })
            );
            //setIndex(0);
          }
          else {
            setIndex(index);
          }
        }
        else {
          final snackBar = SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
                'You need to be logged in to access this functionality'
            ),
            backgroundColor: Colors.white24,
          );
          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    );
  }
}
