import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/review.dart';

import 'bookILike.dart';

class CustomUser {

  final String uid;
  final String email;
  final String username;
  String city;
  String bio;
  String fullName;
  String birthday;
  int followers;
  int following;
  List<String> usersFollowedByMe;   //users by uid
  List<String> usersFollowingMe;
  final bool isAnonymous;
  final List<InsertedBook> books;
  final List<ReceivedReview> receivedReviews;
  final List<ReviewWrittenByMe> reviewsWrittenByMe;
  List<String> transactionsAsSeller;
  List<String> transactionsAsBuyer;
  List<BookILike> booksILike;
  double averageRating;
  String userProfileImagePath;
  String userProfileImageURL;
  int numberOfInsertedItems;

  CustomUser(this.uid, {
    this.email,
    this.isAnonymous,
    this.username,
    this.books,
    this.numberOfInsertedItems,
    this.userProfileImagePath,
    this.userProfileImageURL,
    this.receivedReviews,
    this.reviewsWrittenByMe,
    this.transactionsAsSeller,
    this.transactionsAsBuyer,
    this.booksILike,
    this.bio,
    this.followers,
    this.following,
    this.averageRating,
    this.city,
    this.fullName,
    this.birthday,
    this.usersFollowedByMe,
    this.usersFollowingMe
  });

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
    user['fullName'] = fullName != null ? fullName : '';
    user['birthday'] = birthday != null ? birthday : '';
    user['city'] = city != null ? city : '';
    user['usersFollowedByMe'] = usersFollowedByMe != null ? usersFollowedByMe : [];
    user['usersFollowingMe'] = usersFollowingMe != null ? usersFollowingMe : [];
    user['receivedReviews'] = receivedReviews != null ? receivedReviews : [];
    user['reviewsWrittenByMe'] = reviewsWrittenByMe != null ? reviewsWrittenByMe : [];
    user['transactionsAsSeller'] = transactionsAsSeller != null ? transactionsAsSeller : [];
    user['transactionsAsBuyer'] = transactionsAsBuyer != null ? transactionsAsBuyer : [];
    user['booksILike'] = booksILike != null ? booksILike : [];
    user['followers'] = followers != null ? followers : 0;
    user['following'] = following != null ? following : 0;
    user['userProfileImageURL'] = userProfileImageURL != null ? userProfileImageURL : '';
    user['userProfileImagePath'] = '';
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