import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/storage.dart';

class DatabaseService {

  final CustomUser user;
  DatabaseService({ this.user });
  StorageService storageService = StorageService();

  // collection reference
  final CollectionReference bookCollection = FirebaseFirestore.instance.collection('books');
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> initializeUser() {
    var userMap = user.toMap();
    return usersCollection.doc(user.uid).get().then((DocumentSnapshot doc) {
      if(!doc.exists) {
        usersCollection.doc(user.uid).set(userMap)
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }


  Future addUserBook(InsertedBook book) async {
    // add book to the user collection
    var mapBook = book.toMap();
    await usersCollection.doc(user.uid).update({
      'books': FieldValue.arrayUnion([mapBook])
    });

    // add book to book collection
    var generalInfoBookMap = book.generalInfoToMap();
    await bookCollection
        .where('isbn', isEqualTo: generalInfoBookMap['isbn'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 1) {
        // if the book already exists insert the new owner having it
        //TODO qua ci va await ?
        bookCollection.doc(querySnapshot.docs[0].id)
            .update({'owners': FieldValue.arrayUnion([user.uid])});
        print("Update done");
      } else {
        generalInfoBookMap['owners'] = [user.uid];
        //TODO qua ci va await ?
        bookCollection.doc(mapBook['isbn']).set(generalInfoBookMap)
            .then((value) => print("Book added"))
            .catchError((error) => print("Failed to add book: $error"));
      }
    });

    //add book images to the storage
    if(book.images != null)
      storageService.addBookPictures(user.uid, book.title, book.images);

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
            title: book['title'],
            author: book['author'],
            isbn13: book['isbn'],
            status: book['status']
            //TODO add purpose
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
        InsertedBook() :   //TODO riguardare questo controllo
        InsertedBook(
            title: book['title'],
            author: book['author'],
            isbn13: book['isbn'],
            status: book['status']
            //TODO add purpose
        );
  }

}