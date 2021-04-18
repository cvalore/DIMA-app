import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/services/database.dart';

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
          int success = await getDb().createNewDiscussion(
              getDropdownLabel(), getTitle()
          );
          String snackBarMessage =
            (success == 1 ?
              "Discussion successfully inserted" :
              success == 0 ?
                "Discussion already exists" :
                "Error while inserting the discussion"
            );
          final snackBar = SnackBar(
            backgroundColor: Colors.white24,
            duration: Duration(seconds: 1),
            content: Text(
              snackBarMessage,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
          Navigator.pop(context);
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      child: Icon(Icons.check),
    );
  }
}
