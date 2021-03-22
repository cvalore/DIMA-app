import 'package:flutter_firebase_auth/models/insertedBook.dart';

class CustomUser {

  final String uid;
  final String email;
  final String username;
  final bool isAnonymous;
  final List<InsertedBook> books;
  int numberOfInsertedItems;

  CustomUser(this.uid, this.email, this.isAnonymous, {this.username, this.books, this.numberOfInsertedItems});

  void setNumberOfInsetedItems(int num){
    this.numberOfInsertedItems = num;
  }


  @override
  String toString() {
    return
      "User: " +
      this.uid +
      " (isAnonymous? " +
      this.isAnonymous.toString() + ")";
  }


  Map<String, dynamic> toMap() {
    var user = new Map<String, dynamic>();
    user['uid'] = uid;
    user['email'] = email;
    user['username'] = username;
    user['books'] = [];
    books != null ? user['numberOfInsertedItems'] = books.length :
      user['numberOfInsertedItems'] = 0;
    return user;
  }
}