import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/services/database.dart';

class SaveButtonAddBook extends StatelessWidget {

  final InsertedBook insertedBook;
  final DatabaseService db;
  final BookGeneralInfo selectedBook;
  final Function(int) setIndex;

  const SaveButtonAddBook({Key key, this.insertedBook, this.db, this.selectedBook, this.setIndex}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.white24,
      heroTag: "saveBtn",
      onPressed: () async {
        if (selectedBook.title != null) {
          if (insertedBook.category == null || insertedBook.category == '') {
            final snackBar = SnackBar(
              backgroundColor: Colors.white24,
              duration: Duration(seconds: 1),
              content: Text(
                'You need to insert book category',
                style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16.0),
              ),
            );
            // Find the Scaffold in the widget tree and use
            // it to show a SnackBar.
            Scaffold.of(context).showSnackBar(snackBar);
          } else if (insertedBook.price == null || insertedBook.price == 0.0) {
            final snackBar = SnackBar(
              backgroundColor: Colors.white24,
              duration: Duration(seconds: 1),
              content: Text(
                'You need to insert a price for the book',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16.0),
              ),
            );
            // Find the Scaffold in the widget tree and use
            // it to show a SnackBar.
            Scaffold.of(context).showSnackBar(snackBar);
          } else {
            insertedBook.setIdTitleAuthorIsbn(
                selectedBook.id,
                selectedBook.title,
                selectedBook.author,
                selectedBook.isbn13);
            insertedBook.setBookGeneralInfo(selectedBook);
            //_insertedBook.printBook();
            await db.addUserBook(insertedBook);
            //setIndex(0);
            final snackBar = SnackBar(
              backgroundColor: Colors.white24,
              duration: Duration(seconds: 1),
              content: Text(
                'Book added successfully',
                style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16.0),
              ),
            );
            // Find the Scaffold in the widget tree and use
            // it to show a SnackBar.
            Scaffold.of(context).showSnackBar(snackBar);
            Timer timer = Timer(Duration(milliseconds: 1500), () {Navigator.pop(context);});
          }
        }
      },
      icon: Icon(Icons.save, color: Colors.white),
      label: Text("Save", style: TextStyle(color: Colors.white),),
    );
  }
}
