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
    // Call the user's CollectionReference to add a new user
    return usersCollection
        .add({
      'uid': uid, // John Doe
      'name': 'alessio', //TODO add name of user and add name of the document
      'forSaleBooks': [],
      'toExchangeBooks': [],
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  Future addUserBook(InsertedBook book, bool forSale) async {
    if (forSale) {
      return await bookCollection.doc(uid).update({
        'bookForSale': FieldValue.arrayUnion([book])
      });
    }
    else{
      return await bookCollection.doc(uid).update({
        'bookToExchange': FieldValue.arrayUnion([book])
      });
    }
  }

  // brew list from snapshot
  //void _bookListFromSnapshot(QuerySnapshot snapshot) {
  //  snapshot.docs.map((doc) {
  //    print(doc.data);});
      //return InsertedBook(
      //  title: doc.data['title'] ?? '',
      //  author: doc.data['author'] ?? '',
      //)}).toList();
  }
/*
  // brew list from snapshot
  List<String> _bookListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => "alessio").toList();
  }
*/

  // user data from snapshots
  /*

  InsertedBook(
        doc['title'] ?? '',
        doc['author'] ?? '')

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
    );
  }
  */

  // get brews stream
/*
  Stream<List<InsertedBook>> get booksForSale {
    return bookCollection.doc(uid).
      .map(_bookForSaleListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }
*/