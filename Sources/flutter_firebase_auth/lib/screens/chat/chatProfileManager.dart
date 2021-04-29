import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/chat/chatProfileFake.dart';
import 'package:flutter_firebase_auth/screens/profile/chat/chatProfile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class ChatProfileManager extends StatelessWidget {

  final double height;
  Timestamp lastChatsDate;

  ChatProfileManager({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getChatsData(),
        builder: (BuildContext context,
            AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return ChatProfileFake(height: height,);
          else
            return ChatProfile(
              height: height,
              chatsMap: snapshot.data,
              lastChatsDate: lastChatsDate,
            );
        }
    );
  }

  Future<dynamic> getChatsData() async {
    lastChatsDate = await Utils.databaseService.getLastChatsDate();
    return Utils.databaseService.getMyChats();
  }

}
