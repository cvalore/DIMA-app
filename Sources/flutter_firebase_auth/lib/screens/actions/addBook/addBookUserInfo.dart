import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/commentBox.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookStatus.dart';

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
          Expanded(flex: 50, child: ImageService(insertedBook: insertedBook)),
          customSizedBox(1.0),
          BookStatus(insertedBook: insertedBook, height: 60, offset: 50.0),
          customSizedBox(1.0),
          CommentBox(insertedBook: insertedBook, height: 60),
          customSizedBox(1.0),
          Flexible(
            flex: 4,
            child: SizedBox(height: 20.0,),
          ),
          Flexible(
            flex: 4,
            child: SizedBox(height: 20.0,),
          ),
          //backAndForthButtons(60),
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