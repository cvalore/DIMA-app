import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPage.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class NewDiscussionPageFloatingButton extends StatelessWidget {

  final Function() getFormKey;
  final Function() getTitle;
  final Function() getDropdownLabel;
  final Function() getDb;
  final Function() updateDiscussionView;

  const NewDiscussionPageFloatingButton({Key key, this.getFormKey, this.getTitle, this.getDropdownLabel, this.getDb, this.updateDiscussionView,}) : super(key: key);

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
            backgroundColor: Colors.grey.withOpacity(1.0),
            duration: Duration(seconds: 1),
            content: Text(
              snackBarMessage,
              style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.black),
            ),
          );
          Navigator.pop(context);
          if(discussion != null) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    DiscussionPage(
                      discussion: Utils.toForumDiscussion(discussion),
                      updateDiscussionView: updateDiscussionView,
                    ))
            );
          }
          Scaffold.of(context).showSnackBar(snackBar);
          updateDiscussionView();
        }
      },
      child: Icon(Icons.check),
    );
  }
}