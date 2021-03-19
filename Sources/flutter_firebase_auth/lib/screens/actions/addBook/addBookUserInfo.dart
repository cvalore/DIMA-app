import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/comment.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/exchange.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/status.dart';

class AddBookUserInfo extends StatelessWidget {

  InsertedBook insertedBook;
  bool edit;

  AddBookUserInfo({@required this.insertedBook, @required this.edit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    //Expanded(flex: 50, child: ImageService(insertedBook: insertedBook)),
                    ImageService(insertedBook: insertedBook),
                    customSizedBox(1.0),
                    Status(insertedBook: insertedBook, height: 60, offset: 50.0),
                    customSizedBox(1.0),
                    edit ? Container() : Category(insertedBook: insertedBook, height: 60),
                    edit ? Container() : customSizedBox(1.0),
                    Comment(insertedBook: insertedBook, height: 60),
                    customSizedBox(1.0),
                    Price(insertedBook: insertedBook, height: 60),
                    customSizedBox(1.0),
                    Exchange(insertedBook: insertedBook, height: 60),
                    SizedBox(height: 100)
                    /*
                    Flexible(
                      flex: 4,
                      child: SizedBox(height: 20.0,),
                    ),
                    Flexible(
                      flex: 4,
                      child: SizedBox(height: 20.0,),
                    ),
                     */
                  ],
                ),
              )
            ),
          ),
          BottomTwoDots(darkerIndex: 2, size: 9.0,)
        ],
      ),
    );
  }
}

Widget customSizedBox(height) {
  return SizedBox(
    height: height,
    child: Container(
      color: Colors.black,
    ),
  );
}