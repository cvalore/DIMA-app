import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeMyProfile/reviews.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeMyProfile/userInfo.dart';


class ProfileHomePage extends StatefulWidget {
  static const routeName = '/profileHomePage';

  CustomUser user;
  bool self;

  ProfileHomePage({Key key, @required this.user, @required this.self}) : super(key: key);

  @override
  _ProfileHomePageState createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.username),
          bottom: TabBar(
            tabs: [
              Tab(text: 'My library',
                  icon: Icon(Icons.menu_book)),
              Tab(text: 'Reviews',
                  icon: Icon(Icons.rate_review_outlined)),
              Tab(text: 'Information',
                  icon: Icon(Icons.info_outline)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //MyBooks(),
            //Reviews(),
            //UserInfo(),
            Text('Here we are'),
            Reviews(reviews: widget.user.reviews, self: true),
            UserInfo(user: widget.user, self: true)
          ],
        ),
      ),
    );
  }
}

/*
Container(
child: Text('//TODO'));

 */