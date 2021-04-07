import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/review.dart';

import 'dart:math';
import 'dart:convert';

import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class Reviews extends StatefulWidget {

  List<Review> reviews;
  bool self;

  Reviews({Key key, @required this.reviews, @required this.self}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {

  @override
  Widget build(BuildContext context) {
    return (widget.reviews == null || widget.reviews.length == 0) ?
    Container(
      alignment: Alignment.center,
      child: Text('Still no reviews'),
      //TODO add animation?
    ) :
    FutureBuilder(
      future: getReviewersInfo(widget.reviews),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Loading();
        else {
          return ListView.builder(
              itemCount: widget.reviews.length,
              itemBuilder: (context, index) {
                return Card(
                  //height: MediaQuery.of(context).size.height / 5,
                  child: LimitedBox(
                    maxHeight: 200, //setMaxHeight(widget.reviews[index].review),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.brown.shade800,
                              radius: 60.0,
                              child: widget.reviews[index].reviewerImageProfileURL != '' ?
                              CircleAvatar(
                                radius: 60.0,
                                backgroundImage: NetworkImage(widget.reviews[index].reviewerImageProfileURL),
                                //FileImage(File(user.userProfileImagePath))
                              ) : Text(
                                widget.reviews[index].reviewerUsername[0].toUpperCase(),
                                //textScaleFactor: 3,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                              fontWeight: FontWeight.bold)
                                        /*
                                            TextStyle(
                                            //color: Colors.black38,
                                              fontWeight: FontWeight.bold
                                          ),

                                           */
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        computeHowLongAgo(widget.reviews[index].time),
                                        style: TextStyle(
                                            fontSize: 9,
                                            //color: Colors.grey[600],
                                            fontWeight: FontWeight.normal
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    for(int i = 0; i < 5; i++)
                                      widget.reviews[index].stars > i ? Icon(Icons.star, color: Colors.yellow,) : Icon(Icons.star_border, color: Colors.yellow,),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Expanded(
                                  flex: 4,
                                  child: Text(widget.reviews[index].review,
                                      //maxLines: 3,
                                      textAlign: TextAlign.start
                                  )
                              )
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
      },
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



Future<List<Review>> getReviewersInfo(List<Review> reviews) async {
  print(reviews);
  if (reviews != null) print(reviews.length);

  List<String> reviewersUid = reviews.map((e) => e.reviewerUid).toList();

  var result = await DatabaseService().getReviewersInfoByUid(reviewersUid);

  for (int i = 0; i < reviews.length; i++){
    Map<String, dynamic> reviewerInfo = result[reviews[i].reviewerUid];
    reviews[i].reviewerImageProfileURL = reviewerInfo['userProfileImageURL'];
    reviews[i].reviewerUsername = reviewerInfo['username'];
  }
  /*
    Review review = Review(
        review: getRandString(30),
        stars: random.nextInt(5),
        reviewerUsername: getRandString(10),
        time: DateTime.now()
    );
    reviews.add(review);

     */
}


double setMaxHeight(String review){
  var lines = review.length / 20;
  return lines * 40 + 15;
}
