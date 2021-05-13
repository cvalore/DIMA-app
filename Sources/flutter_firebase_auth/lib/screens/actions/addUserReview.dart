import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';

class AddUserReview extends StatefulWidget {
  static const routeName = 'addUserReview';

  @override
  _AddUserReviewState createState() => _AddUserReviewState();
}

class _AddUserReviewState extends State<AddUserReview> {

  int stars = 1;
  String reviewString = '';


  @override
  Widget build(BuildContext context) {

    final CustomUser user = ModalRoute.of(context).settings.arguments as CustomUser;
    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white24,
        icon: Icon(Icons.check_outlined),
        label: Text('Done'),
        onPressed: () async {
          ReceivedReview review = ReceivedReview(stars: stars, review: reviewString, reviewerUid: Utils.mySelf.uid, time: DateTime.now());
          await DatabaseService(user: user).addReview(review);
          user.receivedReviews.add(review);
          print('review added');
          Navigator.pop(context);
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 30, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for(int i = 0; i < 5; i++)
                  Container(
                    padding: EdgeInsets.all(.0),
                    child: IconButton(
                      iconSize: 30.0,
                      key: ValueKey(i),
                      splashRadius: 30,
                      icon: stars > i ?
                      Icon(Icons.star, color: Colors.yellow,) :
                      Icon(Icons.star_border, color: Colors.yellow,),
                      onPressed: () {
                          setState(() {
                            stars = i + 1;
                          });
                      }
                    ),
            )
            ],
          ),
          Divider(height: 10.0, thickness: 1.0,),
          TextFormField(
              cursorColor: Colors.black,

              maxLines: 7,
              decoration: InputDecoration(
                hintText: 'Add a review...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(7.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.white)
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              ),
              //textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontSize: _isTablet ? 21.0 : 17.0,),
              onChanged: (value) {
                reviewString = value;
              }
          ),
        ],
        ),
      )
    );
  }
}
