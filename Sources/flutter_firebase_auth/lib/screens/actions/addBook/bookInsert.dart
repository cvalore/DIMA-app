import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookSelection.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/addBookParameters.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:provider/provider.dart';

class BookInsert extends StatefulWidget {

  final AddBookParameters param;
  final void Function(int) setIndex;
  BookGeneralInfo selectedBook;

  BookInsert({Key key, this.param, this.setIndex, this.selectedBook}) : super(key: key);

  @override
  _BookInsertState createState() => _BookInsertState();

  //static _TestPageState of(BuildContext context) => context.findAncestorStateOfType<_TestPageState>();
}

class _BookInsertState extends State<BookInsert> {

  final PageController controller = PageController();
  int currentPageValue = 0;
  final pageViewSize = 2;
  InsertedBook _insertedBook = InsertedBook();
  DatabaseService _db;

  void setSelected(dynamic sel) {
    setState(() {
      widget.selectedBook = sel;
    });
  }

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    _db = DatabaseService(user: user);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: currentPageValue == pageViewSize - 1 ?
          FloatingActionButton.extended(
            heroTag: "saveBtn",
            onPressed: () async {
              if (widget.selectedBook.title != null) {
                if ( _insertedBook.category == null || _insertedBook.category == '') {
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      'You need to insert book category',
                      ),
                    );
                    // Find the Scaffold in the widget tree and use
                    // it to show a SnackBar.
                  Scaffold.of(context).showSnackBar(snackBar);
              } else if (_insertedBook.price == null || _insertedBook.price == 0.0) {
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      'You need to insert a price for the book',
                    ),
                  );
                  // Find the Scaffold in the widget tree and use
                  // it to show a SnackBar.
                  Scaffold.of(context).showSnackBar(snackBar);
              } else {
                  _insertedBook.setIdTitleAuthorIsbn(
                      widget.selectedBook.id,
                      widget.selectedBook.title,
                      widget.selectedBook.author,
                      widget.selectedBook.isbn13);
                  _insertedBook.setBookGeneralInfo(widget.selectedBook);
                  //_insertedBook.printBook();
                  await _db.addUserBook(_insertedBook);
                  widget.setIndex(0);
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      'Book added successfully',
                    ),
                  );
                  // Find the Scaffold in the widget tree and use
                  // it to show a SnackBar.
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              }
            },
            icon: Icon(Icons.save),
            label: Text("Save"),
          ) : null,
      body: widget.selectedBook != null ?
        PageView(
          controller: controller,
          onPageChanged: (index) {
            //print("the index is $index");
            setState(() {
              currentPageValue = index;
            });
          },
          children: <Widget>[
            AddBookSelection(
              setSelected: setSelected,
              selectedBook: widget.selectedBook,
              showDots: true,
              controller: controller,
              appBarHeight: Scaffold.of(context).appBarMaxHeight,
            ),
            AddBookUserInfo(insertedBook: _insertedBook, edit: false,),
          ],
        ) :
        PageView(
          controller: controller,
          children: <Widget>[
            AddBookSelection(
              setSelected: setSelected,
              selectedBook: widget.selectedBook,
              showDots: false,
              appBarHeight: Scaffold.of(context).appBarMaxHeight,
            ),
          ],
        )
    );
  }
}
