
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/receivedReviews.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/reviewsWrittenByMe.dart';
import 'package:flutter_firebase_auth/utils/myVerticalTabs.dart';

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

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    if (widget.self) {
      return Scaffold(
          bottomNavigationBar: _isPortrait ?
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              setState(() {
                _selectedIndexForBottomNavigationBar = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.download_outlined),
                label: 'Received',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.upload_outlined),
                  label: 'Sent'
              ),
            ],
            currentIndex: _selectedIndexForBottomNavigationBar,
          ) : null,
          body: _isPortrait ? _selectedIndexForBottomNavigationBar == 0 ?
          ReceivedReviews(reviews: widget.receivedReviews) :
          ReviewsWrittenByMe(reviews: widget.reviewsWrittenByMe)
              :
            MyVerticalTabs(
              indicatorSide: IndicatorSide.end,
              tabBarSide: TabBarSide.right,
              disabledChangePageFromContentView: true,
              tabBarHeight: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
              tabBarWidth: 85,
              tabsWidth: 85,
              indicatorColor: Colors.blue,
              selectedTabBackgroundColor: Colors.white10,
              tabBackgroundColor: Colors.black26,
              selectedTabTextStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: <Tab>[
                Tab(child: Container(
                  //height: 50,
                    height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/2,
                    //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Received', textAlign: TextAlign.center,),
                        Icon(Icons.download_outlined),
                      ],
                    ))
                )),
                Tab(child: Container(
                  //height: 50,
                    height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/2,
                    //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                    child: Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sent', textAlign: TextAlign.center,),
                        Icon(Icons.upload_outlined),
                      ],
                    ))
                )),
              ],
              contents: [
                ReceivedReviews(reviews: widget.receivedReviews),
                ReviewsWrittenByMe(reviews: widget.reviewsWrittenByMe)
              ],
            ),
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
