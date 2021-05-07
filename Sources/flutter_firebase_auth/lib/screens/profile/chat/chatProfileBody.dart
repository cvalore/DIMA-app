import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/chatPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class ChatProfileBody extends StatelessWidget {

  final List<Chat> chats;
  final Timestamp lastChatsDate;

  const ChatProfileBody({Key key, this.chats, this.lastChatsDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return chats.length == 0 ?
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("No chats yet",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: _isTablet ? 17.0 : 15.0,
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.5),
            child: Icon(Icons.info_outline)
        ),
      ],
    ) :
    Padding(
      padding: EdgeInsets.symmetric(vertical: _isTablet ? 18.0 : 0.0, horizontal: _isTablet ? 32.0 : 12.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              for(int i = 0; i < chats.length; i++)
                Column(
                  children: <Widget>[
                    i == 0 ? Padding(padding: const EdgeInsets.only(top: 24.0),) : Container(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: _isTablet ? 6.0 : 4.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatPage(
                                chat: chats[i],
                              ))
                          );
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Card(
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
                                          String userUid = chats[i].userUid1 == Utils.mySelf.uid ?
                                            chats[i].userUid2 :
                                            chats[i].userUid2 == Utils.mySelf.uid ?
                                              chats[i].userUid1 :
                                              chats[i].userUid2;

                                          DatabaseService databaseService = DatabaseService(
                                              user: CustomUser(userUid));
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
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Text(chats[i].userUid1 == Utils.mySelf.uid ? chats[i].userUid2Username : chats[i].userUid1Username,
                                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(DateTime.parse(
                                                chats[i].time.toString()
                                            ).toString().split(' ')[0],
                                              style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(DateTime.parse(
                                                chats[i].time.toString()
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
                                          Text("Last message sent",
                                            style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Padding(padding: const EdgeInsets.symmetric(vertical: 2.0),),
                                          Text(
                                            chats[i].messages == null || chats[i].messages.length == 0 ?
                                            "No messages yet" :
                                            chats[i].messages[chats[i].messages.length - 1].messageBody,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: _isTablet ? 19.0 : 16.0,
                                                fontStyle:
                                                chats[i].messages == null || chats[i].messages.length == 0 ?
                                                FontStyle.italic :
                                                FontStyle.normal
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            chats[i].showNew ? Icon(Icons.fiber_new) : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
