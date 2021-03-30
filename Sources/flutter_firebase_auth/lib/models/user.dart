import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/review.dart';

class CustomUser {

  final String uid;
  final String email;
  final String username;
  final String city;
  final String bio;
  final int followers;
  final int following;
  final bool isAnonymous;
  final List<InsertedBook> books;
  final List<Review> reviews;
  String userProfileImagePath;    //TODO
  int numberOfInsertedItems;

  CustomUser(this.uid, this.email, this.isAnonymous, {this.username, this.books, this.numberOfInsertedItems, this.userProfileImagePath, this.reviews, this.bio, this.followers, this.following, this.city});

  void setNumberOfInsertedItems(int num){
    this.numberOfInsertedItems = num;
  }

  void setUserProfileImagePath(String userProfileImagePath){
    this.userProfileImagePath = userProfileImagePath;
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
    user['bio'] = bio != null ? bio : '';
    user['city'] = city != null ? city : '';
    user['followers'] = followers != null ? followers : 0;
    user['following'] = following != null ? following : 0;
    user['books'] = [];
    user['numberOfInsertedItems'] = books != null ? books.length : user['numberOfInsertedItems'] = 0;
    return user;
  }
}


class AuthCustomUser{

  final String uid;
  final String email;
  final bool isAnonymous;

  AuthCustomUser(this.uid, this.email, this.isAnonymous);
}