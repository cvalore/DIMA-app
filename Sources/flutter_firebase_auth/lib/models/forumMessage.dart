import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class ForumMessage {
  String messageKey;
  final String uidSender;
  String nameSender;
  String imageProfileSender;
  final DateTime time;

  final String messageBody;

  ForumMessage(this.uidSender, this.nameSender, this.imageProfileSender, this.time, this.messageBody);

  setKey() {
    this.messageKey = Utils.encodeBase64(uidSender + time.toString());
  }
  
  setKnownKey(String key) {
    this.messageKey = key;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> forumMessageMap = Map<String, dynamic>();
    forumMessageMap['messageKey'] = messageKey;
    forumMessageMap['uidSender'] = uidSender;
    forumMessageMap['nameSender'] = nameSender;
    forumMessageMap['imageProfileSender'] = imageProfileSender;
    forumMessageMap['time'] = time;
    forumMessageMap['messageBody'] = messageBody;
    return forumMessageMap;
  }

  static ForumMessage fromDynamicToForumMessage(dynamic element) {

    bool timestamp = element['time'].runtimeType == Timestamp;

    ForumMessage message = ForumMessage(
        element['uidSender'],
        element['nameSender'],
        element['imageProfileSender'],
        timestamp ?
          DateTime.fromMillisecondsSinceEpoch(element['time'].seconds * 1000) :
          element['time'],
        element['messageBody']
    );
    message.setKnownKey(element['messageKey']);
    return message;
  }
}