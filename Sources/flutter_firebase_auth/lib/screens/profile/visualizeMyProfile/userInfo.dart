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
            widget.user.userProfileImagePath != null ?
              Text('//TODO insert use image') :
              Container(
                height: MediaQuery.of(context).size.height * 2 / 4,
                padding: EdgeInsets.all(10.0),
                color: Colors.green,
                child: Text(
                  widget.user.username[0].toUpperCase(),
                  textScaleFactor: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50
                  ),
                ),
                ),
            Container(
              height: MediaQuery.of(context).size.height / 10,
              child: Text(
                widget.user.username,
                textAlign: TextAlign.center,
                textScaleFactor: 3,
              )
            ),
            SizedBox(height: 5.0, child: Container(color: Colors.grey[200],),),
          ],
        ),
      )
    );
  }


  /*
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Text('Ciao')
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

   */
}
