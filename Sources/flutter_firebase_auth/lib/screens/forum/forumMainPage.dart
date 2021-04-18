import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionTab.dart';
import 'package:flutter_firebase_auth/screens/forum/newDiscussionPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';

class ForumMainPage extends StatefulWidget {

  @override
  _ForumMainPageState createState() => _ForumMainPageState();
}

class _ForumMainPageState extends State<ForumMainPage> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(
        userFromAuth != null ? userFromAuth.uid : "",
        email: userFromAuth != null ? userFromAuth.email : "",
        isAnonymous: userFromAuth != null ? userFromAuth.isAnonymous : false);
    DatabaseService _db = DatabaseService(user: user);

     return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "newForumThread",
          icon: Icon(Icons.add_circle_outline_outlined),
          label: Text("New discussion"),
          onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewDiscussionPage(db: _db,))
              );
          },
        ),
        body: DiscussionTab(db: _db),
    );
  }
}
