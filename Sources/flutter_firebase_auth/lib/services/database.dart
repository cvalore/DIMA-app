import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/storage.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class DatabaseService {

  final CustomUser user;
  //int idGeneralInfoToSearch;
  DatabaseService({ this.user });

  //region Init

  StorageService storageService = StorageService();

  final CollectionReference bookCollection = FirebaseFirestore.instance
      .collection('books');
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');
  final CollectionReference booksPerGenreCollection = FirebaseFirestore.instance
      .collection('booksPerGenre');
  final CollectionReference forumDiscussionCollection = FirebaseFirestore.instance
      .collection('forumDiscussion');
  final CollectionReference transactionsCollection = FirebaseFirestore.instance
      .collection('transactions');
  final CollectionReference chatsCollection = FirebaseFirestore.instance
      .collection('chats');

  //endregion

  //region Authentication

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

  Future checkUsernameAlreadyUsed(String username) async {
    bool exists = false;
    await usersCollection.where('username', isEqualTo: username).get().
        then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size > 0)
            exists = true;
    });
    return exists;
  }

  Future<bool> updateUserInfo(String imageProfilePath, bool oldImageRemoved, String fullName,
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
    } else if (oldImageRemoved) {
      await storageService.removeUserProfilePic(user.uid);
      updates['userProfileImageURL'] = '';
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

  //endregion

  //region Streams

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

  ForumDiscussion _discussion;
  Chat _chat;

  void setForumDiscussion(ForumDiscussion discussion) {
    this._discussion = discussion;
  }

  void setChat(Chat chat) {
    this._chat = chat;
  }

  Stream<ForumDiscussion> get discussionInfo {
    Stream<ForumDiscussion> result = forumDiscussionCollection
        .doc(_discussion.title)
        .snapshots()
        .map(_forumDiscussionFromSnapshot);
    return result;
  }

  Stream<Chat> get chatInfo {
    Stream<Chat> result = chatsCollection
        .doc(_chat.chatKey)
        .snapshots()
        .map(_chatFromSnapshot);
    return result;
  }

  ForumDiscussion _forumDiscussionFromSnapshot(DocumentSnapshot documentSnapshot) {
    dynamic result = documentSnapshot.data();
    List<Message> messages = List<Message>();
    for(int i = 0; i < result['messages'].length; i++) {
      messages.add(Message.fromDynamicToMessage(result['messages'][i]));
    };
    return ForumDiscussion.FromDynamicToForumDiscussion(result, messages);
  }

  Chat _chatFromSnapshot(DocumentSnapshot documentSnapshot) {
    dynamic result = documentSnapshot.data();
    List<Message> messages = List<Message>();
    for(int i = 0; i < result['messages'].length; i++) {
      messages.add(Message.fromDynamicToMessage(result['messages'][i]));
    };
    return Chat.FromDynamicToChat(result, messages);
  }

  //endregion

  //region Books

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
    mapBook['exchangeStatus'] = mapBook['exchangeable'] == true ? 'available' : 'notAvailable';
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

    //int numberOfInsertedItems;

    await storageService.removeBookPicture(
        user.uid, book.title, book.insertionNumber);

    /*await usersCollection.doc(user.uid).get().then(
            (userDoc) {
          numberOfInsertedItems = userDoc.data()['numberOfInsertedItems'];
        });*/

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
            book.insertionNumber,
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
    //book.setInsertionNumber(numberOfInsertedItems);

    books[index]["insertionNumber"] = book.insertionNumber;
    books[index]["comment"] = book.comment;
    books[index]["status"] = book.status;
    books[index]["category"] = book.category;
    books[index]["price"] = book.price;
    books[index]["imagesUrl"] = book.imagesUrl;

    if (book.exchangeStatus == 'pending'){
      //if the status of the book is pending the user cannot change its mode to not exchangeable
      book.exchangeable = true;
      books[index]["exchangeable"] = true;
      books[index]["exchangeStatus"] = book.exchangeStatus;
    } else {
      books[index]["exchangeable"] = book.exchangeable;
      books[index]["exchangeStatus"] = book.exchangeable == true ? 'available' : 'notAvailable';
    }

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
    List<String> followedByMe = List<String>();
    List<String> followingMe = List<String>();
    List<ReceivedReview> receivedReviews = List<ReceivedReview>();
    List<ReviewWrittenByMe> reviewsWrittenByMe = List<ReviewWrittenByMe>();
    double averageRating;


    if (documentSnapshot.exists) {
      userMap = documentSnapshot.data();
      for (int i = 0; i < userMap['usersFollowedByMe'].length; i++) {
        followedByMe.add(userMap['usersFollowedByMe'][i] as String);
      }
      for (int i = 0; i < userMap['usersFollowingMe'].length; i++) {
        followingMe.add(userMap['usersFollowingMe'][i] as String);
      }
      for (int i = 0; i < userMap['receivedReviews'].length; i++) {
        receivedReviews.add(ReceivedReview(
            key: userMap['receivedReviews'][i]['key'],
            stars: userMap['receivedReviews'][i]['stars'],
            review: userMap['receivedReviews'][i]['review'],
            reviewerUid: userMap['receivedReviews'][i]['reviewer'],
            time: DateTime.parse(userMap['receivedReviews'][i]['time'])
        ));
      }
      for (int i = 0; i < userMap['reviewsWrittenByMe'].length; i++) {
        reviewsWrittenByMe.add(ReviewWrittenByMe(
            key: userMap['reviewsWrittenByMe'][i]['key'],
            stars: userMap['reviewsWrittenByMe'][i]['stars'],
            review: userMap['reviewsWrittenByMe'][i]['review'],
            reviewedUid: userMap['reviewsWrittenByMe'][i]['reviewed'],
            time: DateTime.parse(userMap['reviewsWrittenByMe'][i]['time'])
        ));
      }

      averageRating = Utils.computeAverageRatingFromReviews(receivedReviews);

      user = CustomUser(
        userMap['uid'],
        email: userMap['email'],
        isAnonymous: userMap['isAnonymous'],
        username: userMap['username'],
        fullName: userMap['fullName'],
        birthday: userMap['birthday'],
        bio: userMap['bio'],
        city: userMap['city'],
        usersFollowedByMe: followedByMe,
        usersFollowingMe: followingMe,
        receivedReviews: receivedReviews,
        reviewsWrittenByMe: reviewsWrittenByMe,
        averageRating: averageRating,
        followers: userMap['followers'],
        following: userMap['following'],
        userProfileImageURL: userMap['userProfileImageURL'],
        numberOfInsertedItems: userMap['numberOfInsertedItems'],
      );

      if (user.uid == Utils.mySelf.uid)
        Utils.mySelf = user;
    }
    return user;
  }

  Future<BookPerGenreUserMap> getUserBooksPerGenreSnapshot() async {
    BookPerGenreUserMap result = await usersCollection.doc(user.uid)
        .snapshots()
        .map(_bookPerGenreUserListFromSnapshot)
        .elementAt(0);
    return result;
  }

  Future<CustomUser> getUserSnapshot() async {
    CustomUser result = await usersCollection.doc(user.uid).snapshots()
        .map(_userInfoFromSnapshot).elementAt(0);
    return result;
  }

  Future<CustomUser> getUserById(String uid) async {
    CustomUser result = await usersCollection.doc(uid).snapshots()
        .map(_userInfoFromSnapshot).elementAt(0);
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
            print('Other users have this book, just removing yours...');

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
      likedBy: List.from(book['likedBy']),
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
    await bookCollection.doc(bookId).get().then((valueBook) async {
      for (int i = 0; i < valueBook.data()['owners'].length; i++) {
        String thumbnail = valueBook.data()['thumbnail'];
        String own = valueBook.data()['owners'][i];
        await usersCollection.doc(own).get().then((valueUser) {
          dynamic userData = valueUser.data();
          dynamic userBook = userData['books'];
          dynamic bookResults = [];
          for (int j = 0; j < userBook.length; j++) {
            if (userBook[j]['id'] == bookId) {
              if (userBook[j]['likedBy'] == null) {
                userBook[j]['likedBy'] = List<String>();
              }
              bookResults.add(userBook[j]);
            }
          }

          for(int k = 0; k < bookResults.length; k++) {
            usersData.add(
                {
                  "uid": userData["uid"],
                  "username": userData["username"],
                  "userProfileImageURL": userData["userProfileImageURL"],
                  "email": userData["email"],
                  "book": bookResults[k],
                  "thumbnail" : thumbnail
                }
            );
          }
        });
      }
    });

    return usersData;
  }


  Future<dynamic> getMyFavoriteBooks() async {
    List<dynamic> likedBooks;
    List<dynamic> books = List<dynamic>();
    Map<String, dynamic> currentBook;
    await usersCollection.doc(user.uid).get().then((userDoc) async {
      likedBooks = userDoc.data()['booksILike'];
      for (int i = 0; i < likedBooks.length; i++) {
        await usersCollection.doc(likedBooks[i]['userUid']).get().then((userDoc) {
          List<dynamic> userBooks = userDoc.get('books');
          bool found = false;
          int bookIndex;
          for (int j = 0; j < userBooks.length && !found; j++){
            if (userBooks[j]['insertionNumber'] == likedBooks[i]['insertionNumber']){
              bookIndex = j;
              found = true;
            }
          }
          if(bookIndex != null) {
            currentBook = userBooks[bookIndex];
            currentBook['uid'] = likedBooks[i]['userUid'];
            books.add(currentBook);
          }
        });
      }
    });

    return books;
  }

  Future<List<dynamic>> getMyExchangeableBooks() async {
    List<dynamic> myBooks = List<dynamic>();
    List<dynamic> myExchangeableBooks = List<dynamic>();

    await usersCollection.doc(user.uid).get().then(
        (doc) {
          myBooks = doc.data()['books'];
          myExchangeableBooks = myBooks.where((element) => element['exchangeable'] == true && element['exchangeStatus'] == 'available').toList();
        }
    );


    return myExchangeableBooks;
  }


  Future<dynamic> getBookForSearch(String bookId) async {
    var usersData = [];
    await bookCollection.doc(bookId).get().then((valueBook) async {
      for (int i = 0; i < valueBook.data()['owners'].length; i++) {

        String own = valueBook.data()['owners'][i];
        await usersCollection.doc(own).get().then((valueUser) {
          dynamic userData = valueUser.data();
          dynamic userBook = userData['books'];
          dynamic bookResults = [];
          for (int j = 0; j < userBook.length; j++) {
            if (userBook[j]['id'] == bookId) {
              if (userBook[j]['likedBy'] == null) {
                userBook[j]['likedBy'] = List<String>();
              }
              bookResults.add(userBook[j]);
            }
          }

          for(int k = 0; k < bookResults.length; k++) {
            usersData.add(
                {
                  "uid": userData["uid"],
                  "username": userData["username"],
                  "userProfileImageURL": userData["userProfileImageURL"],
                  "email": userData["email"],
                  "book": bookResults[k],
                  "info": valueBook.data(),
                }
            );
          }

        });
      }
    });

    return usersData;
  }

  //endregion

  //region Profile/User

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

  Future<void> unFollowUser(CustomUser followed) async {
    await usersCollection.doc(user.uid)
        .update({
      'usersFollowedByMe': FieldValue.arrayRemove([followed.uid]),
      'following': FieldValue.increment(-1),
    });

    await usersCollection.doc(followed.uid)
        .update({
      'usersFollowingMe': FieldValue.arrayRemove([user.uid]),
      'followers': FieldValue.increment(-1),
    });
  }

  Future<void> addLike(int bookInsertionNumber, String thumbnail, String userWhoLikes) async {
    List<dynamic> books;
    List<dynamic> booksILike;
    Map<String, dynamic> bookLiked = Map<String, dynamic>();
    int bookToModifyIndex;
    await usersCollection.doc(user.uid).get().then(
            (userDoc) {
          books = userDoc.data()['books'];
        });

    for (int i = 0; i < books.length && bookToModifyIndex == null; i++) {
      if (books[i]['insertionNumber'] == bookInsertionNumber)
        bookToModifyIndex = i;
      print(bookToModifyIndex);
    }

    books[bookToModifyIndex]['likedBy'].add(userWhoLikes);
    await usersCollection.doc(user.uid).update({
      'books': books
    });

    //add book liked to my favorites
    bookLiked['userUid'] = user.uid;
    bookLiked['insertionNumber'] = bookInsertionNumber;
    bookLiked['thumbnail'] = thumbnail;

    await usersCollection.doc(Utils.mySelf.uid).update({
      'booksILike': FieldValue.arrayUnion([bookLiked]),
    });

  }

  Future<void> removeLike(int bookInsertionNumber, String userWhoDoesNotLike) async {
    List<dynamic> books;
    int bookToModifyIndex;
    Map<String, dynamic> bookNotLiked = Map<String, dynamic>();
    await usersCollection.doc(user.uid).get().then(
            (userDoc) {
          books = userDoc.data()['books'];
        });

    for (int i = 0; i < books.length && bookToModifyIndex == null; i++) {
      if (books[i]['insertionNumber'] == bookInsertionNumber)
        bookToModifyIndex = i;
    }

    books[bookToModifyIndex]['likedBy'].remove(userWhoDoesNotLike);
    await usersCollection.doc(user.uid).update({
      'books': books
    });


    //remove book from my favorites
    bookNotLiked['userUid'] = user.uid;
    bookNotLiked['insertionNumber'] = bookInsertionNumber;

    await usersCollection.doc(Utils.mySelf.uid).update({
      'booksILike': FieldValue.arrayRemove([bookNotLiked]),
    });

  }

  Future<void> addReview(ReceivedReview review) async {
    review.setKey();
    String reviewerUid = review.reviewerUid;
    ReviewWrittenByMe reviewWrittenByMe = review.toReviewWrittenByMe(user.uid);

    await usersCollection.doc(user.uid)
        .update({
      'receivedReviews': FieldValue.arrayUnion([review.toMap()]),
    });

    await usersCollection.doc(reviewerUid)
        .update({
      'reviewsWrittenByMe': FieldValue.arrayUnion([reviewWrittenByMe.toMap()]),
    });
  }

  Future<Map<String, Map<String, dynamic>>> getReviewsInfoByUid(List<String> usersUid) async {
    Map<String, Map<String, dynamic>> result =  Map<String, Map<String, dynamic>>();
    await usersCollection.where(
        'uid', whereIn: usersUid
    ).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> partialMap = Map<String, dynamic>();
        partialMap['username'] = doc.data()['username'];
        partialMap['userProfileImageURL'] = doc.data()['userProfileImageURL'];
        result[doc.data()['uid']] = partialMap;
      });
      }
    );
    return result;
  }

  removeReviews(List<ReviewWrittenByMe> reviewsToDelete) async {
    //List<Map<String, dynamic>> userReviews = List<Map<String, dynamic>>();
    List<dynamic> userReviews = List<dynamic>();
    List<int> reviewsToDeleteIndices = List<int>();
    // first remove reviews from the reviewer
    await usersCollection.doc(user.uid).get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        userReviews = doc.data()['reviewsWrittenByMe'];

        for (int i = 0; i < userReviews.length; i++){
          for (int j = 0; j < reviewsToDelete.length; j++){
            if (userReviews[i]['key'] == reviewsToDelete[j].key){
              reviewsToDeleteIndices.insert(0, i);
            }
          }
        }

        for(int i = 0; i < reviewsToDeleteIndices.length; i++)
          userReviews.removeAt(reviewsToDeleteIndices[i]);
        print(userReviews);
        usersCollection.doc(user.uid).update({
          'reviewsWrittenByMe': userReviews
        });
      }
    });

    List<String> reviewedUsersUids = reviewsToDelete.map((e) => e.reviewedUid).toList();

    //then remove from the collection of reviewed users
    await usersCollection.where('uid', whereIn: reviewedUsersUids).get().then(
        (QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((element) {
            List<dynamic> receivedReviews = List<dynamic>();
            reviewsToDeleteIndices = List<int>();
            receivedReviews = element.data()['receivedReviews'];

            for (int i = 0; i < receivedReviews.length; i++){
              for (int j = 0; j < reviewsToDelete.length; j++){
                if (receivedReviews[i]['key'] == reviewsToDelete[j].key){
                  reviewsToDeleteIndices.insert(0, i);
                }
              }
            }
            for(int i = 0; i < reviewsToDeleteIndices.length; i++)
              receivedReviews.removeAt(reviewsToDeleteIndices[i]);
            usersCollection.doc(element['uid']).update({
              'receivedReviews': receivedReviews
            });
          });
        }
    );
  }

  Future<dynamic> getAllUsers() async {
    QuerySnapshot snapshot = await usersCollection.get();
    dynamic allUsers = [];
    for(QueryDocumentSnapshot doc in snapshot.docs) {
      allUsers.add(doc.data());
    }
    return allUsers;
  }

  //endregion

  //region Forum

  Future<dynamic> getForumDiscussions() async {
    QuerySnapshot snapshot = await forumDiscussionCollection.get();
    dynamic allDiscussions = [];
    for(QueryDocumentSnapshot doc in snapshot.docs) {
      allDiscussions.add(doc.data());
    }
    return allDiscussions;
  }

  Future<dynamic> createNewDiscussion(String category, String title) async {
    dynamic result = null;

    await forumDiscussionCollection.doc(title).get().then((DocumentSnapshot doc) async {
      if (!doc.exists) {
        ForumDiscussion newDiscussion = ForumDiscussion(
          title, category, List<Message>(), DateTime.now(), user.uid
        );
        newDiscussion.setKey();
        await forumDiscussionCollection.doc(title).set(newDiscussion.toMap())
            .then((value) {result = newDiscussion.toMap(); print("Discussion Added");})
            .catchError((error) {print("Failed to add discussion: $error");});
      }
    });

    return result;
  }

  Future<List<Message>> addMessageToForum(String message, ForumDiscussion discussion, CustomUser userFromDb) async {
    dynamic currentMessages;
    await forumDiscussionCollection.doc(discussion.title).get().then((DocumentSnapshot doc) async {
      if (doc.exists) {
        currentMessages = doc.get("messages");
      }
    });

    Message newMessage = Message  (
        userFromDb.uid, userFromDb.username ?? "", DateTime.now(), message
    );
    newMessage.setKey();
    currentMessages.add(newMessage.toMap());
    await forumDiscussionCollection.doc(discussion.title).update(
      {"messages" : currentMessages}
    );

    List<Message> messages = List<Message>();
    currentMessages.forEach((element) => messages.add(
      Message.fromDynamicToMessage(element)
    ));
    return messages;
  }

  //endregion

  //region Purchase
  Future<void> purchaseAndProposeExchange(String sellingUser, chosenShippingMode, shippingAddress, payCash, List<InsertedBook> booksToPurchase, Map<InsertedBook, Map<String, dynamic>> booksToExchange) async {

    bool transactionSuccessfullyCompleted = false;
    Map<String, dynamic> transaction = Map<String, dynamic>();
    List<Map<String, dynamic>> booksToPurchaseMap = List<Map<String, dynamic>>();
    Map<String, dynamic> bookMap;
    String toEncode = '${user.uid}$sellingUser${DateTime.now().toString()}';
    String transactionId = Utils.encodeBase64(toEncode);
    for (int i = 0; i < booksToPurchase.length; i++){
      bookMap = Map<String, dynamic>();
      bookMap['id'] = booksToPurchase[i].id;
      bookMap['title'] = booksToPurchase[i].title;
      bookMap['author'] = booksToPurchase[i].author;
      bookMap['imagesUrl'] = booksToPurchase[i].imagesUrl;
      bookMap['status'] = booksToPurchase[i].status;
      bookMap['price'] = booksToPurchase[i].price;
      booksToPurchaseMap.add(bookMap);
    }
    transaction['id'] = transactionId;
    transaction['paidBooks'] = booksToPurchaseMap;
    transaction['buyer'] = user.uid;
    transaction['seller'] = sellingUser;
    transaction['chosenShippingMode'] = chosenShippingMode;
    transaction['shippingAddress'] = shippingAddress;
    transaction['payCash'] = payCash;

    transaction['exchanges'] = Utils.exchangedBookFromMap(booksToExchange);

    DocumentReference buyerUserReference = usersCollection.doc(user.uid);
    DocumentReference sellerUserReference = usersCollection.doc(sellingUser);
    List<dynamic> buyerBooks;
    List<dynamic> sellerBooks;
    List<int> booksToRemove = List<int>();
    List<int> exchangingBooks = List<int>();
    List<int> buyerExchangingBooks = List<int>();
    List<InsertedBook> booksToExchangeKeys = List<InsertedBook>();
    List<String> booksToRemoveId;
    List<bool> sellerHasDuplicate;

    await FirebaseFirestore.instance.runTransaction((transactionOnDb) async {

      // check on the seller's books exchanged
      DocumentSnapshot sellerUserSnapshot = await transactionOnDb.get(sellerUserReference);
      if (!sellerUserSnapshot.exists) {
        throw Exception("User does not exist!");
      }
      sellerBooks = sellerUserSnapshot.data()['books'];
      booksToExchangeKeys = booksToExchange.keys.toList();
      for (int i = 0; i < sellerBooks.length; i++){
        for (int j = 0; j < booksToPurchase.length; j++) {
          if (sellerBooks[i]['insertionNumber'] ==
              booksToPurchase[j].insertionNumber) {
            booksToRemove.add(i);
          }
        }
        print(booksToExchange);
        for (int j = 0; j < booksToExchange.length; j++){
          print('Quaaaaa');
          print(booksToExchangeKeys[j]);
          //if (sellerBooks[i]['insertionNumber'] == booksToExchange[booksToExchangeKeys[j]]['insertionNumber']){
          if (sellerBooks[i]['insertionNumber'] == booksToExchangeKeys[j].insertionNumber){
            print('ma qua');
            exchangingBooks.add(i);
            print('e qua');
            if (sellerBooks[i]['exchangeStatus'] != 'available')
              throw Exception("Some books you want to exchange are no more available");
          }
        }
      }
      print(booksToRemove.length);
      print(booksToPurchase.length);
      print(exchangingBooks.length);
      print(booksToExchange.length);
      if (booksToRemove.length != booksToPurchase.length || exchangingBooks.length != booksToExchange.length)
        throw Exception("A problem occurred with books you want to buy. They might have been already sold or the user might have deleted it");

      // check on the buyer's books exchanged
      // still to check this if
      if (booksToExchange != null && booksToExchange.length > 0) {
        DocumentSnapshot buyerSnapshot = await transactionOnDb.get(
            buyerUserReference);
        if (!buyerSnapshot.exists) {
          throw Exception("User does not exist!");
        }
        buyerBooks = buyerSnapshot.data()['books'];
        for (int i = 0; i < buyerBooks.length; i++){
          for (int j = 0; j < booksToExchange.length; j++){
            if (buyerBooks[i]['insertionNumber'] == booksToExchange[booksToExchangeKeys[j]]['insertionNumber']){
              buyerExchangingBooks.add(i);
              if (buyerBooks[i]['exchangeStatus'] != 'available')
                throw Exception("Not all the books you selected for exchange are available");
            }
          }
        }
        if (buyerExchangingBooks.length != booksToExchange.length)
          throw Exception("A problem occurred with books you selected for exchange");
      }

      //remove books from seller user document
      booksToRemoveId = List<String>();
      for (int i = 0; i < exchangingBooks.length; i++)
        sellerBooks[exchangingBooks[i]]['exchangeStatus'] = 'pending';
      for (int i = booksToRemove.length - 1; i > -1; i--){
        var removedBook = sellerBooks.removeAt(booksToRemove[i]);
        booksToRemoveId.add(removedBook['id']);
      }
      for (int i = buyerExchangingBooks.length - 1; i > -1; i--)
        buyerBooks[buyerExchangingBooks[i]]['exchangeStatus'] = 'pending';


      //check if selling user had duplicates of the sold books
      Set<String> booksToRemoveIdSet = booksToRemoveId.toSet();
      List<String> booksToRemoveIdNoDuplicates = booksToRemoveIdSet.toList();

      Map<String, int> booksCountById = Map<String, int>();
      Map<String, int> booksHaveImagesById = Map<String, int>();
      Map<String, int> booksAreExchangeableById = Map<String, int>();

      for (int i = 0; i < booksToRemoveIdNoDuplicates.length; i++) {
        booksCountById[booksToRemoveIdNoDuplicates[i]] = 0;
        booksHaveImagesById[booksToRemoveIdNoDuplicates[i]] = 0;
        booksAreExchangeableById[booksToRemoveIdNoDuplicates[i]] = 0;
      }
      for (int i = 0; i < booksToRemoveId.length; i++)
        booksCountById[booksToRemoveId[i]]++;

      for (int i = 0; i < booksToRemoveIdNoDuplicates.length; i++) {
        for (int j = 0; j < booksToPurchase.length; j++) {
          if (booksToPurchase[j].id == booksToRemoveIdNoDuplicates[i]) {
            if (booksToPurchase[j].exchangeable)
              booksAreExchangeableById[booksToRemoveIdNoDuplicates[i]]++;
            if (booksToPurchase[j].imagesUrl != null &&
                booksToPurchase[j].imagesUrl.length > 0)
              booksHaveImagesById[booksToRemoveIdNoDuplicates[i]]++;
          }
        }
      }

      sellerHasDuplicate = List.filled(booksToRemoveIdNoDuplicates.length, false);
      for (int i = 0; i < booksToRemoveIdNoDuplicates.length; i++) {
        for (int j = 0; j < sellerBooks.length; j++) {
          if (sellerBooks[j]['id'] == booksToRemoveIdNoDuplicates[i]) {
            sellerHasDuplicate[j] = true;
          }
        }
      }

      Map<String, dynamic> booksFromBooksCollectionToModify = Map<String, dynamic>();
      List<String> booksFromBooksCollectionToDelete = List<String>();
      Map<String, List<String>> booksToRemoveFromBooksPerGenres = Map<String, List<String>>();

      for (int i = 0; i < booksToRemoveIdNoDuplicates.length; i++){
        DocumentReference bookRef = bookCollection.doc(booksToRemoveIdNoDuplicates[i]);
        DocumentSnapshot bookSnap = await transactionOnDb.get(bookRef);
        dynamic bookData = bookSnap.data();

        bookData['availableNum'] = bookData['availableNum'] - booksCountById[booksToRemoveIdNoDuplicates[i]];
        bookData['exchangeable'] = bookData['exchangeable'] - booksAreExchangeableById[booksToRemoveIdNoDuplicates[i]];
        bookData['haveImages'] = bookData['haveImages'] - booksHaveImagesById[booksToRemoveIdNoDuplicates[i]];
        if (!sellerHasDuplicate[i]) {
          List<String> owners = List.from(bookData['owners']);
          owners.remove(sellingUser);
          bookData['owners'] = owners;
        }

        if (bookData['availableNum'] == 0) {
          booksFromBooksCollectionToDelete.add(booksToRemoveIdNoDuplicates[i]);
          String category;
          for (int i = 0; i < booksToPurchase.length; i++){
            if (bookData['id'] == booksToPurchase[i].id) {
              category = booksToPurchase[i].category;
              break;
            }
          }
          if (booksToRemoveFromBooksPerGenres[category] == null)
            booksToRemoveFromBooksPerGenres[category] = [bookData['id']];
          else {
            List<String> books = booksToRemoveFromBooksPerGenres[category];
            books.add(bookData['id']);
            booksToRemoveFromBooksPerGenres[category] = books;
          }
        }
        else {
          booksFromBooksCollectionToModify[booksToRemoveIdNoDuplicates[i]] = bookData;
        }
      }

      Map<String, dynamic> booksFromBooksPerGenresCollection = Map<String, dynamic>();
      List<String> genres = booksToRemoveFromBooksPerGenres.keys.toList();
      for(int i = 0; i < booksToRemoveFromBooksPerGenres.length; i++){
        DocumentReference documentReference = booksPerGenreCollection.doc(genres[i]);
        DocumentSnapshot booksPerGenreSnap = await transactionOnDb.get(documentReference);
        List<dynamic> booksPerGenre = booksPerGenreSnap.data()['books'];
        List<int> booksToRemoveIndexes = List<int>();
        for (int j = 0; j < booksPerGenre.length; j++){
          for (int k = 0; k < booksToRemoveFromBooksPerGenres[genres[i]].length; k++){
            if (booksPerGenre[j][booksToRemoveFromBooksPerGenres[genres[i]][k]] != null)
              booksToRemoveIndexes.add(j);
          }
        }
        for (int i = booksToRemoveIndexes.length - 1; i > -1; i--)
          booksPerGenre.removeAt(booksToRemoveIndexes[i]);

        booksFromBooksPerGenresCollection[genres[i]] = booksPerGenre;
      }

      //TODO the following still to be tested

      for (int i = 0; i < booksFromBooksCollectionToDelete.length; i++){
        print(booksFromBooksCollectionToDelete[i]);
        print('cancellato');
      }

      for (int i = 0; i < booksToRemoveIdNoDuplicates.length; i++){
        if (booksFromBooksCollectionToModify[booksToRemoveIdNoDuplicates[i]] != null){
          print(booksFromBooksCollectionToModify[booksToRemoveIdNoDuplicates[i]]);
        } else {
          print('else quindi cancellato');
        }
      }

      /*
      if (booksToRemoveFromBooksPerGenres.length > 0) {
        for (int i = 0; i < genres.length; i++){
          print(booksFromBooksPerGenresCollection[genres[i]][0]);
        }
      }

       */

      if (booksToExchange != null && booksToExchange.length > 0) {
        print(buyerBooks);
      }
      print(sellerBooks);

      print('Step 1');
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (int i = 0; i < booksFromBooksCollectionToDelete.length; i++){
        DocumentReference documentReference = bookCollection.doc(booksFromBooksCollectionToDelete[i]);
        batch.delete(documentReference);
      }
      print('Step 2');


      for (int i = 0; i < booksToRemoveIdNoDuplicates.length; i++){
        if (booksFromBooksCollectionToModify[booksToRemoveIdNoDuplicates[i]] != null){
          DocumentReference documentReference = bookCollection.doc(booksToRemoveIdNoDuplicates[i]);
          batch.update(documentReference, booksFromBooksCollectionToModify[booksToRemoveIdNoDuplicates[i]]);
        }
      }

      print('Step 4');
      if (booksToRemoveFromBooksPerGenres.length > 0) {
        for (int i = 0; i < genres.length; i++){
          DocumentReference documentReference = booksPerGenreCollection.doc(genres[i]);
          batch.update(documentReference, {'books': booksFromBooksPerGenresCollection[genres[i]]});
        }
      }

      print('Step 5');
      if (booksToExchange != null && booksToExchange.length > 0) {
        batch.update(buyerUserReference, {'books': buyerBooks});
      }

      print('Step 6');
      batch.update(sellerUserReference, {'books': sellerBooks});
      batch.commit();
    }).then((value) {print("transaction ended successfully"); transactionSuccessfullyCompleted = true;})
      .catchError((error) => print("The following error occurred: $error")); //TODO fare return dell'errore e stampare a schermo


    if (transactionSuccessfullyCompleted) {
      print('Step 7');
      await transactionsCollection.doc(transaction['id']).set(transaction)
          .catchError((error) => print("Failed to add transaction: $error"));

      print('Step 8');
      await usersCollection.doc(transaction['seller']).update({
        'transactionsAsSeller': FieldValue.arrayUnion([transaction['id']]),
      }).then((value) => print("transaction added for seller"))
          .catchError((error) =>
          print("Failed to add transaction for seller: $error"));

      print('Step 9');
      await usersCollection.doc(user.uid).update({
        'transactionsAsBuyer': FieldValue.arrayUnion([transaction['id']]),
      }).then((value) => print("transaction added for buyer"))
          .catchError((error) =>
          print("Failed to add transaction for buyer: $error"));
      print('Step 10');
    }
  }
  //endregion

  //region Chat

  Future<dynamic> getMyChats() async {
    dynamic result = [];
    dynamic chatKeys = [];
    await usersCollection.doc(user.uid).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        if(doc.data()['chats'] != null) {
          chatKeys.addAll(doc.data()['chats']);
        }
      }
    });

    for(int i = 0; i < chatKeys.length; i++) {
      await chatsCollection.doc(chatKeys[i]).get().then((DocumentSnapshot doc) {
        if(doc.exists) {
          result.add(doc.data());
        }
      });
    }
    return result;
  }

  Future<dynamic> createNewChat(String userUid1, String userUid2, String otherUsername) async {
    dynamic result = null;

    String keyPart1 = userUid1.compareTo(userUid2) > 0 ? userUid1 : userUid2;
    String keyPart2 = userUid1.compareTo(userUid2) > 0 ? userUid2 : userUid1;
    DateTime time = DateTime.now();
    String chatKey = Utils.encodeBase64(keyPart1 + "_" + keyPart2);

    await chatsCollection.doc(chatKey).get().then((DocumentSnapshot doc) async {
      if (!doc.exists) {
        Chat newChat = Chat(
            userUid1, userUid2, otherUsername, List<Message>(), time
        );
        newChat.user1Read = true;
        newChat.setKnownKey(chatKey);
        await chatsCollection.doc(chatKey).set(newChat.toMap())
            .then((value) {result = newChat.toMap(); print("Chat Added");})
            .catchError((error) {print("Failed to add chat: $error");});
      }
      else {
        result = doc.data();
      }
    });

    await usersCollection
        .where('uid', isEqualTo: userUid1)
        .get()
        .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.size == 1) {
            usersCollection.doc(querySnapshot.docs[0].id)
                .update({
              'chats': FieldValue.arrayUnion([chatKey]),
            });
          }
    });

    await usersCollection
        .where('uid', isEqualTo: userUid2)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size == 1) {
        usersCollection.doc(querySnapshot.docs[0].id)
            .update({
          'chats': FieldValue.arrayUnion([chatKey]),
        });
      }
    });

    return result;
  }

  Future<List<Message>> addMessageToChat(String message, Chat chat, CustomUser userFromDb) async {
    dynamic currentMessages;
    await chatsCollection.doc(chat.chatKey).get().then((DocumentSnapshot doc) async {
      if (doc.exists) {
        currentMessages = doc.get("messages");
      }
    });

    Message newMessage = Message  (
        userFromDb.uid, userFromDb.username ?? "", DateTime.now(), message
    );
    newMessage.setKey();
    currentMessages.add(newMessage.toMap());
    await chatsCollection.doc(chat.chatKey).update(
        {"messages" : currentMessages}
    );

    List<Message> messages = List<Message>();
    currentMessages.forEach((element) => messages.add(
        Message.fromDynamicToMessage(element)
    ));
    return messages;
  }


  //endregion

}