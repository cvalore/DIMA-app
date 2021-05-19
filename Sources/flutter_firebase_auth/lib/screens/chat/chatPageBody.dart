import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class ChatPageBody extends StatefulWidget {

  final DatabaseService db;
  final CustomUser user;

  const ChatPageBody({Key key, this.db, this.user}) : super(key: key);

  @override
  ChatPageBodyState createState() => ChatPageBodyState();
}

class ChatPageBodyState extends State<ChatPageBody> {

  final GlobalKey<FormState> _messageFormKey = GlobalKey();
  final _messageFormFieldController = TextEditingController();

  String message = "";
  bool firstTime = true;

  ScrollController _scrollController = ScrollController();

  _scrollToBottom(Chat chat) {
    if(chat == null || chat.messages == null || chat.messages.length == 0) {
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

    Chat chat = Provider.of<Chat>(context);

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(chat));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        chat == null || chat.messages == null || chat.messages.length == 0 ?
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
            itemCount: chat.messages.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8.0, _isTablet ? 24.0 : 18.0, 32.0, _isTablet ? 24.0 : 18.0),
                    child:
                    chat.messages[index].uidSender == Utils.mySelf.uid ?
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          /*decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2.0),
                          ),*/
                          alignment: AlignmentDirectional.centerEnd,
                          width: _isTablet ? 150.0 : 52.0,
                        ),
                        Container(
                          /*decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 2.0),
                          ),*/
                          alignment: AlignmentDirectional.centerEnd,
                          width: MediaQuery.of(context).size.width - (_isTablet ? 200.0 : 100.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Card(
                                color: chat.messages[index].uidSender == Utils.mySelf.uid ?
                                  Colors.blue[500] : Colors.blueGrey[700],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Text(chat.messages[index].messageBody,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isTablet ? 18.0 : 16.0),
                                      overflow: TextOverflow.visible
                                  ),
                                ),
                              ),
                              Text(
                                  chat.messages[index].time.toString().split(' ')[0] + " " + chat.messages[index].time.toString().split(' ')[1].split('.')[0].substring(0, 5),
                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 :  14.0),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        )
                      ],
                    ) :
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - (_isTablet ? 200.0 : 100.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Card(
                                color: chat.messages[index].uidSender == Utils.mySelf.uid ?
                                Colors.blue[500] : Colors.blueGrey[700],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  child: Text(chat.messages[index].messageBody,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isTablet ? 18.0 : 16.0),
                                      overflow: TextOverflow.visible
                                  ),
                                ),
                              ),
                              Text(
                                  chat.messages[index].time.toString().split(' ')[0] + " " + chat.messages[index].time.toString().split(' ')[1].split('.')[0].substring(0, 5),
                                style: TextStyle(fontStyle: FontStyle.italic, fontSize: _isTablet ? 17.0 :  14.0),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ManuallyCloseableExpansionTile(
            initiallyExpanded: true,
            title: Text("Send a new message on this chat!"),
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
                                  message = value;
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

                          RegExp regExp1 = RegExp(r'(^[ ]*$)');
                          if(regExp1.hasMatch(message)){
                            return;
                          }

                          CustomUser userFromDb = await widget.db.getUserById(widget.user.uid);
                          List<Message> messages = await widget.db.addMessageToChat(message, chat, userFromDb);
                          setState(() {
                            _messageFormFieldController.clear();
                            message = "";
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
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,8.0),
          child: BottomTwoDots(size: 8.0, darkerIndex: 0,),
        ),
      ],
    );
  }
}
