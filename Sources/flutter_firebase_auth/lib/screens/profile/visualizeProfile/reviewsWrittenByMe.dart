import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/loading.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';


class ReviewsWrittenByMe extends StatefulWidget {

  List<ReviewWrittenByMe> reviews;

  ReviewsWrittenByMe({Key key, @required this.reviews});

  @override
  _ReceivedReviewsState createState() => _ReceivedReviewsState();
}

class _ReceivedReviewsState extends State<ReviewsWrittenByMe> {

  bool selectionModeOn = false;
  int firstItemSelectedIndex;
  List<ReviewWrittenByMe> selectedReviews = List<ReviewWrittenByMe>();

  bool isSelectionModeOn() {
    return selectionModeOn;
  }

  @override
  Widget build(BuildContext context) {
    return (widget.reviews == null || widget.reviews.length == 0) ?
    Container(
      alignment: Alignment.center,
      child: Text('Still no reviews'),
      //TODO add animation?
    ) : widget.reviews[0].reviewedUsername != null ?
        selectionModeOn  && selectedReviews.length > 0 ?
            Scaffold(
              floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor.withOpacity(0.4),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => AlertDialog(
                        content: Text('The selected reviews will be delete. Are you sure?'),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                print('I am deleting ' + selectedReviews.length.toString() + ' items');
                                Utils.databaseService.removeReviews(selectedReviews);
                                Navigator.pop(context);
                              },
                              child: Text('YES')),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('NO')),
                        ],
                      )
                    );
                  },
                  label: Text('Delete'),
                  icon: Icon(Icons.delete_outline),
              ),
              body:  ListView.builder(
                  itemCount: widget.reviews.length,
                  itemBuilder: (context, index) {
                    return ReviewItem(
                        reviewWrittenByMe: widget.reviews[index],
                        isSelectionModeOn: isSelectionModeOn,
                        setSelectionModeOn: () {
                          if (selectionModeOn == false) {
                            setState(() {
                              selectionModeOn = true;
                              firstItemSelectedIndex = index;
                              selectedReviews.add(widget.reviews[index]);
                            });
                          }
                        },
                        firstItemSelected : selectionModeOn == true && firstItemSelectedIndex != null
                            && firstItemSelectedIndex == index
                            ? true : false,
                        isSelected: (bool value) {
                          setState(() {
                            if (value) {
                              selectedReviews.add(widget.reviews[index]);
                            } else {
                              selectedReviews.remove(widget.reviews[index]);
                              if (selectedReviews.length == 0)
                                selectionModeOn = false;
                            }
                          });
                        },
                    );
                  }
              ),
            ) : 
    ListView.builder(
        itemCount: widget.reviews.length,
        itemBuilder: (context, index) {
          return ReviewItem(
              reviewWrittenByMe: widget.reviews[index],
              isSelectionModeOn: isSelectionModeOn,
              setSelectionModeOn: () {
                if (selectionModeOn == false) {
                  setState(() {
                    selectedReviews.add(widget.reviews[index]);
                    selectionModeOn = true;
                    firstItemSelectedIndex = index;
                  });
                }
              },
              firstItemSelected : selectionModeOn == true && firstItemSelectedIndex != null
                  && firstItemSelectedIndex == index
                  ? true : false,
              isSelected: (bool value) {
                setState(() {
                  if (value) {
                    selectedReviews.add(widget.reviews[index]);
                  } else {
                    selectedReviews.remove(widget.reviews[index]);
                  }
                });
              },
          );
        }
    ) : FutureBuilder(
      future: getReviewedUsersInfo(widget.reviews),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Loading();
        else {
          return ListView.builder(
              itemCount: widget.reviews.length,
              itemBuilder: (context, index) {
                return ReviewItem(
                  reviewWrittenByMe: widget.reviews[index],
                  setSelectionModeOn: () {
                    if (selectionModeOn == false) {
                      setState(() {
                        selectedReviews.add(widget.reviews[index]);
                        selectionModeOn = true;
                        firstItemSelectedIndex = index;
                      });
                    }
                  },
                );
              }
          );
        }
      },
    );
  }

  Future<List<ReviewWrittenByMe>> getReviewedUsersInfo(List<ReviewWrittenByMe> reviews) async {
    List<String> reviewedUids = reviews.map((e) => e.reviewedUid).toList();
    var result = await DatabaseService().getReviewsInfoByUid(reviewedUids);
    for (int i = 0; i < reviews.length; i++) {
      Map<String, dynamic> reviewerInfo = result[reviews[i].reviewedUid];
      reviews[i].reviewedImageProfileURL = reviewerInfo['userProfileImageURL'];
      reviews[i].reviewedUsername = reviewerInfo['username'];
    }
  }
}




class ReviewItem extends StatefulWidget {

  bool firstItemSelected;
  ReviewWrittenByMe reviewWrittenByMe;
  ValueChanged<bool> isSelected;
  Function setSelectionModeOn;
  Function isSelectionModeOn;

  ReviewItem({Key key, @required this.reviewWrittenByMe, this.isSelected, this.setSelectionModeOn, this.firstItemSelected, this.isSelectionModeOn});

  @override
  _ReviewItemState createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {

  bool isSelected = false;

  @override
  initState() {
    super.initState();
    if (widget.firstItemSelected != null && widget.firstItemSelected == true) {
      isSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return InkWell(
      onLongPress: () {
        widget.setSelectionModeOn();
      },
      onTap: () {
        if (widget.isSelectionModeOn != null && widget.isSelectionModeOn()) {
          setState(() {
            isSelected = !isSelected;
            widget.isSelected(isSelected);
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _isTablet ? 16.0 : _isPortrait ? 8.0 : 30.0, vertical: _isTablet ? 8.0 : 4.0),
        child: Card(
          //height: MediaQuery.of(context).size.height / 5,
          child: LimitedBox(
            maxHeight: _isPortrait ? 200 : 150,
            //setMaxHeight(widget.reviews[index].review),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: InkWell(
                    onTap: () async {
                      if (widget.isSelectionModeOn == null ||
                          !widget.isSelectionModeOn()) {
                        DatabaseService databaseService = DatabaseService(
                            user: CustomUser(widget.reviewWrittenByMe
                                .reviewedUid));
                        CustomUser user = await databaseService.getUserSnapshot();
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
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.teal[100],
                        radius: 60.0,
                        child: widget.reviewWrittenByMe
                            .reviewedImageProfileURL != '' ?
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                              widget.reviewWrittenByMe
                                  .reviewedImageProfileURL),
                          //FileImage(File(user.userProfileImagePath))
                        ) : Text(
                          widget.reviewWrittenByMe.reviewedUsername[0]
                              .toUpperCase(),
                          //textScaleFactor: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Stack(
                    children: [
                      Column(
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
                                      widget.reviewWrittenByMe
                                          .reviewedUsername,
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
                                        widget.reviewWrittenByMe.time),
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
                                  widget.reviewWrittenByMe.stars > i
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
                              child: Text(widget.reviewWrittenByMe.review,
                                  //maxLines: 3,
                                  textAlign: TextAlign.start
                              )
                          ),
                        ],
                      ),
                      widget.isSelectionModeOn != null && widget.isSelectionModeOn() == true ?
                      Positioned(
                          bottom: 20,
                          right: 20,
                          child: isSelected ?
                          Icon(Icons.check_box_outlined) :
                          Icon(Icons.check_box_outline_blank_outlined)
                      ) : Container()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

