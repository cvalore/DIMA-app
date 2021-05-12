import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/manuallyCloseableExpansionTile.dart';
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
  bool firstTime = true;

  ScrollController _scrollController = ScrollController();

  _scrollToBottom(ForumDiscussion discussion) {
    if(discussion == null || discussion.messages == null || discussion.messages.length == 0) {
      return;
    }
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent + (firstTime ? 300.0 : 0.0));
    firstTime = false;
  }


  @override
  void initState() {
    super.initState();
    firstTime = true;
  }

  @override
  Widget build(BuildContext context) {
    
    ForumDiscussion discussion = Provider.of<ForumDiscussion>(context);

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(discussion));

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        discussion == null || discussion.messages == null || discussion.messages.length == 0 ?
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No messages yet", style: TextStyle(fontSize: _isTablet ? 17.0 : 15.0, fontStyle: FontStyle.italic),),
                Icon(Icons.message),
              ],
            ),
          ),
        ) :
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: discussion.messages.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.0, _isTablet ? 24.0 : 18.0, 32.0, _isTablet ? 24.0 : 18.0),
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
                                        backgroundColor: Colors.teal[100],
                                        radius: 35.0,
                                        child: Text(
                                          discussion.messages[index].nameSender[0].toUpperCase(),
                                          //textScaleFactor: 3,
                                        ),
                                      ),
                                    ),*/
                                    Text(discussion.messages[index].nameSender == null || discussion.messages[index].nameSender == "" ?
                                      "ANONYMOUS:"+discussion.messages[index].uidSender :
                                      discussion.messages[index].nameSender,
                                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      discussion.messages[index].time.toString().split(' ')[0],
                                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 : 14.0),
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
                          flex: _isTablet ? 7 : 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Text(discussion.messages[index].messageBody,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isTablet ? 18.0 : 16.0),
                                      overflow: TextOverflow.visible
                                  ),
                                ),
                              ),
                              Text(
                                discussion.messages[index].time.toString().split(' ')[1].split('.')[0].substring(0, 5),
                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 :  14.0),
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

                        if(Utils.mySelf.isAnonymous != null && Utils.mySelf.isAnonymous) {
                          CustomUser userFromDb = CustomUser(Utils.mySelf.uid, username: null);
                          List<Message> messages = await widget.db.addMessageToForum(_message, discussion, userFromDb);
                          setState(() {
                            _messageFormFieldController.clear();
                            _message = "";
                            //discussion.messages = messages;
                          });
                          return;
                        }

                        CustomUser userFromDb = await widget.db.getUserById(widget.user.uid);
                        List<Message> messages = await widget.db.addMessageToForum(_message, discussion, userFromDb);
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
