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
    print(_isTablet);

    return Container(
      height: MediaQuery.of(context).size.height,// - appBarHeight,
      //padding: EdgeInsets.fromLTRB(_isTablet && (justView || edit) ? 100.0 : 25.0, 0.0, _isTablet && (justView || edit) ? 100.0 : 25.0, 0.0),
      child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: _isTablet ? MainAxisAlignment.center : MainAxisAlignment.end,
            children: [
              ImageService(insertedBook: insertedBook, justView: justView),
              Divider(height: 5, thickness: 2,),
              Status(insertedBook: insertedBook, height: 50, offset: 50.0, justView: justView),
              Divider(height: 5, thickness: 2,),
              edit ? Container() : Category(insertedBook: insertedBook, height: 50, justView: justView),
              edit ? Container() : Divider(height: 5, thickness: 2,),
              Comment(insertedBook: insertedBook, height: 50, justView: justView),
              Divider(height: 5, thickness: 2,),
              Price(insertedBook: insertedBook, height: 50, justView: justView),
              Divider(height: 5, thickness: 2,),
              Exchange(insertedBook: insertedBook, height: 50, justView: justView),
              Divider(height: 5, thickness: 2,),
              SizedBox(height: 50,),
            ],
          ),
      ),
    );
  }
}

/*
return Container(
//height: MediaQuery.of(context).size.height,// - appBarHeight,
//padding: EdgeInsets.fromLTRB(_isTablet && (justView || edit) ? 100.0 : 25.0, 0.0, _isTablet && (justView || edit) ? 100.0 : 25.0, 0.0),
child: Column(
//mainAxisAlignment: _isTablet ? MainAxisAlignment.center :
//  (justView || edit ? MainAxisAlignment.start : MainAxisAlignment.end),
children: [
SingleChildScrollView(
child: Column(
mainAxisAlignment: _isTablet ? MainAxisAlignment.center : MainAxisAlignment.end,
children: [
ImageService(insertedBook: insertedBook, justView: justView),
Divider(height: 5, thickness: 2,),
Status(insertedBook: insertedBook, height: 50, offset: 50.0, justView: justView),
Divider(height: 5, thickness: 2,),
edit ? Container() : Category(insertedBook: insertedBook, height: 50, justView: justView),
edit ? Container() : Divider(height: 5, thickness: 2,),
Comment(insertedBook: insertedBook, height: 50, justView: justView),
Divider(height: 5, thickness: 2,),
Price(insertedBook: insertedBook, height: 50, justView: justView),
Divider(height: 5, thickness: 2,),
Exchange(insertedBook: insertedBook, height: 50, justView: justView),
//Divider(height: 5, thickness: 2,),
//SizedBox(height: 50,),
],
),
),
//(edit || justView || _isTablet) ? Container(): BottomTwoDots(darkerIndex: 2, size: 9.0,),
//SizedBox(height: 15,),
],
),
);
*/