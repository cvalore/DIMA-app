import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/comment.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/exchange.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/status.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';

class AddBookUserInfo extends StatelessWidget {

  final appBarHeight;
  InsertedBook insertedBook;
  final bool isInsert;

  AddBookUserInfo({@required this.insertedBook, this.appBarHeight, @required this.isInsert});

  @override
  Widget build(BuildContext context) {
    
    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Container(
      height: MediaQuery.of(context).size.height,// - appBarHeight,
      padding: EdgeInsets.fromLTRB(
          _isTablet && !isInsert ? 100.0 : !_isTablet && !_isPortrait ? 120.0 : 20.0,
          0.0,
          _isTablet && !isInsert ? 100.0 : !_isTablet && !_isPortrait ? 120.0 : 20.0,
          0.0
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: _isTablet ? MainAxisAlignment.center : MainAxisAlignment.end,
                  children: [
                    ImageService(insertedBook: insertedBook, justView: false),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Status(insertedBook: insertedBook, height: 50, offset: 50.0, justView: false),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    !isInsert ? Container() : Category(insertedBook: insertedBook, height: 50, justView: false),
                    !isInsert ? Container() : Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Comment(insertedBook: insertedBook, height: 50, justView: false),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Price(insertedBook: insertedBook, height: 50, justView: false),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Exchange(insertedBook: insertedBook, height: 50, justView: false),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    SizedBox(height: 70,),
                  ],
                ),
              ),
            ),
          ),
          !isInsert ? Container(): BottomTwoDots(darkerIndex: 2, size: 9.0,),
          SizedBox(height: 15,),
        ]
      ),
    );
  }
}