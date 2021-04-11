import 'package:flutter_firebase_auth/utils/utils.dart';

class ReceivedReview {

  String key;
  String review;
  int stars;
  String reviewerUid;
  String reviewerUsername;
  String reviewerImageProfileURL;
  DateTime time;

  ReceivedReview({this.key, this.review, this.stars, this.reviewerUid, this.reviewerUsername, this.reviewerImageProfileURL, this.time});

  setKey() {
    this.key = Utils.encodeBase64(reviewerUid + time.toString());
  }

  ReviewWrittenByMe toReviewWrittenByMe(String reviewedUid) {
    return ReviewWrittenByMe(key: this.key, review: this.review, stars: this.stars, reviewedUid: reviewedUid, time: this.time);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> reviewMap = Map<String, dynamic>();
    reviewMap['stars'] = stars;
    reviewMap['review'] = review;
    reviewMap['reviewer'] = reviewerUid;
    reviewMap['time'] = time.toString();
    reviewMap['key'] = key;
    return reviewMap;
  }

}


class ReviewWrittenByMe {

  String key;
  String review;
  int stars;
  String reviewedUid;
  String reviewedUsername;
  String reviewedImageProfileURL;
  DateTime time;

  ReviewWrittenByMe({this.key, this.review, this.stars, this.reviewedUid, this.reviewedUsername, this.reviewedImageProfileURL, this.time});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> reviewMap = Map<String, dynamic>();
    reviewMap['key'] = key;
    reviewMap['stars'] = stars;
    reviewMap['review'] = review;
    reviewMap['reviewed'] = reviewedUid;
    reviewMap['time'] = time.toString();
    return reviewMap;
  }

}