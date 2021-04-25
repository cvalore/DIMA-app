import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class Chat {
  String chatKey;
  final String userUid1;
  final String userUid2;
  final String otherUsername;
  List<Message> messages;
  final DateTime time;

  Chat(this.userUid1, this.userUid2, this.otherUsername, this.messages, this.time);

  setKey() {
    String keyPart1 = userUid1.compareTo(userUid2) > 0 ? userUid1 : userUid2;
    String keyPart2 = userUid1.compareTo(userUid2) > 0 ? userUid2 : userUid1;
    this.chatKey = Utils.encodeBase64(keyPart1 + "_" + keyPart2);
  }

  setKnownKey(String key) {
    this.chatKey = key;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> chatMap = Map<String, dynamic>();
    chatMap['chatKey'] = chatKey;
    chatMap['userUid1'] = userUid1;
    chatMap['userUid2'] = userUid2;
    chatMap['otherUsername'] = otherUsername;
    chatMap['time'] = time;
    List<dynamic> messagesMap = messages.map((e) => e.toMap()).toList();
    chatMap['messages'] = messagesMap;
    return chatMap;
  }

  static Chat FromDynamicToChat(dynamic chatMap, List<Message> messages) {
    bool timestamp = chatMap['time'].runtimeType == Timestamp;

    Chat chat = Chat(
      chatMap['userUid1'],
      chatMap['userUid1'],
      chatMap['otherUsername'],
        messages,
        timestamp ?
        DateTime.fromMillisecondsSinceEpoch(chatMap['time'].seconds * 1000) :
        chatMap['time'],
    );
    chat.setKnownKey(chatMap['chatKey']);
    return chat;
  }
}