import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class NewDiscussionPageFloatingButton extends StatelessWidget {

  final Function() getFormKey;
  final Function() getTitle;
  final Function() getDropdownLabel;
  final Function() getDb;

  const NewDiscussionPageFloatingButton({Key key, this.getFormKey, this.getTitle, this.getDropdownLabel, this.getDb,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        if(!getFormKey().currentState.validate()) {
          return;
        }
        else {
          dynamic discussion = await getDb().createNewDiscussion(
              getDropdownLabel(), getTitle()
          );
          String snackBarMessage =
          (discussion != null ?
          "Discussion successfully inserted" :
          "Error creating discussion OR Discussion already exists");
          final snackBar = SnackBar(
            backgroundColor: Colors.white24,
            duration: Duration(seconds: 1),
            content: Text(
              snackBarMessage,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
          Navigator.pop(context);
          if(discussion != null) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    DiscussionPage(
                      discussion: Utils.toForumDiscussion(discussion),
                    ))
            );
          }
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      child: Icon(Icons.check),
    );
  }
}