import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class ForumDiscussion {
  String discussionKey;
  final String startedBy;
  final String title;
  final String category;
  List<Message> messages;
  final DateTime time;

  String startedByProfilePicture;
  String startedByUsername;

  ForumDiscussion(this.title, this.category, this.messages, this.time, this.startedBy);

  setKey() {
    this.discussionKey = Utils.encodeBase64(title + "_" + category + "_" + time.toString());
  }
  
  setKnownKey(String key) {
    this.discussionKey = key;
  }

  setStartedByProfilePicture(String value) {
    this.startedByProfilePicture = value;
  }

  setStartedByUsername(String value) {
    this.startedByUsername = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> discussionForumMap = Map<String, dynamic>();
    discussionForumMap['discussionKey'] = discussionKey;
    discussionForumMap['startedBy'] = startedBy;
    discussionForumMap['title'] = title;
    discussionForumMap['category'] = category;
    discussionForumMap['time'] = time;
    List<dynamic> messagesMap = messages.map((e) => e.toMap()).toList();
    discussionForumMap['messages'] = messagesMap;
    return discussionForumMap;
  }

  static ForumDiscussion FromDynamicToForumDiscussion(dynamic discussion, List<Message> messages) {
    bool timestamp = discussion['time'].runtimeType == Timestamp;

    ForumDiscussion disc = ForumDiscussion(
        discussion['title'],
        discussion['category'],
        messages,
        timestamp ?
          DateTime.fromMillisecondsSinceEpoch(discussion['time'].seconds * 1000) :
          discussion['time'],
        discussion['startedBy']
    );
    disc.setKnownKey(discussion['discussionKey']);
    return disc;
  }
}