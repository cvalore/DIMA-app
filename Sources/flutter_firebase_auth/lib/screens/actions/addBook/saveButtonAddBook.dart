import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/services/database.dart';

class SaveButtonAddBook extends StatefulWidget {

  final InsertedBook insertedBook;
  final DatabaseService db;
  final BookGeneralInfo selectedBook;
  final bool edit;
  final int editIndex;
  final Function(InsertedBook) updateBook;
  final Function() clearFields;
  final Function(bool) setLoading;

  SaveButtonAddBook({Key key, this.insertedBook, this.db, this.selectedBook, this.edit, this.editIndex, this.updateBook, this.clearFields, this.setLoading}) : super(key: key);

  @override
  _SaveButtonAddBookState createState() => _SaveButtonAddBookState();
}

class _SaveButtonAddBookState extends State<SaveButtonAddBook> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.white24,
      heroTag: "saveBtn",
      onPressed: () async {
        if(pressed) {
          return;
        }
        setState(() {
          pressed = true;
        });
        if(widget.edit) {
          widget.setLoading(true);
          bool hadImages = widget.insertedBook.imagesUrl != null && widget.insertedBook.imagesUrl.length != 0;
          bool wasExchangeable = widget.insertedBook.exchangeable;
          await widget.db.updateBook(widget.insertedBook, widget.editIndex, hadImages, wasExchangeable);

          if(widget.updateBook != null) {
            widget.updateBook(widget.insertedBook);
          }

          final snackBar = SnackBar(
            backgroundColor: Colors.white24,
            duration: Duration(seconds: 1),
            content: Text(
              'Book updated successfully',
            ),
          );
          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          widget.setLoading(false);
          Scaffold.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }
        else if (widget.selectedBook.title != null) {
          if (widget.insertedBook.category == null || widget.insertedBook.category == '') {
            final snackBar = SnackBar(
              backgroundColor: Colors.white24,
              duration: Duration(seconds: 1),
              content: Text(
                'You need to insert book category',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
            // Find the Scaffold in the widget tree and use
            // it to show a SnackBar.
            Scaffold.of(context).showSnackBar(snackBar);
          } else if (widget.insertedBook.price == null || widget.insertedBook.price == 0.0) {
            final snackBar = SnackBar(
              backgroundColor: Colors.white24,
              duration: Duration(seconds: 1),
              content: Text(
                'You need to insert a price for the book',
                  style: Theme.of(context).textTheme.bodyText2,
              ),
            );
            // Find the Scaffold in the widget tree and use
            // it to show a SnackBar.
            Scaffold.of(context).showSnackBar(snackBar);
          } else {
            widget.setLoading(true);
            widget.insertedBook.setIdTitleAuthorIsbn(
                widget.selectedBook.id,
                widget.selectedBook.title,
                widget.selectedBook.author,
                widget.selectedBook.isbn13);
            widget.insertedBook.setBookGeneralInfo(widget.selectedBook);
            //_insertedBook.printBook();
            await widget.db.addUserBook(widget.insertedBook);
            if(widget.clearFields != null) {
              widget.clearFields();
            }
            final snackBar = SnackBar(
              backgroundColor: Colors.white24,
              duration: Duration(seconds: 1),
              content: Text(
                'Book added successfully',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
            // Find the Scaffold in the widget tree and use
            // it to show a SnackBar.
            Scaffold.of(context).showSnackBar(snackBar);
            Timer timer = Timer(Duration(milliseconds: 1500), () {widget.setLoading(false); Navigator.pop(context);});
          }
        }
        Timer timer = Timer(Duration(milliseconds: 1500), () {setState(() {
          pressed = false;
        });});
      },
      icon: Icon(Icons.save, color: Colors.white),
      label: Text(pressed ? "Saving..." : "Save", style: TextStyle(color: Colors.white),),
    );
  }
}
