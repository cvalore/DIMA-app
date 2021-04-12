import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';

class SaveButtonAddBook extends StatelessWidget {

  final InsertedBook insertedBook;
  final DatabaseService db;
  final BookGeneralInfo selectedBook;
  final bool edit;
  final int editIndex;
  final Function(InsertedBook) updateBook;

  const SaveButtonAddBook({Key key, this.insertedBook, this.db, this.selectedBook, this.edit, this.editIndex, this.updateBook}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    return FloatingActionButton.extended(
      backgroundColor: Colors.white24,
      heroTag: "saveBtn",
      onPressed: () async {
        if(edit) {
          bool hadImages = insertedBook.imagesUrl != null && insertedBook.imagesUrl.length != 0;
          bool wasExchangeable = insertedBook.exchangeable;
          await db.updateBook(insertedBook, editIndex, hadImages, wasExchangeable);

          if(updateBook != null) {
            updateBook(insertedBook);
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
          Scaffold.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }
        else if (selectedBook.title != null) {
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
