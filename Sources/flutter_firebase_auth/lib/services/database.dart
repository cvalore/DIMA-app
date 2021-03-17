import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/storage.dart';
import 'package:image_picker/image_picker.dart';

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
    int numberOfInsertedItems;

    await usersCollection.doc(user.uid).get().then(
            (userDoc) {
          numberOfInsertedItems = userDoc.data()['numberOfInsertedItems'];
        });

    // add book to book collection
    var generalInfoBookMap = book.generalInfoToMap();
    await bookCollection
        .where('id', isEqualTo: generalInfoBookMap['id'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 1) {
        // if the book already exists insert the new owner having it
        bookCollection.doc(querySnapshot.docs[0].id)
            .update({'owners': FieldValue.arrayUnion([user.uid])});
        print("Book already present, add you as owner too");
      } else {
        generalInfoBookMap['owners'] = [user.uid];
        bookCollection.doc(book.id).set(generalInfoBookMap)
            .catchError((error) => print("Failed to add book: $error"));
      }
    });

    //add book images to the storage
    if(book.imagesPath != null) {
      /*List<String> imagesUrl = await storageService.addBookPictures(
          user.uid, book.title, numberOfInsertedItems, book.images);
      book.imagesUrl = imagesUrl;*/
      List<String> imagesUrl = List<String>();
      for(int i = 0; i < book.imagesPath.length; i++) {
        Reference imgRef = await storageService.addBookPicture(
          user.uid,
          book.title,
          numberOfInsertedItems,
          book.imagesPath[i],
          i
        );
        String imgUrl = await storageService.getUrlPicture(imgRef);
        imagesUrl.add(imgUrl);
      }

      book.imagesUrl = imagesUrl;
    }
    else {
      book.imagesUrl = List<String>();
    }

    book.setInsertionNumber(numberOfInsertedItems);
    var mapBook = book.toMap();
    // add book to the user collection
    await usersCollection.doc(user.uid).update({
      'books': FieldValue.arrayUnion([mapBook]),
      'numberOfInsertedItems': numberOfInsertedItems + 1,
    });

    print("Book added");
  }

  Future updateBook(InsertedBook book, int index) async {
    List<dynamic> books;

    int numberOfInsertedItems;

    await storageService.removeBookPicture(user.uid, book.title, book.insertionNumber);

    await usersCollection.doc(user.uid).get().then(
            (userDoc) {
          numberOfInsertedItems = userDoc.data()['numberOfInsertedItems'];
        });

    await usersCollection.doc(user.uid).get().then(
      (userDoc) {
        books = userDoc.data()['books'];
      });

    if(book.imagesPath != null) {
      /*List<String> imagesUrl = await storageService.addBookPictures(
          user.uid, book.title, numberOfInsertedItems, book.images);
      book.imagesUrl = imagesUrl;*/
      List<String> imagesUrl = List<String>();
      for(int i = 0; i < book.imagesPath.length; i++) {
        Reference imgRef = await storageService.addBookPicture(
            user.uid,
            book.title,
            numberOfInsertedItems,
            book.imagesPath[i],
            i
        );
        String imgUrl = await storageService.getUrlPicture(imgRef);
        imagesUrl.add(imgUrl);
      }

      book.imagesUrl = imagesUrl;
    }
    else {
      book.imagesUrl = List<String>();
    }
    book.setInsertionNumber(numberOfInsertedItems);

    books[index]["insertionNumber"] = book.insertionNumber;
    books[index]["comment"] = book.comment;
    books[index]["status"] = book.status;
    books[index]["category"] = book.category;
    books[index]["price"] = book.price;
    books[index]["exchangeable"] = book.exchangeable;
    books[index]["imagesUrl"] = book.imagesUrl;

    await usersCollection.doc(user.uid).update({
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

  Future removeBook(int index, int insertionNumber, String bookTitle) async {

    String id = "";

    await usersCollection.doc(user.uid).get().then(
            (userDoc) async {
              List<dynamic> books = userDoc.data()['books'];
              id = books[index]['id'];
              books.removeAt(index);

              await usersCollection.doc(user.uid).update({
                'books': books
              });
            }
    );

    await bookCollection
        .where('id', isEqualTo: id)
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size == 1) {
            //TODO qua ci va await ?
            List<dynamic> owners;
            bookCollection.doc(querySnapshot.docs[0].id)
              .get().then((book)
                {
                  owners = book['owners'];
                  if(owners.contains(user.uid)) {
                    if(owners.length <= 1) {
                      //remove all the document
                      print('No other user has this book, removing all...');

                      bookCollection.doc(querySnapshot.docs[0].id).delete();
                    }
                    else {
                      //remove only the current user
                      print('Other users have this book, just removing you...');
                      //owners.remove(user.uid);

                      bookCollection.doc(querySnapshot.docs[0].id)
                          .update({'owners': FieldValue.arrayRemove([user.uid])});
                    }
                  }
                }
            );
          }
        }
    );

    await storageService.removeBookPicture(user.uid, bookTitle, insertionNumber);

    print("Book removed");
  }

  Future<InsertedBook> getBook(int index) async {

    dynamic book;
    await usersCollection.doc(user.uid).get().then(
      (userDoc) {
        List<dynamic> books = userDoc.data()['books'];
        book = books[index];
      });

    //print('Get book ---> ' + book.toString());

    return book == null ?
        InsertedBook() :
        InsertedBook(
          id: book["id"],
          title: book["title"],
          status: book["status"],
          comment: book["comment"],
          imagesUrl: List.from(book['imagesUrl']),
          insertionNumber: book["insertionNumber"],
          category: book["category"],
          price: book["price"]*1.0,
          exchangeable: book["exchangeable"],
        );
  }

}