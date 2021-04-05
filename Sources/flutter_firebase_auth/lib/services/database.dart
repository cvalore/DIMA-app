import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/storage.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';

class DatabaseService {

  final CustomUser user;

  //int idGeneralInfoToSearch;
  DatabaseService({ this.user });

  StorageService storageService = StorageService();

  // collection reference
  final CollectionReference bookCollection = FirebaseFirestore.instance
      .collection('books');
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');
  final CollectionReference booksPerGenreCollection = FirebaseFirestore.instance
      .collection('booksPerGenre');

  Future<void> initializeUser() {
    var userMap = user.toMap();
    return usersCollection.doc(user.uid).get().then((DocumentSnapshot doc) {
      if (!doc.exists) {
        usersCollection.doc(user.uid).set(userMap)
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }

  Future<bool> updateUserInfo(String imageProfilePath, String fullName,
      String birthday, String bio, String city) async {
    Map<String, dynamic> updates = Map<String, dynamic>();
    updates['fullName'] = fullName;
    updates['birthday'] = birthday;
    updates['bio'] = bio;
    updates['city'] = city;
    if (imageProfilePath != '') {
      Reference reference = await storageService.addUserProfilePic(
          user.uid, imageProfilePath);
      String imgUrl = await storageService.getUrlPicture(reference);
      updates['userProfileImageURL'] = imgUrl;
    }

    usersCollection.doc(user.uid).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        usersCollection.doc(user.uid).update(
            updates
        )
            .then((value) => print("image profile added"))
            .catchError((error) =>
            print("Failed to add image profile: $error"));
      }
    }
    );
    return true;
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
        if (book.exchangeable && book.imagesPath != null &&
            book.imagesPath.length != 0) {
          bookCollection.doc(querySnapshot.docs[0].id)
              .update({
            'owners': FieldValue.arrayUnion([user.uid]),
            'availableNum': FieldValue.increment(1),
            'exchangeable': FieldValue.increment(1),
            'haveImages': FieldValue.increment(1),
          });
        }
        else if (book.exchangeable) {
          bookCollection.doc(querySnapshot.docs[0].id)
              .update({
            'owners': FieldValue.arrayUnion([user.uid]),
            'availableNum': FieldValue.increment(1),
            'exchangeable': FieldValue.increment(1),
          });
        }
        else if (book.imagesPath != null && book.imagesPath.length != 0) {
          bookCollection.doc(querySnapshot.docs[0].id)
              .update({
            'owners': FieldValue.arrayUnion([user.uid]),
            'availableNum': FieldValue.increment(1),
            'haveImages': FieldValue.increment(1),
          });
        }
        else {
          bookCollection.doc(querySnapshot.docs[0].id)
              .update({
            'owners': FieldValue.arrayUnion([user.uid]),
            'availableNum': FieldValue.increment(1),
          });
        }
        print("Book already present, add you as owner too");
      } else {
        generalInfoBookMap['owners'] = [user.uid];
        bookCollection.doc(book.id).set(generalInfoBookMap)
            .catchError((error) => print("Failed to add book: $error"));
      }
    });

    //add book images to the storage
    if (book.imagesPath != null) {
      /*List<String> imagesUrl = await storageService.addBookPictures(
          user.uid, book.title, numberOfInsertedItems, book.images);
      book.imagesUrl = imagesUrl;*/
      List<String> imagesUrl = List<String>();
      for (int i = 0; i < book.imagesPath.length; i++) {
        Reference imgRef = await storageService.addBookPicture(
            user.uid,
            book.title,
            numberOfInsertedItems + 1,
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

    numberOfInsertedItems += 1;
    book.setInsertionNumber(numberOfInsertedItems);
    var mapBook = book.toMap();
    // add book to the user collection
    await usersCollection.doc(user.uid).update({
      'books': FieldValue.arrayUnion([mapBook]),
      'numberOfInsertedItems': FieldValue.increment(1),
    });

    Map<String, dynamic> bookPerGenreInfo = {
      'title': book.title,
      'author': book.author,
      'thumbnail': book.bookGeneralInfo.thumbnail,
    };
    Map<String, dynamic> bookPerGenreMap = {
      book.id: bookPerGenreInfo,
    };
    await booksPerGenreCollection.doc(book.category).get().then((
        DocumentSnapshot doc) {
      if (!doc.exists) {
        booksPerGenreCollection.doc(book.category).set({
          "books": FieldValue.arrayUnion([bookPerGenreMap]),
        });
      }
      else {
        booksPerGenreCollection.doc(book.category).update({
          "books": FieldValue.arrayUnion([bookPerGenreMap]),
        });
      }
    });

    print("Book added");
  }

  Future updateBook(InsertedBook book, int index, bool hadImages,
      bool wasExchangeable) async {
    List<dynamic> books;

    int numberOfInsertedItems;

    await storageService.removeBookPicture(
        user.uid, book.title, book.insertionNumber);

    await usersCollection.doc(user.uid).get().then(
            (userDoc) {
          numberOfInsertedItems = userDoc.data()['numberOfInsertedItems'];
        });

    await usersCollection.doc(user.uid).get().then(
            (userDoc) {
          books = userDoc.data()['books'];
        });

    if (book.imagesPath != null) {
      /*List<String> imagesUrl = await storageService.addBookPictures(
          user.uid, book.title, numberOfInsertedItems, book.images);
      book.imagesUrl = imagesUrl;*/
      List<String> imagesUrl = List<String>();
      for (int i = 0; i < book.imagesPath.length; i++) {
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
    });

    // update book of books collection
    await bookCollection
        .where('id', isEqualTo: books[index]['id'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 1) {
        if (wasExchangeable && hadImages) {
          if (!book.exchangeable &&
              !(book.imagesUrl != null && book.imagesUrl.length != 0)) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'exchangeable': FieldValue.increment(-1),
              'haveImages': FieldValue.increment(-1),
            });
          }
          else if (!book.exchangeable) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'exchangeable': FieldValue.increment(-1),
            });
          }
          else if (!(book.imagesUrl != null && book.imagesUrl.length != 0)) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'haveImages': FieldValue.increment(-1),
            });
          }
        }
        else if (wasExchangeable) {
          if (!book.exchangeable && book.imagesUrl != null &&
              book.imagesUrl.length != 0) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'exchangeable': FieldValue.increment(-1),
              'haveImages': FieldValue.increment(1),
            });
          }
          else if (!book.exchangeable) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'exchangeable': FieldValue.increment(-1),
            });
          }
          else if (book.imagesUrl != null && book.imagesUrl.length != 0) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'haveImages': FieldValue.increment(1),
            });
          }
        }
        else if (hadImages) {
          if (book.exchangeable &&
              !(book.imagesUrl != null && book.imagesUrl.length != 0)) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'exchangeable': FieldValue.increment(1),
              'haveImages': FieldValue.increment(-1),
            });
          }
          else if (book.exchangeable) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'exchangeable': FieldValue.increment(1),
            });
          }
          else if (!(book.imagesUrl != null && book.imagesUrl.length != 0)) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'haveImages': FieldValue.increment(-1),
            });
          }
        }
        else {
          if (book.exchangeable && book.imagesUrl != null &&
              book.imagesUrl.length != 0) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'exchangeable': FieldValue.increment(1),
              'haveImages': FieldValue.increment(1),
            });
          }
          else if (book.exchangeable) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'exchangeable': FieldValue.increment(1),
            });
          }
          else if (book.imagesUrl != null && book.imagesUrl.length != 0) {
            bookCollection.doc(querySnapshot.docs[0].id)
                .update({
              'haveImages': FieldValue.increment(1),
            });
          }
        }
      }
    });

    print("Book updated");
  }

  BookPerGenreUserMap _bookPerGenreUserListFromSnapshot(
      DocumentSnapshot documentSnapshot) {
    Map<int, dynamic> result = Map<int, dynamic>();
    if (documentSnapshot.exists) {
      int index = 0;
      for (var book in documentSnapshot.get("books")) {
        /*if(result.containsKey(book['category'])) {
          result[book['category']].add(book);
        }
        else {*/
        result.addAll({
          //book['category'] : [book],
          index: book,
        });
        index = index + 1;
        //}
      }
    }
    return BookPerGenreUserMap(result);
  }

  BookPerGenreMap _bookPerGenreListFromSnapshot(QuerySnapshot querySnapshot) {
    Map<String, dynamic> result = Map<String, dynamic>();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    for (QueryDocumentSnapshot qds in docs) {
      result[qds.id] = qds.data();
    }
    return BookPerGenreMap(result);
  }

  CustomUser _userInfoFromSnapshot(DocumentSnapshot documentSnapshot) {
    CustomUser user;
    Map<String, dynamic> userMap;
    List<InsertedBook> books = [];

    if (documentSnapshot.exists) {
      userMap = documentSnapshot.data();
      user = CustomUser(
        userMap['uid'],
        userMap['email'],
        userMap['isAnonymous'],
        username: userMap['username'],
        fullName: userMap['fullName'],
        birthday: userMap['birthday'],
        bio: userMap['bio'],
        city: userMap['city'],
        //usersFollowedByMe: userMap['usersFollowedByMe'],
        //TODO to test
        //usersFollowingMe: userMap['usersFollowingMe'],
        //TODO to test
        followers: userMap['followers'],
        following: userMap['following'],
        userProfileImageURL: userMap['userProfileImageURL'],
        numberOfInsertedItems: userMap['numberOfInsertedItems'],
      );
    }
    return user;
  }

  Stream<BookPerGenreMap> get perGenreBooks {
    Stream<BookPerGenreMap> result = booksPerGenreCollection.snapshots()
        .map(_bookPerGenreListFromSnapshot);
    return result;
  }

  Stream<BookPerGenreUserMap> get userBooksPerGenre {
    Stream<BookPerGenreUserMap> result = usersCollection.doc(user.uid)
        .snapshots()
        .map(_bookPerGenreUserListFromSnapshot);
    return result;
  }

  Stream<CustomUser> get userInfo {
    Stream<CustomUser> result = usersCollection.doc(user.uid).snapshots()
        .map(_userInfoFromSnapshot);
    return result;
  }

  Future removeBook(int index, InsertedBook book) async {
    String id = "";
    String thumbnail = "";
    int availableNum;
    bool duplicatePresent = false;
    bool bookDocumentRemoved = false;

    //remove from users collection
    await usersCollection.doc(user.uid).get().then(
            (userDoc) async {
          List<dynamic> books = userDoc.data()['books'];
          id = books[index]['id'];
          books.removeAt(index);

          for (int i = 0; i < books.length && !duplicatePresent; i++) {
            if (books[i]['id'] == id)
              duplicatePresent = true;
          }

          await usersCollection.doc(user.uid).update({
            'books': books
          });
        }
    );

    //remove from books collection
    await bookCollection
        .where('id', isEqualTo: id)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      if (querySnapshot.size == 1) {
        await bookCollection.doc(querySnapshot.docs[0].id)
            .get().then((bookDoc) {
          thumbnail = bookDoc.data().containsKey("thumbnail") ?
          bookDoc['thumbnail'] : null;
          availableNum = bookDoc['availableNum'];
          if (availableNum == 1) {
            //remove all the document
            print('No other user has this book, removing all...');

            bookCollection.doc(querySnapshot.docs[0].id).delete();
            bookDocumentRemoved = true;
          } else if (!duplicatePresent) {
            //remove only the current user
            print('Other users have this book, just removing you...');

            if (book.exchangeable && book.imagesUrl != null &&
                book.imagesUrl.length != 0) {
              bookCollection.doc(querySnapshot.docs[0].id)
                  .update({
                'owners': FieldValue.arrayRemove([user.uid]),
                'availableNum': FieldValue.increment(-1),
                'exchangeable': FieldValue.increment(-1),
                'haveImages': FieldValue.increment(-1),
              });
            }
            else if (book.exchangeable) {
              bookCollection.doc(querySnapshot.docs[0].id)
                  .update({
                'owners': FieldValue.arrayRemove([user.uid]),
                'availableNum': FieldValue.increment(-1),
                'exchangeable': FieldValue.increment(-1),
              });
            }
            else if (book.imagesUrl != null && book.imagesUrl.length != 0) {
              bookCollection.doc(querySnapshot.docs[0].id)
                  .update({
                'owners': FieldValue.arrayRemove([user.uid]),
                'availableNum': FieldValue.increment(-1),
                'haveImages': FieldValue.increment(-1),
              });
            }
            else {
              bookCollection.doc(querySnapshot.docs[0].id)
                  .update({
                'owners': FieldValue.arrayRemove([user.uid]),
                'availableNum': FieldValue.increment(-1),
              });
            }
          } else {
            //only decrement availableNum
            print(
                'The user removed a duplicated book, just reducing the availableNum...');
            if (book.exchangeable && book.imagesUrl != null &&
                book.imagesUrl.length != 0) {
              bookCollection.doc(querySnapshot.docs[0].id).update({
                'availableNum': FieldValue.increment(-1),
                'exchangeable': FieldValue.increment(-1),
                'haveImages': FieldValue.increment(-1),
              });
            }
            else if (book.exchangeable) {
              bookCollection.doc(querySnapshot.docs[0].id).update({
                'availableNum': FieldValue.increment(-1),
                'exchangeable': FieldValue.increment(-1),
              });
            }
            else if (book.imagesUrl != null && book.imagesUrl.length != 0) {
              bookCollection.doc(querySnapshot.docs[0].id).update({
                'availableNum': FieldValue.increment(-1),
                'haveImages': FieldValue.increment(-1),
              });
            }
            else {
              bookCollection.doc(querySnapshot.docs[0].id).update({
                'availableNum': FieldValue.increment(-1),
              });
            }
          }
        }
        );
      }
    }
    );

    //remove pictures from the storage
    await storageService.removeBookPicture(
        user.uid, book.title, book.insertionNumber);

    if (bookDocumentRemoved) {
      //remove book from book from genres
      Map<String, dynamic> bookToRemoveInfoMap = {
        "title": book.title,
        "author": book.author,
        "thumbnail": thumbnail,
      };
      Map<String, dynamic> bookToRemoveMap = {
        book.id: bookToRemoveInfoMap,
      };

      await booksPerGenreCollection.doc(book.category).update({
        'books': FieldValue.arrayRemove([bookToRemoveMap]),
      });
    }

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
      author: book["author"],
      status: book["status"],
      comment: book["comment"],
      imagesUrl: List.from(book['imagesUrl']),
      insertionNumber: book["insertionNumber"],
      category: book["category"],
      price: book["price"] * 1.0,
      exchangeable: book["exchangeable"],
    );
  }

  /*void setIdToSearchGeneralInfoFor(int id) {
    this.idGeneralInfoToSearch = id;
  }*/

  Future<dynamic> getGeneralBookInfo(String bookId) async {
    dynamic book;
    await bookCollection.doc(bookId).get().then((value) {
      book = value.data();
    });
    return book;
  }

  Future<dynamic> getBookSoldBy(String bookId) async {
    var usersData = [];
    await bookCollection.doc(bookId).get().then((value) async {
      for (int i = 0; i < value.data()['owners'].length; i++) {
        String own = value.data()['owners'][i];
        await usersCollection.doc(own).get().then((value) {
          dynamic userData = value.data();
          dynamic userBook = userData['books'];
          for (int j = 0; j < userBook.length; j++) {
            if (userBook[j]['id'] == bookId) {
              userBook = userBook[j];
              break;
            }
          }
          userBook = userBook.length >= 1 ? userBook : null;

          usersData.add(
              {
                "uid": userData["uid"],
                "username": userData["username"],
                "email": userData["email"],
                "book": userBook,
              }
          );
        });
      }
    });

    return usersData;
  }

  Future<void> followUser(CustomUser followed) async {
    await usersCollection.doc(user.uid)
        .update({
      'usersFollowedByMe': FieldValue.arrayUnion([followed.uid]),
      'following': FieldValue.increment(1),
    });

    await usersCollection.doc(followed.uid)
        .update({
      'usersFollowingMe': FieldValue.arrayUnion([user.uid]),
      'followers': FieldValue.increment(1),
    });
  }

}