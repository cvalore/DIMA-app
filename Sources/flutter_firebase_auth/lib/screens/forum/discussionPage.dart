import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/forumMessage.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPageBody.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class DiscussionPage extends StatefulWidget {

  ForumDiscussion discussion;
  DatabaseService db;

  DiscussionPage({Key key, this.discussion}) : super(key: key);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(
        userFromAuth != null ? userFromAuth.uid : "",
        email: userFromAuth != null ? userFromAuth.email : "",
        isAnonymous: userFromAuth != null ? userFromAuth.isAnonymous : false);
    widget.db = DatabaseService(user: user);
    widget.db.setForumDiscussion(widget.discussion);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.discussion.title),
      ),
      body: StreamProvider<ForumDiscussion>.value(
        value: widget.db.discussionInfo,
        child: DiscussionPageBody(
          db: widget.db,
          user: user,
        ),
      ),
    );
  }
}
