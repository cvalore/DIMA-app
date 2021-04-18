import 'package:flutter_firebase_auth/utils/utils.dart';

class ForumMessage {
  String messageKey;
  final String uidSender;
  final String nameSender;
  final String imageProfileSender;
  final DateTime time;

  final String messageBody;

  ForumMessage(this.uidSender, this.nameSender, this.imageProfileSender, this.time, this.messageBody);

  setKey() {
    this.messageKey = Utils.encodeBase64(uidSender + time.toString());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> forumMessageMap = Map<String, dynamic>();
    forumMessageMap['messageKey'] = messageKey;
    forumMessageMap['uidSender'] = uidSender;
    forumMessageMap['time'] = time.toString();
    forumMessageMap['messageBody'] = messageBody;
    return forumMessageMap;
  }
}