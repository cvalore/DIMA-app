import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';


class ReceivedReviews extends StatefulWidget {

  List<ReceivedReview> reviews;

  ReceivedReviews({Key key, @required this.reviews});

  @override
  _ReceivedReviewsState createState() => _ReceivedReviewsState();
}

class _ReceivedReviewsState extends State<ReceivedReviews> {
  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

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
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: _isTablet ? 16.0 : _isPortrait ? 8.0 : 30.0, vertical: _isTablet ? 8.0 : 4.0),
                  child: Card(
                    elevation: 0.0,
                    //height: MediaQuery.of(context).size.height / 5,
                    child: LimitedBox(
                      maxHeight: _isPortrait ? 200 : 150,
                      //setMaxHeight(widget.reviews[index].review),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.teal[100],
                                radius: 60.0,
                                child: widget.reviews[index]
                                    .reviewerImageProfileURL != '' ?
                                InkWell(
                                  onTap: () async {
                                    await _pushProfile(index);
                                  },
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: NetworkImage(
                                        widget.reviews[index]
                                            .reviewerImageProfileURL),
                                    //FileImage(File(user.userProfileImagePath))
                                  ),
                                ) : InkWell(
                                  onTap: () async {
                                    await _pushProfile(index);
                                  },
                                  child: Text(
                                    widget.reviews[index].reviewerUsername[0]
                                        .toUpperCase(),
                                    //textScaleFactor: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                            widget.reviews[index]
                                                .reviewerUsername,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(
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
                                          Utils.computeHowLongAgo(
                                              widget.reviews[index].time),
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
                                        widget.reviews[index].stars > i
                                            ? Icon(
                                          Icons.star, color: Colors.yellow,)
                                            : Icon(Icons.star_border,
                                          color: Colors.yellow,),
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
                  ),
                );
              }
          );
        }
      },
    );
  }


  Future<void> _pushProfile(int index) async {
      if (widget.reviews[index].reviewerUid != Utils.mySelf.uid) {
        DatabaseService databaseService = DatabaseService(
            user: CustomUser(
                widget.reviews[index].reviewerUid));
        CustomUser user = await databaseService
            .getUserSnapshot();
        BookPerGenreUserMap userBooks = await databaseService
            .getUserBooksPerGenreSnapshot();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                VisualizeProfileMainPage(
                    user: user,
                    books: userBooks.result,
                    self: false)
            )
        );
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StreamProvider<CustomUser>.value(
                value: Utils.databaseService.userInfo,
                child: VisualizeProfileMainPage(self: true))
            )
        );
      }
  }

  Future<List<ReceivedReview>> getReviewersInfo(List<ReceivedReview> reviews) async {
    List<String> reviewersUid = reviews.map((e) => e.reviewerUid).toList();
    var result = await DatabaseService().getReviewsInfoByUid(reviewersUid);
    for (int i = 0; i < reviews.length; i++) {
      Map<String, dynamic> reviewerInfo = result[reviews[i].reviewerUid];
      reviews[i].reviewerImageProfileURL = reviewerInfo['userProfileImageURL'];
      reviews[i].reviewerUsername = reviewerInfo['username'];
    }
  }
}
