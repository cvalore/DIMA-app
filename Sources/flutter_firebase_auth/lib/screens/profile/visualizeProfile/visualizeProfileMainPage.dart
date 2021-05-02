import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/modifyProfile/modifyProfileMainPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/receivedReviews.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/reviewsMainPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/userInfo.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';


class VisualizeProfileMainPage extends StatefulWidget {
  static const routeName = '/visualizeProfileMainPage';

  bool self;
  CustomUser user;
  Map<int, dynamic> books;

  VisualizeProfileMainPage({Key key, this.user, this.books, @required this.self}) : super(key: key);

  @override
  _VisualizeProfileMainPageState createState() => _VisualizeProfileMainPageState();
}

class _VisualizeProfileMainPageState extends State<VisualizeProfileMainPage> {


  @override
  Widget build(BuildContext context) {
    
    CustomUser user;
    user = widget.user != null ? widget.user : Provider.of<CustomUser>(context);

    //DatabaseService _db = DatabaseService(user: user);

    return user != null ?
      DefaultTabController(
        length: widget.self ? 2 : 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(user.username),
            actions: widget.self ? [
              myPopUpMenu(context, user)
            ] : [],
            bottom: widget.self ?
            TabBar(
              tabs: [
                Tab(text: 'Information',
                    icon: Icon(Icons.info_outline)),
                Tab(text: 'Reviews',
                    icon: Icon(Icons.rate_review_outlined)
                ),
              ],
            ) : TabBar(
              tabs: [
                Tab(text: 'Information',
                    icon: Icon(Icons.info_outline)),
                Tab(text: 'Library',
                    icon: Icon(Icons.menu_book)),
                Tab(text: 'Reviews',
                    icon: Icon(Icons.rate_review_outlined)
                ),
              ],
            ),
          ),
          body: widget.self ?
          TabBarView(
            children: [
              UserInfo(user: user, self: widget.self),
              ReviewsMainPage(receivedReviews: user.receivedReviews, reviewsWrittenByMe: user.reviewsWrittenByMe, self: widget.self),
            ],
          ) : TabBarView(
            children: [
              UserInfo(user: user, self: widget.self),
              widget.books != null ? MyBooks(books: widget.books, self: false, userUid: user.uid) : MyBooks(self: false, userUid: user.uid),   //TODO questo controllo potrebbe essere inutile
              ReceivedReviews(reviews: user.receivedReviews),
            ],
          ),
        ),
      ) : Container();
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