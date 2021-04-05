
class Review {

  String review;
  int stars;
  String reviewerUid;
  String reviewerUsername;
  String reviewerImageProfileURL;
  DateTime time;

  Review({this.review, this.stars, this.reviewerUid, this.reviewerUsername, this.reviewerImageProfileURL, this.time});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> reviewMap = Map<String, dynamic>();
    reviewMap['stars'] = stars;
    reviewMap['review'] = review;
    reviewMap['reviewer'] = reviewerUid;
    reviewMap['time'] = time.toString();
    return reviewMap;
  }

}