import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

import 'discussionTabBody.dart';

class DiscussionTab extends StatefulWidget {

  final DatabaseService db;

  const DiscussionTab({Key key, this.db}) : super(key: key);

  @override
  _DiscussionTabState createState() => _DiscussionTabState();
}

class _DiscussionTabState extends State<DiscussionTab> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.db.getForumDiscussions(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return Center(child: Loading());
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return FutureBuilder(
                future: getDiscussionStartedByUserInfo(snapshot.data),
                builder: (BuildContext context, AsyncSnapshot<dynamic> newSnapshot) {
                  switch (newSnapshot.connectionState) {
                    case ConnectionState.waiting: return Center(child: Loading());
                    default:
                      if (newSnapshot.hasError)
                        return Text('Error: ${newSnapshot.error}');
                      else
                        return DiscussionTabBody(discussions: snapshot.data);
                  }
                },
              );
        }
      },
    );
  }

  Future<dynamic> getDiscussionStartedByUserInfo(dynamic discussions) async {
    for(int i = 0; i < discussions.length; i++) {
      CustomUser user = await widget.db.getUserById(discussions[i]['startedBy']);
      discussions[i]['startedByUsername'] = user.username;
      discussions[i]['startedByProfilePicture'] = user.userProfileImageURL;
    }
  }

}
