import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:provider/provider.dart';

import 'discussionTabBody.dart';

class DiscussionTab extends StatefulWidget {
  @override
  _DiscussionTabState createState() => _DiscussionTabState();
}

class _DiscussionTabState extends State<DiscussionTab> {

  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(
        userFromAuth != null ? userFromAuth.uid : "",
        email: userFromAuth != null ? userFromAuth.email : "",
        isAnonymous: userFromAuth != null ? userFromAuth.isAnonymous : false);
    DatabaseService _db = DatabaseService(user: user);

    return FutureBuilder(
      future: _db.getForumDiscussions(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return Center(child: Loading());
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return DiscussionTabBody(discussions: snapshot.data);
        }
      },
    );
  }
}
