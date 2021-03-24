import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/review.dart';

import 'dart:math';
import 'dart:convert';

class Reviews extends StatefulWidget {

  List<Review> reviews;
  bool self;

  Reviews({Key key, @required this.reviews, @required this.self}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {

  //the following initState is just for debug purposes
  @override
  void initState() {
    widget.reviews = generateReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    //TODO here database request for getting users avatars
    return (widget.reviews == null || widget.reviews.length == 0) ?
    Container(
      alignment: Alignment.center,
      child: Text('Still no reviews'),
      //TODO add animation?
    ) :
      ListView.builder(
          itemCount: widget.reviews.length,
          itemBuilder: (context, index) {
            return Card(
              //height: MediaQuery.of(context).size.height / 5,
              child: LimitedBox(
                maxHeight: setMaxHeight(widget.reviews[index].review),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                        backgroundColor: Colors.brown.shade800,
                        child: Text(
                          widget.reviews[index].reviewerUsername[0].toUpperCase(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    widget.reviews[index].reviewerUsername,
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    computeHowLongAgo(widget.reviews[index].time),
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                for(int i = 0; i < 5; i++)
                                  widget.reviews[index].stars > i ? Icon(Icons.star, color: Colors.yellow,) : Icon(Icons.star_border, color: Colors.yellow,),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                              flex: 4,
                              child: Text(widget.reviews[index].review))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      );
  }

  String computeHowLongAgo(DateTime time) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(time);
    if (difference.inDays >= 1)
      return (difference.inDays).toString() + ' days ago';
    else if (difference.inHours >= 1)
      return (difference.inHours).toString() + ' hours ago';
    else if(difference.inMinutes >= 1)
      return (difference.inMinutes).toString() + ' minutes ago';
    else
      return 'Few seconds ago';
  }
}

List<Review> generateReviews(){
  List<Review> reviews = [];
  var random = Random.secure();
  for(int i = 0; i < 10; i++){
    Review review = Review(
        review: getRandString(30),
        stars: random.nextInt(5),
        reviewerUsername: getRandString(10),
        time: DateTime.now()
    );
    reviews.add(review);
  }
  return reviews;
}

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) =>  random.nextInt(255));
  return base64UrlEncode(values);
}

double setMaxHeight(String review){
  var lines = review.length / 20;
  return lines * 40 + 15;
}
