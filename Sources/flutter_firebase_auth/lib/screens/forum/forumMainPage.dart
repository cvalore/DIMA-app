import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionTab.dart';
import 'package:flutter_firebase_auth/screens/forum/newDiscussionPage.dart';

class ForumMainPage extends StatefulWidget {

  @override
  _ForumMainPageState createState() => _ForumMainPageState();
}

class _ForumMainPageState extends State<ForumMainPage> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "newForumThread",
          icon: Icon(Icons.add_circle_outline_outlined),
          label: Text("New discussion"),
          onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewDiscussionPage())
              );
          },
        ),
        body: Center(child: DiscussionTab()),
    );
  }
}
