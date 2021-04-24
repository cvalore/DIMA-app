import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/forumMessage.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/forum/discussionPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return discussions.length == 0 ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No discussions yet",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: _isTablet ? 17.0 : 15.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.5),
              child: Icon(Icons.info_outline)
            ),
          ],
        ) :
        Padding(
          padding: EdgeInsets.symmetric(vertical: _isTablet ? 18.0 : 12.0, horizontal: _isTablet ? 32.0 : 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Active threads:", style: TextStyle(fontSize: _isTablet ? 20.0 : 18.0, fontWeight: FontWeight.bold),),
              Expanded(
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
                                      fontSize: _isTablet ? 19.0 : 17.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              children: <Widget>[
                                for(int j = 0; j < perCategoryDiscussion[forumDiscussionCategories[i]].length; j++)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: _isTablet ? 6.0 : 2.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => DiscussionPage(
                                              discussion: Utils.toForumDiscussion(perCategoryDiscussion[forumDiscussionCategories[i]][j]),
                                            ))
                                        );
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(_isTablet ? 32.0 : 8.0, _isTablet ? 28.0 : 18.0, 32.0, _isTablet ? 28.0 : 18.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Flexible(
                                                flex: 1,
                                                child: InkWell(
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                  onTap: () async {
                                                    if (perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedBy'] != Utils.mySelf.uid) {
                                                      DatabaseService databaseService = DatabaseService(
                                                          user: CustomUser(
                                                              perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedBy']));
                                                      CustomUser user = await databaseService
                                                          .getUserSnapshot();
                                                      BookPerGenreUserMap userBooks = await databaseService
                                                          .getUserBooksPerGenreSnapshot();
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (
                                                                  context) =>
                                                                  VisualizeProfileMainPage(
                                                                      user: user,
                                                                      books: userBooks
                                                                          .result,
                                                                      self: false)
                                                          )
                                                      );
                                                    }
                                                  },
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text('Started by', style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 10.0, vertical: 8.0),
                                                        child: CircleAvatar(
                                                          backgroundColor: Colors.brown.shade800,
                                                          radius: 35.0,
                                                          child: perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedByProfilePicture'] != null &&
                                                              perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedByProfilePicture'] != '' ?
                                                          CircleAvatar(
                                                            radius: 35.0,
                                                            backgroundImage: NetworkImage(
                                                                perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedByProfilePicture']),
                                                            //FileImage(File(user.userProfileImagePath))
                                                          ) : Text(
                                                            perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedByUsername'].toUpperCase(),
                                                            //textScaleFactor: 3,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(perCategoryDiscussion[forumDiscussionCategories[i]][j]['startedByUsername'],
                                                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),
                                                        softWrap: true,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Text(DateTime.parse(
                                                          perCategoryDiscussion[forumDiscussionCategories[i]][j]['time'].toDate().toString()
                                                        ).toString().split(' ')[0],
                                                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),
                                                        softWrap: true,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      Text(DateTime.parse(
                                                          perCategoryDiscussion[forumDiscussionCategories[i]][j]['time'].toDate().toString()
                                                      ).toString().split(' ')[1].split('.')[0],
                                                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),
                                                        softWrap: true,
                                                        overflow: TextOverflow.ellipsis,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(perCategoryDiscussion[forumDiscussionCategories[i]][j]['title'],
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isTablet ? 19.0 : 16.0),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Padding(padding: const EdgeInsets.symmetric(vertical: 2.0),),
                                                    Text("Messages: " + perCategoryDiscussion[forumDiscussionCategories[i]][j]['messages'].length.toString(),
                                                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),
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
                                  ),
                              ],
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
