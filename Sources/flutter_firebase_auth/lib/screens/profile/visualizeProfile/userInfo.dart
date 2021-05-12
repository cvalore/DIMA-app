
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addUserReview.dart';
import 'package:flutter_firebase_auth/screens/chat/chatPage.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';


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

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Row(
      mainAxisAlignment: _isTablet ? _isPortrait ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _isPortrait ? Container() : CircleAvatar(
            backgroundColor: Colors.teal[100],
            radius: _isPortrait ? 120.0 : 80.0,
            child: InkWell(
                onTap: () {
                  if (widget.user.userProfileImageURL != '') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return LargerImage(
                          imageUrl: widget.user.userProfileImageURL,
                          username: widget.user.username);
                    }));
                  }
                },
                child: Hero(
                  tag: 'userProfileHero',
                  child: CircleAvatar(
                    backgroundColor: Colors.teal[100],
                    radius: _isPortrait ? 120.0 : 80.0,
                    child: widget.user.userProfileImageURL != '' ?
                    CircleAvatar(
                      radius: _isPortrait ? 120.0 : 80.0,
                      backgroundImage: NetworkImage(widget.user.userProfileImageURL),
                    ) : Text(
                      widget.user.username[0].toUpperCase(),
                      textScaleFactor: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50
                      ),
                    ),
                  ),
                )
            )
        ),
        Container(
            height: MediaQuery.of(context).size.height,
            width: _isTablet ? MediaQuery.of(context).size.width / 2 : _isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width/2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SingleChildScrollView(
              child:
              _isPortrait ?
                Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //_isTablet ? Container() : Divider(height: _isTablet ? 60.0 : 10.0, thickness: 0.0,),
                  CircleAvatar(
                    backgroundColor: Colors.teal[100],
                    radius: _isPortrait ? 120.0 : 80.0,
                    child: InkWell(
                    onTap: () {
                      if (widget.user.userProfileImageURL != '') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return LargerImage(
                              imageUrl: widget.user.userProfileImageURL,
                              username: widget.user.username);
                        }));
                      }
                    },
                    child: Hero(
                      tag: 'userProfileHero',
                      child: CircleAvatar(
                        backgroundColor: Colors.teal[100],
                        radius: _isPortrait ? 120.0 : 80.0,
                        child: widget.user.userProfileImageURL != '' ?
                          CircleAvatar(
                            radius: _isPortrait ? 120.0 : 80.0,
                            backgroundImage: NetworkImage(widget.user.userProfileImageURL),
                          ) : Text(
                            widget.user.username[0].toUpperCase(),
                            textScaleFactor: 4,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50
                            ),
                          ),
                        ),
                    )
                    )
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(_isTablet ? 75.0 : 20.0, _isTablet ? 25.0 : 0.0, _isTablet ? 75.0 : 20.0, 0.0),
                          child: Text(
                            widget.user.username,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.subtitle1,
                            textScaleFactor: 3,
                          ),
                        ),
                        widget.user.receivedReviews != null && widget.user.receivedReviews.length != 0 ?
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0),
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
                                widget.user.receivedReviews.length != 1 ?
                                  widget.user.receivedReviews.length.toString() + ' reviews' :
                                    '1 review',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ) : Container(),
                        widget.user.bio != null && widget.user.bio != '' ?
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: _isTablet ? 24.0 : 10.0, horizontal: _isTablet ? 75.0 : 20.0),
                          child: Text(
                            widget.user.bio,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ) : Container(),
                        !widget.self ? Divider(height: _isTablet ? 40.0 : 10.0, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,) : Container(),
                        !widget.self ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Utils.mySelf.isAnonymous == null || !Utils.mySelf.isAnonymous ?
                                ElevatedButton(
                                  //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blu),
                                  onPressed: () async {
                                    if (widget.user.usersFollowingMe != null && widget.user.usersFollowingMe.contains(Utils.mySelf.uid)) {
                                      await Utils.databaseService.unFollowUser(widget.user);
                                      widget.user.usersFollowingMe.remove(Utils.mySelf.uid);
                                      setState(() {
                                        widget.user.followers -= 1;
                                      });
                                    } else {
                                      await Utils.databaseService.followUser(widget.user);
                                      widget.user.usersFollowingMe.add(Utils.mySelf.uid);
                                      setState(() {
                                        widget.user.followers += 1;
                                      });
                                    }
                                  },
                                  child: widget.user.usersFollowingMe != null && widget.user.usersFollowingMe.contains(Utils.mySelf.uid) ?
                                    Text('UNFOLLOW') : Text('FOLLOW')) :
                                ElevatedButton(
                                  onPressed: () {
                                    Utils.showNeedToBeLogged(context, 1);
                                  },
                                  child: Text('FOLLOW'),
                                ),
                              Utils.mySelf.isAnonymous == null || !Utils.mySelf.isAnonymous ?
                                ElevatedButton(
                                  onPressed: () async {

                                    CustomUser me = await Utils.databaseService.getUserById(Utils.mySelf.uid);
                                    String myUsername = me.username;
                                    //DatabaseService db = DatabaseService(user: CustomUser(Utils.mySelf.uid));
                                    dynamic chat = await Utils.databaseService.createNewChat(
                                        Utils.mySelf.uid, widget.user.uid, myUsername, widget.user.username
                                    );

                                    if(chat != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              ChatPage(
                                                chat: Utils.toChat(chat),
                                              ))
                                      );
                                    }
                                  },
                                  child: Text('CHAT')
                              ) :
                                ElevatedButton(
                                onPressed: () {
                                  Utils.showNeedToBeLogged(context, 1);
                                },
                                child: Text('CHAT'),
                              ),
                              Utils.mySelf.isAnonymous == null || !Utils.mySelf.isAnonymous ?
                                ElevatedButton(
                                  onPressed: () async {

                                    bool canIReview = await Utils.databaseService.canIReview(widget.user.uid);

                                    if(!canIReview) {
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.black87,
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                          "You cannot review an user if you have not bought anything from him",
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      );
                                      Scaffold.of(context).showSnackBar(snackBar);
                                      return;
                                    }

                                    Navigator.pushNamed(context, AddUserReview.routeName, arguments: widget.user);
                                  },
                                  child: Text('REVIEW')):
                                ElevatedButton(
                                onPressed: () {
                                  Utils.showNeedToBeLogged(context, 1);
                                },
                                child: Text('REVIEW'),
                              ),
                            ],
                          ),
                        ) : Container(),
                        Divider(height: _isTablet ? 40.0 : 10.0, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,),
                        Container(
                          child: ListTile(
                            leading: Icon(Icons.people_alt_outlined),
                            contentPadding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0, vertical: _isTablet ? 20.0 : 0),
                            dense: true,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user.followers.toString() + '  followers',
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontSize: _isTablet ? 17.0 : 14.0,
                                  ),
                                ),
                                Text(
                                  widget.user.following.toString() + '  following',
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontSize: _isTablet ? 17.0 : 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        widget.user.fullName != null && widget.user.fullName != '' ?
                          Divider(height: 10, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,) : Container(),
                        widget.user.fullName != null && widget.user.fullName != '' ?
                        Container(
                          child: ListTile(
                            leading: Icon(Icons.drive_file_rename_outline),
                            contentPadding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0, vertical: _isTablet ? 20.0 : 0),
                            dense: true,
                            title: Text(
                              widget.user.fullName,
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontSize: _isTablet ? 17.0 : 14.0,
                              ),
                            ),
                          ),
                        ) : Container(),
                        widget.user.city != null && widget.user.city != '' ?
                          Divider(height: 10, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,) : Container(),
                        widget.user.city != null && widget.user.city != '' ?
                          Container(
                            child: ListTile(
                              leading: Icon(Icons.place_outlined),
                              contentPadding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0, vertical: _isTablet ? 20.0 : 0),
                              dense: true,
                              title: Text(
                                widget.user.city,
                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  fontSize: _isTablet ? 17.0 : 14.0,
                                ),
                              ),
                            ),
                          ) : Container(),
                        Divider(height: 10, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,),
                        Container(
                          child: ListTile(
                            leading: Icon(Icons.email_outlined),
                            contentPadding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0, vertical: _isTablet ? 20.0 : 0),
                            dense: true,
                            title: Text(
                              widget.user.email,
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontSize: _isTablet ? 17.0 : 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ) :
                Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(_isTablet ? 75.0 : 20.0, _isTablet ? 25.0 : 0.0, _isTablet ? 75.0 : 20.0, 0.0),
                          child: Text(
                            widget.user.username,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.subtitle1,
                            textScaleFactor: 3,
                          ),
                        ),
                        widget.user.receivedReviews != null && widget.user.receivedReviews.length != 0 ?
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0),
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
                                widget.user.receivedReviews.length != 1 ?
                                widget.user.receivedReviews.length.toString() + ' reviews' :
                                '1 review',
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ) : Container(),
                        widget.user.bio != null && widget.user.bio != '' ?
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: _isTablet ? 24.0 : 10.0, horizontal: _isTablet ? 75.0 : 20.0),
                          child: Text(
                            widget.user.bio,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ) : Container(),
                        !widget.self ? Divider(height: _isTablet ? 40.0 : 10.0, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,) : Container(),
                        !widget.self ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Utils.mySelf.isAnonymous == null || !Utils.mySelf.isAnonymous ?
                              ElevatedButton(
                                //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blu),
                                  onPressed: () async {
                                    if (widget.user.usersFollowingMe != null && widget.user.usersFollowingMe.contains(Utils.mySelf.uid)) {
                                      await Utils.databaseService.unFollowUser(widget.user);
                                      widget.user.usersFollowingMe.remove(Utils.mySelf.uid);
                                      setState(() {
                                        widget.user.followers -= 1;
                                      });
                                    } else {
                                      await Utils.databaseService.followUser(widget.user);
                                      widget.user.usersFollowingMe.add(Utils.mySelf.uid);
                                      setState(() {
                                        widget.user.followers += 1;
                                      });
                                    }
                                  },
                                  child: widget.user.usersFollowingMe != null && widget.user.usersFollowingMe.contains(Utils.mySelf.uid) ?
                                  Text('UNFOLLOW') : Text('FOLLOW')) :
                              ElevatedButton(
                                onPressed: () {
                                  Utils.showNeedToBeLogged(context, 1);
                                },
                                child: Text('FOLLOW'),
                              ),
                              Utils.mySelf.isAnonymous == null || !Utils.mySelf.isAnonymous ?
                              ElevatedButton(
                                  onPressed: () async {

                                    CustomUser me = await Utils.databaseService.getUserById(Utils.mySelf.uid);
                                    String myUsername = me.username;
                                    //DatabaseService db = DatabaseService(user: CustomUser(Utils.mySelf.uid));
                                    dynamic chat = await Utils.databaseService.createNewChat(
                                        Utils.mySelf.uid, widget.user.uid, myUsername, widget.user.username
                                    );

                                    if(chat != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>
                                              ChatPage(
                                                chat: Utils.toChat(chat),
                                              ))
                                      );
                                    }
                                  },
                                  child: Text('CHAT')
                              ) :
                              ElevatedButton(
                                onPressed: () {
                                  Utils.showNeedToBeLogged(context, 1);
                                },
                                child: Text('CHAT'),
                              ),
                              Utils.mySelf.isAnonymous == null || !Utils.mySelf.isAnonymous ?
                              ElevatedButton(
                                  onPressed: () async {

                                    bool canIReview = await Utils.databaseService.canIReview(widget.user.uid);

                                    if(!canIReview) {
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.black87,
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                          "You cannot review an user if you have not bought anything from him",
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      );
                                      Scaffold.of(context).showSnackBar(snackBar);
                                      return;
                                    }

                                    Navigator.pushNamed(context, AddUserReview.routeName, arguments: widget.user);
                                  },
                                  child: Text('REVIEW')):
                              ElevatedButton(
                                onPressed: () {
                                  Utils.showNeedToBeLogged(context, 1);
                                },
                                child: Text('REVIEW'),
                              ),
                            ],
                          ),
                        ) : Container(),
                        Divider(height: _isTablet ? 40.0 : 10.0, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: ListTile(
                            leading: Icon(Icons.people_alt_outlined),
                            contentPadding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0, vertical: _isTablet ? 20.0 : 0),
                            dense: true,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.user.followers.toString() + '  followers',
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontSize: _isTablet ? 17.0 : 14.0,
                                  ),
                                ),
                                Text(
                                  widget.user.following.toString() + '  following',
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontSize: _isTablet ? 17.0 : 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        widget.user.fullName != null && widget.user.fullName != '' ?
                        Divider(height: 10, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,) : Container(),
                        widget.user.fullName != null && widget.user.fullName != '' ?
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: ListTile(
                            leading: Icon(Icons.drive_file_rename_outline),
                            contentPadding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0, vertical: _isTablet ? 20.0 : 0),
                            dense: true,
                            title: Text(
                              widget.user.fullName,
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontSize: _isTablet ? 17.0 : 14.0,
                              ),
                            ),
                          ),
                        ) : Container(),
                        widget.user.city != null && widget.user.city != '' ?
                        Divider(height: 10, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,) : Container(),
                        widget.user.city != null && widget.user.city != '' ?
                        Container(
                          width: MediaQuery.of(context).size.width/2,
                          child: ListTile(
                            leading: Icon(Icons.place_outlined),
                            contentPadding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0, vertical: _isTablet ? 20.0 : 0),
                            dense: true,
                            title: Text(
                              widget.user.city,
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontSize: _isTablet ? 17.0 : 14.0,
                              ),
                            ),
                          ),
                        ) : Container(),
                        Divider(height: 10, thickness: 2, indent: _isTablet ? 70.0 : 10, endIndent: _isTablet ? 70.0 : 10,),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: ListTile(
                            leading: Icon(Icons.email_outlined),
                            contentPadding: EdgeInsets.symmetric(horizontal: _isTablet ? 75.0 : 20.0, vertical: _isTablet ? 20.0 : 0),
                            dense: true,
                            title: Text(
                              widget.user.email,
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontSize: _isTablet ? 17.0 : 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
          ),
            )
        ),
      ],
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
      body: InkWell(
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

