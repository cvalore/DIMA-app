import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPageBody.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class DiscussionPage extends StatefulWidget {

  ForumDiscussion discussion;
  DatabaseService db;
  final Function() updateDiscussionView;

  DiscussionPage({Key key, this.discussion, this.updateDiscussionView}) : super(key: key);

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
        actions: Utils.mySelf.uid != widget.discussion.startedBy ? null : [
          PopupMenuButton(
            color: Colors.white10,
            onSelected: (value) async {
              if(value == 0) {
                ForumDiscussion disc = widget.discussion;
                await Utils.databaseService.removeDiscussion(disc.title);
                Navigator.pop(context);
                widget.updateDiscussionView();
                setState(() { });
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
              value: 0,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.edit, color: Colors.white,),
                  ),
                  Text('Delete', style: TextStyle(color: Colors.white),),
                ],
              ),
            ),]
          ),
        ],
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
