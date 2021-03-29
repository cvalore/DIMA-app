import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/comment.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/exchange.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/status.dart';

class AddBookUserInfo extends StatelessWidget {

  final appBarHeight;
  InsertedBook insertedBook;
  bool edit;
  bool justView;

  AddBookUserInfo({@required this.insertedBook, @required this.edit, @required this.justView, this.appBarHeight});

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Container(
      height: MediaQuery.of(context).size.height - appBarHeight,
      padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
      child: Column(
        mainAxisAlignment: _isTablet ? MainAxisAlignment.center : MainAxisAlignment.end,
        children: [
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  //Expanded(flex: 50, child: ImageService(insertedBook: insertedBook)),
                  ImageService(insertedBook: insertedBook, justView: justView),
                  customSizedBox(1.0),
                  Status(insertedBook: insertedBook, height: 55, offset: 50.0, justView: justView),
                  customSizedBox(1.0),
                  edit ? Container() : Category(insertedBook: insertedBook, height: 55, justView: justView),
                  edit ? Container() : customSizedBox(1.0),
                  Comment(insertedBook: insertedBook, height: 55, justView: justView),
                  customSizedBox(1.0),
                  Price(insertedBook: insertedBook, height: 55, justView: justView),
                  customSizedBox(1.0),
                  Exchange(insertedBook: insertedBook, height: 55, justView: justView),
                  customSizedBox(1.0),
                  SizedBox(height: 55,),
                ],
              ),
            ),
          ),
          (edit || justView || _isTablet) ? Container(): BottomTwoDots(darkerIndex: 2, size: 9.0,),
        ],
      ),
    );
  }
}

Widget customSizedBox(height) {
  return SizedBox(
    height: height,
    child: Container(
      color: Colors.white,
    ),
  );
}