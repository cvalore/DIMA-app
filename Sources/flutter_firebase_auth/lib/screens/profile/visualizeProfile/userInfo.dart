import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';

class UserInfo extends StatefulWidget {

  CustomUser user;
  bool self;

  UserInfo({Key key, @required this.user, @required this.self}) : super(key : key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.user.userProfileImageURL != '' ?
                    Container(
                      height: MediaQuery.of(context).size.height * 2 / 4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.user.userProfileImageURL),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ) :
                    Container(
                      height: MediaQuery.of(context).size.height * 2 / 4,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.green,
                      child: widget.user.userProfileImageURL != '' ?
                        NetworkImage(widget.user.userProfileImageURL)
                          : Text(
                              widget.user.username[0].toUpperCase(),
                              textScaleFactor: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50
                              ),
                      ),
                      ),
            Divider(height: 10),
            Container(
              //height: MediaQuery.of(context).size.height / 10,
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
                  widget.user.bio != null && widget.user.bio != '' ?
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      widget.user.bio,
                      style: Theme.of(context).textTheme.bodyText1,
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
                  Divider(height: 10, thickness: 2,),
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
                  Divider(height: 10, thickness: 2,),
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
