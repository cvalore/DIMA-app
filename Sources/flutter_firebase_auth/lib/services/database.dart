import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/inserted_book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference bookCollection = FirebaseFirestore.instance.collection('books');
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');


  Future<void> initializeUser() {
    return usersCollection
        .doc(uid)
        .set({
      'name': "Mary Jane",    //TODO add a name for the user
      'books': [],
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  Future addUserBook(InsertedBook book) async {
    var mapBook = book.toMap();
    await usersCollection.doc(uid).update({
      'books': FieldValue.arrayUnion([mapBook])
    });
  }


  List<InsertedBook> _bookListFromSnapshot(DocumentSnapshot documentSnapshot) {
    List<InsertedBook> mylist = [];
    if (documentSnapshot.exists) {
      for (var book in documentSnapshot.get("books")) {
        InsertedBook insertedBook = InsertedBook(title: book['title'] ?? '', author: book['author'] ?? '', purpose: book['purpose'] ?? '',
                                                  genre: book['genre']);
        mylist.add(insertedBook);
      }
    }
    return mylist;
  }


  Stream<List<InsertedBook>> get userBooks{
    Stream<List<InsertedBook>> result =  usersCollection.doc(uid).snapshots()
            .map(_bookListFromSnapshot);
    return result;
  }

  }