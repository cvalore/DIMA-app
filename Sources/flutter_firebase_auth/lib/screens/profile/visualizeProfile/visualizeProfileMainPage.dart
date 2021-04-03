import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/modifyProfile/modifyProfileMainPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/reviews.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/userInfo.dart';


class VisualizeProfileMainPage extends StatefulWidget {
  static const routeName = '/visualizeProfileMainPage';

  CustomUser user;
  bool self;

  VisualizeProfileMainPage({Key key, @required this.user, @required this.self}) : super(key: key);

  @override
  _VisualizeProfileMainPageState createState() => _VisualizeProfileMainPageState();
}

class _VisualizeProfileMainPageState extends State<VisualizeProfileMainPage> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.username),
          actions: widget.self ? [
            myPopUpMenu(context, widget.user)
          ] : [],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Information',
                  icon: Icon(Icons.info_outline)),
              Tab(text: 'My library',
                  icon: Icon(Icons.menu_book)),
              Tab(text: 'Reviews',
                  icon: Icon(Icons.rate_review_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserInfo(user: widget.user, self: true),
            Text('Here we are'),
            Reviews(reviews: widget.user.reviews, self: true),
          ],
        ),
      ),
    );
  }
}


Widget myPopUpMenu(BuildContext context, CustomUser user) {
  return  PopupMenuButton<String>(
    icon: Icon(Icons.more_vert_outlined),
    onSelected: (value) {
      switch (value) {
        case 'Modify profile':
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ModifyProfileMainPage(user: user))
          );
          break;
      }
    },
    itemBuilder: (BuildContext context) => [
      const PopupMenuItem(
        value: 'Modify profile',
        child: Text('Modify profile'))
    ]
  );
}