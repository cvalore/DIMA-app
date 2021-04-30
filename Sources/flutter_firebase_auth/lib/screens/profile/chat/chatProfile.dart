import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

import 'chatProfileBody.dart';

class ChatProfile extends StatelessWidget {

  final double height;
  bool newNotifications = false;
  final dynamic chatsMap;
  final Timestamp lastChatsDate;

  ChatProfile({Key key, this.height, this.chatsMap, this.lastChatsDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Chat> chats = List<Chat>();
    chats = createChatsList();
    setNewNotifications(chats);

    return Container(
        height: height,
        child: InkWell(
          onTap: () async {

            //Timestamp lastChatsDate = await Utils.databaseService.getLastChatsDate();
            await Utils.databaseService.setNowAsLastChatsDate();

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              /*return FutureBuilder(
                  future: Utils.databaseService.getMyChats(),
                  builder: (BuildContext context,
                      AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Loading();
                    else
                      return Scaffold(
                          resizeToAvoidBottomInset: false,
                          //backgroundColor: Colors.black,
                          appBar: AppBar(
                            //backgroundColor: Colors.black,
                            elevation: 0.0,
                            title: Text('My chats', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              letterSpacing: 1.0,
                            ),),
                          ),
                          body: ChatProfileBody(chatsMap: snapshot.data, lastChatsDate: lastChatsDate,)
                      );
                  }
              );*/
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  //backgroundColor: Colors.black,
                  appBar: AppBar(
                    //backgroundColor: Colors.black,
                    elevation: 0.0,
                    title: Text('My chats', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      letterSpacing: 1.0,
                    ),),
                  ),
                  body: ChatProfileBody(
                    chats: chats,
                    lastChatsDate: lastChatsDate,
                  )
              );
            }));
          },
          child: Row(
            children: [
              Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.message_outlined,
                            ),
                          )
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Chats",
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      newNotifications ? Icon(Icons.fiber_new) : Container(),
                    ],
                  )
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              )
            ],
          ),
        )
    );
  }

  List<Chat> createChatsList() {
    List<Chat> newChatsList = List<Chat>();
    chatsMap.forEach((elem) {
      List<Message> messages = List<Message>();
      elem['messages'].forEach((e) {
        messages.add(Message.fromDynamicToMessage(e));
      });
      newChatsList.add(Chat.FromDynamicToChat(elem, messages));
    });

    newChatsList.forEach((elem) {
      bool showNew = false;
      if(lastChatsDate != null) {
        DateTime lastChatsDateTime = DateTime.fromMillisecondsSinceEpoch(lastChatsDate.seconds * 1000);
        for(int i = 0; i < elem.messages.length; i++) {
          if(elem.messages[i].uidSender != Utils.mySelf.uid && elem.messages[i].time.compareTo(lastChatsDateTime) > 0) {
            showNew = true;
            break;
          }
        }

        showNew = !showNew ? elem.time.compareTo(lastChatsDateTime) > 0 && elem.userUid1Username != Utils.mySelf.uid : showNew;
      }
      else {
        showNew = true;
      }
      elem.setShowNew(showNew);
    });
    return newChatsList;
  }

  void setNewNotifications(List<Chat> chats) {
    newNotifications = false;
    if(lastChatsDate == null) {
      newNotifications = true;
    }
    else {
      DateTime lastChatsDateTime = DateTime.fromMillisecondsSinceEpoch(lastChatsDate.seconds * 1000);
      for(int i = 0; chats != null && i < chats.length; i++) {
        if(chats[i].time.compareTo(lastChatsDateTime) > 0) {
          newNotifications = true;
          break;
        }
      }
      if(!newNotifications) {
        for(int i = 0; i < chats.length; i++) {
          for(int j = 0; chats[i].messages != null && j < chats[i].messages.length; j++) {
            if (chats[i].messages[j].time.compareTo(lastChatsDateTime) > 0) {
              newNotifications = true;
              break;
            }
          }
        }
      }
    }
  }

}
