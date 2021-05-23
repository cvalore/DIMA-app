import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchPage.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

import 'bookPerGenreMap.dart';


class BottomTabs extends StatefulWidget {

  final int Function() getIndex;
  final void Function(int) setIndex;

  BottomTabs({Key key, this.getIndex, this.setIndex}) : super(key: key);

  @override
  BottomTabsState createState() => BottomTabsState();
}

class BottomTabsState extends State<BottomTabs> {
  bool _isTablet;

  @override
  Widget build(BuildContext context) {

    AuthCustomUser user;
    try{
      user = !Utils.mockedDb ? Provider.of<AuthCustomUser>(context) : Utils.mockedLoggedUser;
    } catch(Exception) {
      print("Cannot read value from AuthCustomUser stream provider");
    }

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    Map<String,dynamic> booksMap =
    Provider.of<BookPerGenreMap>(context) != null ?
      Provider.of<BookPerGenreMap>(context).result :
      Utils.mockedDb ?
        Utils.mockedInsertedBooksMap.length > 0 ? Utils.mockedInsertedBooksMap : null :
        null;

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
      selectedLabelStyle: TextStyle(fontSize: _isTablet ? 17.0 : 11.0),
      unselectedLabelStyle: TextStyle(fontSize: _isTablet ? 17.0 : 11.0),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(widget.getIndex() == 0 ? Icons.home : Icons.home_outlined, key: ValueKey("HomeBottomNavTab"),
            size: _isTablet ? 28.0 : 21.0,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: Icon(widget.getIndex() == 1 ? Icons.find_in_page : Icons.find_in_page_outlined, key: ValueKey("SearchBottomNavTab"),
              size: _isTablet ? 28.0 : 21.0,),
            label: 'Search'
        ),
        BottomNavigationBarItem(
            icon: Icon(widget.getIndex() == 2 ? Icons.add_circle : Icons.add_circle_outline_outlined, key: ValueKey("InsertBottomNavTab"),
              size: _isTablet ? 45.0 : 32.0,),
            label: 'Insert Book'
        ),
        BottomNavigationBarItem(
            icon: Icon(widget.getIndex() == 3 ? Icons.forum : Icons.forum_outlined, key: ValueKey("ForumBottomNavTab"),
              size: _isTablet ? 28.0 : 21.0,),
            label: 'Forum'
        ),
        BottomNavigationBarItem(
            icon: Icon(widget.getIndex() == 4 ? Icons.person : Icons.person_outlined, key: ValueKey("ProfileBottomNavTab"),
              size: _isTablet ? 28.0 : 21.0,),
            label: 'Profile'
        ),
      ],
      currentIndex: widget.getIndex(),
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      //add line below if wanted, probably better if not, since icons are not equally spaced
      //showUnselectedLabels: true,
      onTap: (index) async {
        bool success = true;

        //add every page you can NOT access without being logged
        if(index == 2 || index == 4) {
          if(!Utils.mockedDb && (user == null || user.isAnonymous)) {
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
                  return SearchPage(books: books);
                })
            );
            //setIndex(0);
          }
          else {
            widget.setIndex(index);
          }
        }
        else {
          Utils.showNeedToBeLogged(context, 2);
        }
      },
    );
  }

  void rebuildForTest() {
    setState(() {

    });
  }
}
