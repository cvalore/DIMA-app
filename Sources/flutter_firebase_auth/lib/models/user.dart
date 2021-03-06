import 'package:flutter_firebase_auth/models/inserted_book.dart';

class CustomUser {

  final String uid;
  final String email;
  final String username;
  final bool isAnonymous;
  final List<InsertedBook> books;

  CustomUser(this.uid, this.email, this.isAnonymous, {this.username, this.books});

  @override
  String toString() {
    return
      "User: " +
      this.uid +
      " (isAnonymous? " +
      this.isAnonymous.toString() + ")";
  }


  Map<String, dynamic> toMap(){
    var user = new Map<String, dynamic>();
    user['uid'] = uid;
    user['email'] = email;
    user['username'] = username;
    user['books'] = [];
    return user;
  }
}