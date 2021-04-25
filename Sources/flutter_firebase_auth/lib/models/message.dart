import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class Message {
  String messageKey;
  final String uidSender;
  String nameSender;
  final DateTime time;

  final String messageBody;

  Message(this.uidSender, this.nameSender, this.time, this.messageBody);

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
    forumMessageMap['time'] = time;
    forumMessageMap['messageBody'] = messageBody;
    return forumMessageMap;
  }

  static Message fromDynamicToMessage(dynamic element) {

    bool timestamp = element['time'].runtimeType == Timestamp;

    Message message = Message(
        element['uidSender'],
        element['nameSender'],
        timestamp ?
          DateTime.fromMillisecondsSinceEpoch(element['time'].seconds * 1000) :
          element['time'],
        element['messageBody']
    );
    message.setKnownKey(element['messageKey']);
    return message;
  }
}