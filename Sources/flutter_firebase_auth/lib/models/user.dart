import 'package:flutter_firebase_auth/models/inserted_book.dart';

class CustomUser {

  final String uid;
  final String email;
  final bool isAnonymous;

  CustomUser({this.uid, this.email, this.isAnonymous});

  @override
  String toString() {
    return
      "User: " +
      this.uid +
      " (isAnonymous? " +
      this.isAnonymous.toString() + ")";
  }
}


class UserData {

  final String uid;
  final String name;
  final List<InsertedBook> books;

  UserData({ this.uid, this.name , this.books });

}