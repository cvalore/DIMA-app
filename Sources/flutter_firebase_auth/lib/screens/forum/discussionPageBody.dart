import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/forumMessage.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class DiscussionPageBody extends StatefulWidget {

  final DatabaseService db;
  final CustomUser user;

  const DiscussionPageBody({Key key, this.db, this.user}) : super(key: key);

  @override
  _DiscussionPageBodyState createState() => _DiscussionPageBodyState();
}

class _DiscussionPageBodyState extends State<DiscussionPageBody> {

  final GlobalKey<FormState> _messageFormKey = GlobalKey();
  final _messageFormFieldController = TextEditingController();

  String _message = "";

  @override
  Widget build(BuildContext context) {
    
    ForumDiscussion discussion = Provider.of<ForumDiscussion>(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        discussion == null || discussion.messages == null || discussion.messages.length == 0 ?
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No messages yet", style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),),
                Icon(Icons.message),
              ],
            ),
          ),
        ) :
        Expanded(
          child: ListView.builder(
            itemCount: discussion.messages.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 18.0, 32.0, 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                            child: InkWell(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              onTap: () async {
                                if (discussion.messages[index].uidSender != Utils.mySelf.uid) {
                                  DatabaseService databaseService = DatabaseService(
                                      user: CustomUser(
                                          discussion.messages[index].uidSender));
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
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  children: <Widget>[
                                    //Text('Sent by', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),),
                                    /*Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 8.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.brown.shade800,
                                        radius: 35.0,
                                        child: Text(
                                          discussion.messages[index].nameSender[0].toUpperCase(),
                                          //textScaleFactor: 3,
                                        ),
                                      ),
                                    ),*/
                                    Text(discussion.messages[index].nameSender,
                                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      discussion.messages[index].time.toString().split(' ')[0],
                                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    /*Text(
                                      discussion.messages[index].time.toString().split(' ')[1].split('.')[0],
                                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    )*/
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Text(discussion.messages[index].messageBody,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.visible
                                  ),
                                ),
                              ),
                              Text(
                                discussion.messages[index].time.toString().split(' ')[1].split('.')[0].substring(0, 5),
                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14.0),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        ManuallyCloseableExpansionTile(
          initiallyExpanded: true,
          title: Text("Send a new message on this discussion!"),
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Form(
                    key: _messageFormKey,
                    child: Flexible(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Container(
                          //width: MediaQuery.of(context).size.width / 1.5,
                          child: TextFormField(
                            controller: _messageFormFieldController,
                            maxLength: maxForumMessageLength,
                            maxLines: null,
                            //expands: true,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(fontSize: 16,
                                //color: Colors.white
                              ),
                              labelText: "Message",
                              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                              //hintStyle: TextStyle(color: Colors.white,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(7.0),),
                                //borderSide: BorderSide(color: Colors.white)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                //borderSide: BorderSide(color: Colors.white)
                              ),
                              filled: true,
                              //fillColor: Colors.white24,
                            ),
                            validator: (value) =>
                            value.isEmpty
                                ?
                            'Enter a valid message' : null,
                            onChanged: (value) {
                              setState(() {
                                _message = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: MaterialButton(
                      onPressed: () async {
                        CustomUser userFromDb = await widget.db.getUserById(widget.user.uid);
                        List<ForumMessage> messages = await widget.db.addMessage(_message, discussion, userFromDb);
                        setState(() {
                          _messageFormFieldController.clear();
                          _message = "";
                          //discussion.messages = messages;
                        });
                      },
                      shape: CircleBorder(side: BorderSide(width: 2, color: Colors.white, style: BorderStyle.solid)),
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
