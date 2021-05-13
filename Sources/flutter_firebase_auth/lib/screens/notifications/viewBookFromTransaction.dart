import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/status.dart';

import 'package:flutter_firebase_auth/utils/constants.dart';


class ViewBookFromTransaction extends StatelessWidget {

  InsertedBook book;

  ViewBookFromTransaction({Key key, this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(book.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,// - appBarHeight,
        padding: EdgeInsets.fromLTRB(
            _isTablet ? 150.0 : _isPortrait ? 20.0 : 120.0,
            _isTablet ? 40.0 : 0.0,
            _isTablet ? 150.0 : _isPortrait ? 20.0 : 120.0,
            _isTablet ? 40.0 : 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: _isTablet ? MainAxisAlignment.center : MainAxisAlignment.end,
            children: [
              ImageService(insertedBook: book, justView: true),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Title",
                          style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 10,
                        child: Text(book.title,
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.white)
                        )
                    )
                  ],
                ),
              ),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Author",
                          style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 10,
                        child: Text(book.author.substring(1, book.author.length - 1),
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.white)
                        )
                    )
                  ],
                ),
              ),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Status(insertedBook: book, height: 50, offset: 50.0, justView: true),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Category",
                          style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 10,
                        child: Text(book.category,
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.white)
                        )
                    )
                  ],
                ),
              ),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              book.price != null ? Price(insertedBook: book, height: 50, justView: true,) : Container(),
              book.price != null ? Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,) : Container(),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}
