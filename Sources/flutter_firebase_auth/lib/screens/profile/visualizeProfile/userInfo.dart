import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addUserReview.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class UserInfo extends StatefulWidget {

  CustomUser user;
  bool self;
  String imagePath;

  UserInfo({Key key, @required this.user, @required this.self}) : super(key : key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {


  @override
  Widget build(BuildContext context) {

    Image image;

    if (widget.user.userProfileImageURL != ''){
      image = Image.network(widget.user.userProfileImageURL);
    }

    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(height: 10.0, thickness: 0.0,),
            CircleAvatar(
              backgroundColor: Colors.brown.shade800,
              radius: 120.0,
              child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return LargerImage(imageUrl: widget.user.userProfileImageURL, username: widget.user.username);
                }));
              },
              child: Hero(
                tag: 'userProfileHero',
                child: widget.user.userProfileImageURL != '' ?
                CircleAvatar(
                  radius: 120.0,
                  backgroundImage: NetworkImage(widget.user.userProfileImageURL),
                ) : Text(
                  widget.user.username[0].toUpperCase(),
                  textScaleFactor: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50
                  ),
                ),
              ),
              )
            ),
            Divider(height: 10),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      widget.user.username,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.subtitle1,
                      textScaleFactor: 3,
                    ),
                  ),
                  widget.user.reviews != null && widget.user.reviews.length != 0 ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        for(int i = 0; i < 5; i++)
                          Container(
                            padding: EdgeInsets.all(5.0),
                            width: 30.0,
                            child: widget.user.averageRating > i && widget.user.averageRating < i + 1 ?
                                Icon(Icons.star_half_outlined, color: Colors.yellow,) :
                              widget.user.averageRating > i ?
                                Icon(Icons.star, color: Colors.yellow,) :
                                Icon(Icons.star_border, color: Colors.yellow,),
                            ),
                        SizedBox(width: 20.0),
                        Text(
                          widget.user.reviews.length != 1 ?
                            widget.user.reviews.length.toString() + ' reviews' :
                              '1 review',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ) : Container(),
                  widget.user.bio != null && widget.user.bio != '' ?
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      widget.user.bio,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ) : Container(),
                  !widget.self ? Divider(height: 10, thickness: 2,) : Container(),
                  !widget.self ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blu),
                            onPressed: () {
                              widget.user.usersFollowingMe != null && widget.user.usersFollowingMe.contains(Utils.mySelf.uid) ?
                                Utils.databaseService.unFollowUser(widget.user) :
                                Utils.databaseService.followUser(widget.user);
                            },
                            child: widget.user.usersFollowingMe != null && widget.user.usersFollowingMe.contains(Utils.mySelf.uid) ?
                              Text('UNFOLLOW') : Text('FOLLOW')),
                        ElevatedButton(
                            onPressed: null,
                            child: Text('SEND MSG')),
                        ElevatedButton(
                            onPressed: () {
                              print(widget.user.uid);
                              Navigator.pushNamed(context, AddUserReview.routeName, arguments: widget.user);
                            },
                            child: Text('REVIEW')),
                      ],
                    ),
                  ) : Container(),
                  Divider(height: 10, thickness: 2,),
                  Container(
                    child: ListTile(
                      leading: Icon(Icons.people_alt_outlined),
                      dense: true,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.followers.toString() + '  followers',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            widget.user.following.toString() + '  following',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.user.fullName != null && widget.user.fullName != '' ?
                    Divider(height: 10, thickness: 2,) : Container(),
                  widget.user.fullName != null && widget.user.fullName != '' ?
                  Container(
                    child: ListTile(
                      leading: Icon(Icons.drive_file_rename_outline),
                      dense: true,
                      title: Text(
                        widget.user.fullName,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ) : Container(),
                  widget.user.city != null && widget.user.city != '' ?
                    Divider(height: 10, thickness: 2,) : Container(),
                  widget.user.city != null && widget.user.city != '' ?
                    Container(
                      child: ListTile(
                        leading: Icon(Icons.place_outlined),
                        dense: true,
                        title: Text(
                          widget.user.city,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ) : Container(),
                  Divider(height: 10, thickness: 2,),
                  Container(
                    child: ListTile(
                      leading: Icon(Icons.email_outlined),
                      dense: true,
                      title: Text(
                        widget.user.email,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      )
    );
  }
}


class LargerImage extends StatelessWidget {

  String imageUrl;
  String username;

  LargerImage({Key key, @required this.imageUrl, @required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
          tag: 'userProfileHero',
          child: imageUrl != '' ? Container(
            //child: Image.network(widget.user.userProfileImageURL),
            //height: MediaQuery.of(context).size.height * 6/10,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                //FileImage(Utils.imageProfilePicFile),
                fit: BoxFit.contain,
              ),
            ),
          ) : Container(
            //height: MediaQuery.of(context).size.height * 2 / 4,
            padding: EdgeInsets.all(10.0),
            color: Colors.green,
            child: Text(
              username[0].toUpperCase(),
              textScaleFactor: 5,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50
              ),
            ),
          ),
        ),
      ),
    );
  }
}

