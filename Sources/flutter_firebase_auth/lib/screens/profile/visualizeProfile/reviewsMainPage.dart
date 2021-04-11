import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/reviewsWrittenByMe.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/receivedReviews.dart';

import 'dart:math';
import 'dart:convert';

import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class ReviewsMainPage extends StatefulWidget {

  List<ReceivedReview> receivedReviews;
  List<ReviewWrittenByMe> reviewsWrittenByMe;
  bool self;

  ReviewsMainPage({Key key, @required this.receivedReviews, @required this.reviewsWrittenByMe, @required this.self}) : super(key: key);

  @override
  _ReviewsMainPageState createState() => _ReviewsMainPageState();
}

class _ReviewsMainPageState extends State<ReviewsMainPage> {

  int _selectedIndexForBottomNavigationBar = 0;

  @override
  Widget build(BuildContext context) {

    if (widget.self) {
      return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              setState(() {
                _selectedIndexForBottomNavigationBar = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.download_outlined),
                label: 'Received reviews',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.upload_outlined),
                  label: 'My reviews'
              ),
            ],
            currentIndex: _selectedIndexForBottomNavigationBar,
          ),
          body: _selectedIndexForBottomNavigationBar == 0 ?
          ReceivedReviews(reviews: widget.receivedReviews) :
          ReviewsWrittenByMe(reviews: widget.reviewsWrittenByMe)
      );
    }
    else {
      ReceivedReviews(reviews: widget.receivedReviews);
    }
  }



  double setMaxHeight(String review) {
    var lines = review.length / 20;
    return lines * 40 + 15;
  }
}
