import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/chatPageBody.dart';
import 'package:flutter_firebase_auth/screens/chat/pendingPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chatPage';

  Chat chat;
  DatabaseService db;

  ChatPage({Key key, this.chat}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth;
    try {
      userFromAuth = Provider.of<AuthCustomUser>(context);
    } catch(Exception) {
      print("Cannot read value from AuthCustomUser stream provider");
    }

    CustomUser user = CustomUser(
        userFromAuth != null ? userFromAuth.uid : "",
        email: userFromAuth != null ? userFromAuth.email : "",
        isAnonymous: userFromAuth != null ? userFromAuth.isAnonymous : false);
    widget.db = DatabaseService(user: user);
    widget.db.setChat(widget.chat);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.userUid1 == Utils.mySelf.uid ? widget.chat.userUid2Username : widget.chat.userUid1Username),
      ),
      body: StreamProvider<Chat>.value(
        value: widget.db.chatInfo,
        child: DefaultTabController(
          length: 2,
          child: TabBarView(
            children: <Widget>[
              ChatPageBody(
                db: widget.db,
                user: user,
              ),
              StreamProvider<List<MyTransaction>>.value(
                value: widget.db.transactionsInfo,
                child: PendingPage(
                  db: widget.db,
                  user: user,
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
