import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:provider/provider.dart';

class BottomTabs extends StatelessWidget {

  final int Function() getIndex;
  final void Function(int) setIndex;

  const BottomTabs({Key key, this.getIndex, this.setIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(getIndex() == 0 ? Icons.home : Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: Icon(getIndex() == 1 ? Icons.find_in_page : Icons.find_in_page_outlined),
            label: 'Search'
        ),
        BottomNavigationBarItem(
            icon: Icon(getIndex() == 2 ? Icons.add_circle : Icons.add_circle_outline_outlined),
            label: 'Insert Book'
        ),
        BottomNavigationBarItem(
            icon: Icon(getIndex() == 3 ? Icons.person : Icons.person_outlined),
            label: 'Profile'
        ),
      ],
      currentIndex: getIndex(),
      unselectedItemColor: Colors.blueGrey[600],
      selectedItemColor: Colors.blueGrey[600],
      //add line below if wanted, probably better if not, since icons are not equally spaced
      //showUnselectedLabels: true,
      onTap: (index) {
        bool success = true;

        //add every page you can NOT access without being logged
        if(index == 2 || index == 3) {
          if(user == null || user.isAnonymous) {
            success = false;
          }
        }

        if(success) {
          setIndex(index);
        }
        else {
          final snackBar = SnackBar(
            duration: Duration(seconds: 1),
            content: Text(
                'You need to be logged in to access this functionality'
            ),
          );
          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    );
  }
}