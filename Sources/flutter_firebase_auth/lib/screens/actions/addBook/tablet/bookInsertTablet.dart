import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';

import '../addBookSelection.dart';
import '../addBookUserInfo.dart';

class BookInsertTablet extends StatefulWidget {

  BookGeneralInfo selectedBook;
  InsertedBook insertedBook;
  final Function(dynamic sel) setFatherSelected;

  BookInsertTablet({this.selectedBook, this.insertedBook, this.setFatherSelected});

  @override
  _BookInsertTabletState createState() => _BookInsertTabletState();
}

class _BookInsertTabletState extends State<BookInsertTablet> {
  void setSelected(dynamic sel) {
    setState(() {
      widget.selectedBook = sel;
    });
    widget.setFatherSelected(sel);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: AddBookSelection(
            setSelected: setSelected,
            selectedBook: widget.selectedBook,
            showDots: false,
            appBarHeight: Scaffold.of(context).appBarMaxHeight,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: widget.selectedBook != null ?
            AddBookUserInfo(
              insertedBook: widget.insertedBook,
              edit: false,
              justView: false,
              appBarHeight: Scaffold.of(context).appBarMaxHeight,
            ) : Container(),
        ),
      ],
    );
  }
}
