import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';

class DiscussionTabBody extends StatelessWidget {

  final dynamic discussions;

  const DiscussionTabBody({Key key, this.discussions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final Map<String, dynamic> perCategoryDiscussion = {};

    forumDiscussionCategories.forEach((e) {
      perCategoryDiscussion.addAll({e: []});
    });

    discussions.forEach((e) {
      List<dynamic> newValue = perCategoryDiscussion[e['category']] ?? [];
      newValue.addAll([e]);
      perCategoryDiscussion.update(e['category'], (value) => newValue, ifAbsent: () => [e]);
    });
    
    return discussions.length == 0 ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No discussions yet",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 15
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.5),
              child: Icon(Icons.info_outline)
            ),
          ],
        ) :
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Active threads:", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      for(int i = 0; i < forumDiscussionCategories.length; i++)
                        Column(
                          children: <Widget>[
                            i == 0 ? Padding(padding: const EdgeInsets.only(top: 24.0),) : Container(),
                            ManuallyCloseableExpansionTile(
                              title: Container(
                                height: MediaQuery.of(context).size.height / 8,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(forumDiscussionCategories[i],
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              children: <Widget>[
                                for(int j = 0; j < perCategoryDiscussion[forumDiscussionCategories[i]].length; j++)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0, 18.0, 32.0, 18.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Text('Started by', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 10.0, vertical: 8.0),
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.brown.shade800,
                                                    radius: 40.0,
                                                    child: perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedByProfilePicture'] != null &&
                                                        perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedByProfilePicture'] != '' ?
                                                    CircleAvatar(
                                                      radius: 40.0,
                                                      backgroundImage: NetworkImage(
                                                          perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedByProfilePicture']),
                                                      //FileImage(File(user.userProfileImagePath))
                                                    ) : Text(
                                                      perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedByUsername'].toUpperCase(),
                                                      //textScaleFactor: 3,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Flexible(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(perCategoryDiscussion[forumDiscussionCategories[i]][j]['title'],
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Padding(padding: const EdgeInsets.symmetric(vertical: 2.0),),
                                                  Text("Messages: " + perCategoryDiscussion[forumDiscussionCategories[i]][j]['messages'].length.toString(),
                                                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
  }
}
