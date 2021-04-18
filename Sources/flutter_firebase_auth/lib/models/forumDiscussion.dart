import 'package:flutter_firebase_auth/models/forumMessage.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class ForumDiscussion {
  String discussionKey;
  final String startedBy;
  final String title;
  final String category;
  final List<ForumMessage> messages;
  final DateTime time;

  ForumDiscussion(this.title, this.category, this.messages, this.time, this.startedBy);

  setKey() {
    this.discussionKey = Utils.encodeBase64(title + "_" + category + "_" + time.toString());
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
}