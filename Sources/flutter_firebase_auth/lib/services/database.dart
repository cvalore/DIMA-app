import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/inserted_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/models/user.dart';

class DatabaseService {

  final CustomUser user;
  DatabaseService({ this.user });

  // collection reference
  final CollectionReference bookCollection = FirebaseFirestore.instance.collection('books');
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> initializeUser() {

    var doc = usersCollection.doc(user.uid);

    return doc != null ? doc :
      doc.set({
        'name': user.email,    //TODO add a name for the user
        'books': [],
      })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  Future addUserBook(InsertedBook book) async {
    var mapBook = book.toMap();
    await usersCollection.doc(user.uid).update({
      'books': FieldValue.arrayUnion([mapBook])
    });

    // trick to add more than one book at a time :)
    /*
    for (int i = 4; i < 17; i++) {
      InsertedBook b = InsertedBook(title: book.title + i.toString(), author: book.author + i.toString(), genre: book.genre, purpose: book.purpose);
      var mb = b.toMap();

      await usersCollection.doc(user.uid).update({
        'books': FieldValue.arrayUnion([mb])
      });
    }
    */
  }

  Future updateBook(InsertedBook book, int index) async {
    var mapBook = book.toMap();
    List<dynamic> books;

    await usersCollection.doc(user.uid).get().then(
      (userDoc) {
        books = userDoc.data()['books'];
      });

    books[index] = mapBook;
    await usersCollection.doc(user.uid).set({
      'books': books
    }).then((value) => print("Book updated"));
  }


  List<InsertedBook> _bookListFromSnapshot(DocumentSnapshot documentSnapshot) {
    List<InsertedBook> mylist = [];
    if (documentSnapshot.exists) {
      for (var book in documentSnapshot.get("books")) {
        InsertedBook insertedBook = InsertedBook(
            title: book['title'] ?? '',
            author: book['author'] ?? '',
            purpose: book['purpose'] ?? '',
            genre: book['genre']
        );
        mylist.add(insertedBook);
      }
    }
    return mylist;
  }


  Stream<List<InsertedBook>> get userBooks{
    Stream<List<InsertedBook>> result =  usersCollection.doc(user.uid).snapshots()
            .map(_bookListFromSnapshot);
    return result;
  }

  Future removeBook(int index) async {
    await usersCollection.doc(user.uid).get().then(
            (userDoc) async {
              List<dynamic> books = userDoc.data()['books'];
              books.removeAt(index);

              await usersCollection.doc(user.uid).set({
                'books': books
              }).then((value) => print("Book removed"));

              //print(books);
            }
    );
  }

  Future<InsertedBook> getBook(int index) async {

    dynamic book;

    await usersCollection.doc(user.uid).get().then(
      (userDoc) {
        List<dynamic> books = userDoc.data()['books'];
        book = books[index];
      });

    print('Get book ---> ' + book.toString());

    return book == null ?
        InsertedBook(title: '',author: '',genre: '',purpose: '') :
        InsertedBook(
          title: book['title'] ?? '',
          author: book['author'] ?? '',
          purpose: book['purpose'] ?? '',
          genre: book['genre'],
        );
  }

}