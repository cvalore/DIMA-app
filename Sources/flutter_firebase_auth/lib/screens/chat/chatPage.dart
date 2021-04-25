import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/chatPageBody.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPageBody.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {

  Chat chat;
  DatabaseService db;

  ChatPage({Key key, this.chat}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(
        userFromAuth != null ? userFromAuth.uid : "",
        email: userFromAuth != null ? userFromAuth.email : "",
        isAnonymous: userFromAuth != null ? userFromAuth.isAnonymous : false);
    widget.db = DatabaseService(user: user);
    widget.db.setChat(widget.chat);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.otherUsername),
      ),
      body: StreamProvider<Chat>.value(
        value: widget.db.chatInfo,
        child: ChatPageBody(
          db: widget.db,
          user: user,
        ),
      ),
    );
  }
}
