import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/addBookParameters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class BookList extends StatefulWidget {

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    final DatabaseService _db = DatabaseService(user: user);

    var books = [];
    books = Provider.of<List<InsertedBook>>(context);
    if (books == null || books.length == 0){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('No books yet, the books you add will appear here',
            style: TextStyle(color: Colors.blueGrey[300]),),
            Icon(Icons.menu_book_rounded, color: Colors.blueGrey[300],),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: books.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: UniqueKey(),
            background: Container(color: Colors.red[600]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              InsertedBook book = await _db.getBook(index);
              dynamic result = await _db.removeBook(index, book);
              Scaffold.of(context).showSnackBar(
                SnackBar(duration: Duration(seconds: 1), content: Text(
                  'Book removed: ' + '${books[index].title}',)),
              );
            },
            child: ListTile(
              title: Text('${books[index].title}'),
              subtitle: Text('by ${books[index].author}'),
              trailing: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                ),
                child: Icon(Icons.remove_circle_outline, color: Colors.red,),
                onPressed: () async {
                  InsertedBook book = await _db.getBook(index);
                  dynamic result = await _db.removeBook(index, book);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(duration: Duration(seconds: 1), content: Text(
                      'Book removed: ' + '${books[index].title}',)),
                  );
                },
              ),
              onTap: () async {
                InsertedBook book = await _db.getBook(index);
                Reference bookRef = _db.storageService.getBookDirectoryReference(user.uid, book);
                List<String> bookPickedFilePaths = List<String>();
                ListResult lr = await bookRef.listAll();
                int count = 0;
                for(Reference r in lr.items) {
                  try {
                    String filePath = await _db.storageService.toDownloadFile(r, count);
                    if(filePath != null) {
                      bookPickedFilePaths.add(filePath);
                    }
                  } on FirebaseException catch (e) {
                    e.toString();
                  }
                  count = count + 1;
                }
                book.imagesPath = bookPickedFilePaths;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (newContext) =>
                      Scaffold(
                        appBar: AppBar(
                          //backgroundColor: Colors.blueGrey[700],
                          elevation: 0.0,
                          title: Text('BookYourBook'),
                          actions: <Widget>[
                            TextButton.icon(
                              icon: Icon(Icons.logout, color: Colors.white,),
                              label: Text(''),
                              onPressed: () async {
                                await _auth.signOut();
                              },
                            ),
                          ],
                        ),
                        floatingActionButton: FloatingActionButton.extended(
                          heroTag: "editSaveBtn",
                          onPressed: () async {
                            await _db.updateBook(book, index);
                            final snackBar = SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(
                                'Book updated successfully',
                              ),
                            );
                            Navigator.pop(context);
                            // Find the Scaffold in the widget tree and use
                            // it to show a SnackBar.
                            Scaffold.of(context).showSnackBar(snackBar);
                          },
                          icon: Icon(Icons.save),
                          label: Text("Save"),
                        ),
                        body: AddBookUserInfo(
                          insertedBook: book, edit: true,
                        ),
                      )
                    )
                );
              },
            ),
          );
        },
      );
      for (var book in books) {
        print("$book + bam");
      }
    }
    //var datum = books.data();
    //print(books.data()['book']);
    //print('$datum altro');
    return Text('sticazzzzz');
  }
}

    /*
    List books = [];
    books.add(InsertedBook(title: 'Oceano Mare', author: 'Alessandro Baricco'));
    books.add(InsertedBook(title: 'Emmaus', author: 'Alessandro Baricco'));
    books.add(InsertedBook(title: 'Un uomo', author: 'Oriana Fallaci'));

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
          title: Text('Ciao'),
    ),
          body: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
              return ListTile(
                  title: Text('title: ${books[index].title}'),
                  subtitle: Text('author: ${books[index].author}'),
                  );
            }),
    ),
    );
  }

     */


