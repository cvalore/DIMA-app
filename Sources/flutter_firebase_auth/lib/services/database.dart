
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
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

  Stream<List<MyTransaction>> get transactionsInfo {
    Stream<List<MyTransaction>> result = usersCollection
        .doc(user.uid)
        .snapshots()
        .map(_transactionFromSnapshot);
    return result;
  }

  Stream<List<MyTransaction>> get allTransactionsInfo {
    Stream<List<MyTransaction>> result = usersCollection
        .doc(user.uid)
        .snapshots()
        .map(_allTransactionFromSnapshot);
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

  List<MyTransaction> _transactionFromSnapshot(DocumentSnapshot documentSnapshot) {
    dynamic transactions = documentSnapshot.data()['transactionsAsSeller'] ?? [];
    List<MyTransaction> result = List<MyTransaction>();
    transactions.forEach((tr) {
      if(_chat.userUid1.compareTo(tr['buyer']) == 0 || _chat.userUid2.compareTo(tr['buyer']) == 0) {
        result.add(MyTransaction(tr['transactionId'], tr['buyer']));
      }
    });
    return result;
  }

  List<MyTransaction> _allTransactionFromSnapshot(DocumentSnapshot documentSnapshot) {
    dynamic transactions = documentSnapshot.data()['transactionsAsSeller'] ?? [];
    List<MyTransaction> result = List<MyTransaction>();
    transactions.forEach((tr) {
        result.add(MyTransaction(tr['transactionId'], tr['buyer']));
    });
    return result;
  }

  //endregion

  //region Books

  Future addUserBook(InsertedBook book) async {
    int numberOfInsertedItems;
    var generalInfoBookMap = book.generalInfoToMap();

    DocumentReference buyerUserReference = usersCollection.doc(user.uid);
    DocumentReference bookReference = bookCollection.doc(generalInfoBookMap['id']);
    //DocumentReference sellerUserReference = usersCollection.doc(sellingUser);

    bool runningTransaction = false;

    await FirebaseFirestore.instance.runTransaction((transactionOnDb) async {
      if(!runningTransaction) {
        runningTransaction = true;
        print("Calling add book transaction");
        WriteBatch batch = FirebaseFirestore.instance.batch();
        DocumentSnapshot documentSnapshot = await transactionOnDb.get(
            buyerUserReference);
        numberOfInsertedItems =
        documentSnapshot.data()['numberOfInsertedItems'];

        DocumentSnapshot bookSnapshot = await transactionOnDb.get(
            bookReference);
        if (bookSnapshot.exists) {
          if (book.exchangeable && book.imagesPath != null &&
              book.imagesPath.length != 0) {
            batch.update(bookReference, {
              'owners': FieldValue.arrayUnion([user.uid]),
              'availableNum': FieldValue.increment(1),
              'exchangeable': FieldValue.increment(1),
              'haveImages': FieldValue.increment(1),
            });
          } else if (book.exchangeable) {
            batch.update(bookReference, {
              'owners': FieldValue.arrayUnion([user.uid]),
              'availableNum': FieldValue.increment(1),
              'exchangeable': FieldValue.increment(1),
            });
          } else if (book.imagesPath != null && book.imagesPath.length != 0) {
            batch.update(bookReference, {
              'owners': FieldValue.arrayUnion([user.uid]),
              'availableNum': FieldValue.increment(1),
              'haveImages': FieldValue.increment(1),
            });
          } else {
            batch.update(bookReference, {
              'owners': FieldValue.arrayUnion([user.uid]),
              'availableNum': FieldValue.increment(1),
            });
          }
          print("Book already present, add you as owner too");
        } else {
          generalInfoBookMap['owners'] = [user.uid];
          batch.set(bookReference, generalInfoBookMap);
        }

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
        mapBook['exchangeStatus'] =
        mapBook['exchangeable'] == true ? 'available' : 'notAvailable';
        // add book to the user collection
        batch.update(buyerUserReference, {
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

        DocumentReference booksPerGenre = booksPerGenreCollection.doc(
            book.category);
        DocumentSnapshot documentSnapshotBooks = await transactionOnDb.get(
            booksPerGenre);
        if (!documentSnapshotBooks.exists) {
          batch.set(booksPerGenre, {
            "books": FieldValue.arrayUnion([bookPerGenreMap]),
          });
        } else {
          batch.update(booksPerGenre, {
            "books": FieldValue.arrayUnion([bookPerGenreMap]),
          });
        }

        batch.commit();
      }
    });
    runningTransaction = false;
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

    DocumentReference userBooksReference = usersCollection.doc(user.uid);

    bool runningTransaction = false;

    await FirebaseFirestore.instance.runTransaction((transactionOnDb) async {
      if(!runningTransaction) {
        runningTransaction = true;
        WriteBatch batch = FirebaseFirestore.instance.batch();
        DocumentSnapshot bookSnap = await transactionOnDb.get(
            userBooksReference);
        books = bookSnap.data()['books'];
        DocumentReference bookReference = bookCollection.doc(books[index]['id']);

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

        books[index]["insertionNumber"] = book.insertionNumber;
        books[index]["comment"] = book.comment;
        books[index]["status"] = book.status;
        books[index]["category"] = book.category;
        books[index]["price"] = book.price;
        books[index]["imagesUrl"] = book.imagesUrl;

        if (book.exchangeStatus == 'pending') {
          //if the status of the book is pending the user cannot change its mode to not exchangeable
          book.exchangeable = true;
          books[index]["exchangeable"] = true;
          books[index]["exchangeStatus"] = book.exchangeStatus;
        } else {
          books[index]["exchangeable"] = book.exchangeable;
          books[index]["exchangeStatus"] =
          book.exchangeable == true ? 'available' : 'notAvailable';
        }

        batch.update(userBooksReference, {
          'books': books
        });


        DocumentSnapshot documentSnapshot = await transactionOnDb.get(
            bookReference);
        if (documentSnapshot.exists) {
          if (wasExchangeable && hadImages) {
            if (!book.exchangeable &&
                !(book.imagesUrl != null && book.imagesUrl.length != 0)) {
              batch.update(bookReference, {
                'exchangeable': FieldValue.increment(-1),
                'haveImages': FieldValue.increment(-1),
              });
            }
            else if (!book.exchangeable) {
              batch.update(bookReference, {
                'exchangeable': FieldValue.increment(-1),
              });
            }
            else if (!(book.imagesUrl != null && book.imagesUrl.length != 0)) {
              batch.update(bookReference, {
                'haveImages': FieldValue.increment(-1),
              });
            }
          }
          else if (wasExchangeable) {
            if (!book.exchangeable && book.imagesUrl != null &&
                book.imagesUrl.length != 0) {
              batch.update(bookReference, {
                'exchangeable': FieldValue.increment(-1),
                'haveImages': FieldValue.increment(1),
              });
            }
            else if (!book.exchangeable) {
              batch.update(bookReference, {
                'exchangeable': FieldValue.increment(-1),
              });
            }
            else if (book.imagesUrl != null && book.imagesUrl.length != 0) {
              batch.update(bookReference, {
                'haveImages': FieldValue.increment(1),
              });
            }
          }
          else if (hadImages) {
            if (book.exchangeable &&
                !(book.imagesUrl != null && book.imagesUrl.length != 0)) {
              batch.update(bookReference, {
                'exchangeable': FieldValue.increment(1),
                'haveImages': FieldValue.increment(-1),
              });
            }
            else if (book.exchangeable) {
              batch.update(bookReference, {
                'exchangeable': FieldValue.increment(1),
              });
            }
            else if (!(book.imagesUrl != null && book.imagesUrl.length != 0)) {
              batch.update(bookReference, {
                'haveImages': FieldValue.increment(-1),
              });
            }
          }
          else {
            if (book.exchangeable && book.imagesUrl != null &&
                book.imagesUrl.length != 0) {
              batch.update(bookReference, {
                'exchangeable': FieldValue.increment(1),
                'haveImages': FieldValue.increment(1),
              });
            }
            else if (book.exchangeable) {
              batch.update(bookReference, {
                'exchangeable': FieldValue.increment(1),
              });
            }
            else if (book.imagesUrl != null && book.imagesUrl.length != 0) {
              batch.update(bookReference, {
                'haveImages': FieldValue.increment(1),
              });
            }
          }
        }


        batch.commit();
      }
    });
    runningTransaction = false;
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

    bool runningTransaction = false;

    DocumentReference userReference = usersCollection.doc(user.uid);
    await FirebaseFirestore.instance.runTransaction((transactionOnDb) async {
      if(!runningTransaction) {
        runningTransaction = true;
        WriteBatch batch = FirebaseFirestore.instance.batch();
        DocumentSnapshot documentSnapshot = await transactionOnDb.get(
            userReference);
        List<dynamic> books = documentSnapshot.data()['books'];
        id = books[index]['id'];
        books.removeAt(index);

        for (int i = 0; i < books.length && !duplicatePresent; i++) {
          if (books[i]['id'] == id)
            duplicatePresent = true;
        }

        batch.update(userReference, {
          'books': books
        });

        DocumentReference bookReference = bookCollection.doc(id);
        DocumentSnapshot docSnap = await transactionOnDb.get(bookReference);
        if (docSnap.exists) {
          thumbnail = docSnap.data().containsKey("thumbnail") ?
          docSnap.data()['thumbnail'] : null;
        }
        availableNum = docSnap.data()['availableNum'];

        if (availableNum == 1) {
          //remove all the document
          print('No other user has this book, removing all...');
          batch.delete(bookReference);
          bookDocumentRemoved = true;
        } else if (!duplicatePresent) {
          //remove only the current user
          print('Other users have this book, just removing yours...');
          if (book.exchangeable && book.imagesUrl != null &&
              book.imagesUrl.length != 0) {
            batch.update(bookReference, {
              'owners': FieldValue.arrayRemove([user.uid]),
              'availableNum': FieldValue.increment(-1),
              'exchangeable': FieldValue.increment(-1),
              'haveImages': FieldValue.increment(-1),
            });
          }
          else if (book.exchangeable) {
            batch.update(bookReference, {
              'owners': FieldValue.arrayRemove([user.uid]),
              'availableNum': FieldValue.increment(-1),
              'exchangeable': FieldValue.increment(-1),
            });
          }
          else if (book.imagesUrl != null && book.imagesUrl.length != 0) {
            batch.update(bookReference, {
              'owners': FieldValue.arrayRemove([user.uid]),
              'availableNum': FieldValue.increment(-1),
              'haveImages': FieldValue.increment(-1),
            });
          }
          else {
            batch.update(bookReference, {
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
            batch.update(bookReference, {
              'availableNum': FieldValue.increment(-1),
              'exchangeable': FieldValue.increment(-1),
              'haveImages': FieldValue.increment(-1),
            });
          }
          else if (book.exchangeable) {
            batch.update(bookReference, {
              'availableNum': FieldValue.increment(-1),
              'exchangeable': FieldValue.increment(-1),
            });
          }
          else if (book.imagesUrl != null && book.imagesUrl.length != 0) {
            batch.update(bookReference, {
              'availableNum': FieldValue.increment(-1),
              'haveImages': FieldValue.increment(-1),
            });
          }
          else {
            batch.update(bookReference, {
              'availableNum': FieldValue.increment(-1),
            });
          }
        }

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

          DocumentReference booksPerGenreReference = booksPerGenreCollection
              .doc(book.category);

          batch.update(booksPerGenreReference, {
            'books': FieldValue.arrayRemove([bookToRemoveMap]),
          });
        }

        batch.commit();
      }
    });
    runningTransaction = false;
    //remove pictures from the storage
    await storageService.removeBookPicture(
        user.uid, book.title, book.insertionNumber);

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
      exchangeStatus: book['exchangeStatus']
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

  Future<dynamic> viewBookByIdAndInsertionNumber(String bookId, int bookInsertionNumber, String userUid) async {
    var usersData = [];
    await bookCollection.doc(bookId).get().then((valueBook) async {
      for (int i = 0; i < valueBook.data()['owners'].length; i++) {
        if(valueBook.data()['owners'][i].compareTo(userUid) != 0)
          continue;
        String thumbnail = valueBook.data()['thumbnail'];
        String own = valueBook.data()['owners'][i];
        await usersCollection.doc(own).get().then((valueUser) {
          dynamic userData = valueUser.data();
          dynamic userBook = userData['books'];
          dynamic bookResults = [];
          for (int j = 0; j < userBook.length; j++) {
            if (userBook[j]['id'] == bookId && userBook[j]['insertionNumber'] == bookInsertionNumber) {
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

  Future<dynamic> getMyOrders() async {
    List<String> transactionsAsBuyer;
    List<dynamic> myPurchasedBooks = List<dynamic>();
    List<dynamic> myPendingExchanges = List<dynamic>();
    List<dynamic> myCompletedExchanges = List<dynamic>();
    Map<String, dynamic> transactionBody;
    List<dynamic> currentExchanges;
    List<dynamic> currentPaidBooks;
    await usersCollection.doc(user.uid).get().then((userDoc) async {
      transactionsAsBuyer = List.from(userDoc.data()['transactionsAsBuyer']);
      for (int i = 0; i < transactionsAsBuyer.length; i++) {
        await transactionsCollection.doc(transactionsAsBuyer[i]).get().then((userDoc) {
          transactionBody = userDoc.data();
          currentExchanges = List.from(transactionBody['exchanges']);
          currentPaidBooks = List.from(transactionBody['paidBooks']);
          for (int i = 0; i < currentExchanges.length; i++){
            currentExchanges[i]['chosenShippingMode'] = transactionBody['chosenShippingMode'];
            currentExchanges[i]['payCash'] = transactionBody['payCash'];
            currentExchanges[i]['shippingAddress'] = transactionBody['shippingAddress'];
            currentExchanges[i]['time'] = transactionBody['time'];
            currentExchanges[i]['seller'] = transactionBody['seller'];
            currentExchanges[i]['sellerUsername'] = transactionBody['sellerUsername'];
            currentExchanges[i]['buyer'] = transactionBody['buyer'];
            currentExchanges[i]['buyerUsername'] = transactionBody['buyerUsername'];
            if (currentExchanges[i]['exchangeStatus'] == 'pending')
              myPendingExchanges.add(currentExchanges[i]);
            else
              myCompletedExchanges.add(currentExchanges[i]);
          }
          for (int i = 0; i < currentPaidBooks.length; i++){
            currentPaidBooks[i]['chosenShippingMode'] = transactionBody['chosenShippingMode'];
            currentPaidBooks[i]['payCash'] = transactionBody['payCash'];
            currentPaidBooks[i]['shippingAddress'] = transactionBody['shippingAddress'];
            currentPaidBooks[i]['time'] = transactionBody['time'];
            currentPaidBooks[i]['seller'] = transactionBody['seller'];
            currentPaidBooks[i]['sellerUsername'] = transactionBody['sellerUsername'];
            currentPaidBooks[i]['buyer'] = transactionBody['buyer'];
            currentPaidBooks[i]['buyerUsername'] = transactionBody['buyerUsername'];
            myPurchasedBooks.add(currentPaidBooks[i]);
          }
        });
      }
    });

    return [myPurchasedBooks, myCompletedExchanges, myPendingExchanges];
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

  Future<bool> canIReview(String toReviewUid) async {
    bool result = false;

    dynamic myTransactionsAsBuyer;
    await usersCollection.doc(user.uid).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        myTransactionsAsBuyer = doc.data()['transactionsAsBuyer'];
      }
    });

    if(myTransactionsAsBuyer != null) {
      for(int i = 0; !result && i < myTransactionsAsBuyer.length; i++) {
        await transactionsCollection.doc(myTransactionsAsBuyer[i]).get().then((DocumentSnapshot doc) {
          if(doc.exists && doc.data()['seller'] == toReviewUid) {
            result = true;
          }
        });
      }
    }

    return result;
  }

  Future<Timestamp> getLastNotificationDate() async {
    Timestamp when = null;
    await usersCollection.doc(user.uid).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        if(doc.data().containsKey('lastNotificationDate')) {
          when = doc.data()['lastNotificationDate'];
        }
      }
    });
    return when;
  }

  Future<void> setNowAsLastNotificationDate() async {
    await usersCollection.doc(user.uid).update({
      'lastNotificationDate' : DateTime.now()
    });
  }

  Future<Timestamp> getLastChatsDate() async {
    Timestamp when = null;
    await usersCollection.doc(user.uid).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        if(doc.data().containsKey('lastChatsDate')) {
          when = doc.data()['lastChatsDate'];
        }
      }
    });
    return when;
  }

  Future<void> setNowAsLastChatsDate() async {
    await usersCollection.doc(user.uid).update({
      'lastChatsDate' : DateTime.now()
    });
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

  Future<dynamic> saveShippingAddressInfo(Map<String, dynamic> info) async {
    await usersCollection.doc(user.uid).update({
      'shippingAddressInfo': FieldValue.arrayUnion([info])
    });
  }

  Future<dynamic> savePaymentCardInfo(Map<String, dynamic> info) async {
    await usersCollection.doc(user.uid).update({
      'paymentCardInfo': FieldValue.arrayUnion([info])
    });
  }

  Future getPurchaseInfo() async {
    Map<String, List<dynamic>> result = Map<String, List<dynamic>>();
    await usersCollection.doc(user.uid).get().then((doc) {
      result['paymentCardInfo'] = doc.data()['paymentCardInfo'];
      result['shippingAddressInfo'] = doc.data()['shippingAddressInfo'];
    });
    return result;
  }

  Future getPaymentInfo() async {
    Map<String, List<dynamic>> result = Map<String, List<dynamic>>();
    await usersCollection.doc(user.uid).get().then((doc) {
      result['paymentCardInfo'] = doc.data()['paymentCardInfo'];
    });
    return result;
  }

  Future getShippingAddressInfo() async {
    Map<String, List<dynamic>> result = Map<String, List<dynamic>>();
    await usersCollection.doc(user.uid).get().then((doc) {
      result['shippingAddressInfo'] = doc.data()['shippingAddressInfo'];
    });
    return result;
  }

  Future removePaymentInfo(Map<String, dynamic> paymentCardToRemove) async {
    await usersCollection.doc(user.uid).update({
      'paymentCardInfo': FieldValue.arrayRemove([paymentCardToRemove])
    });
  }

  Future removeShippingAddress(Map<String, dynamic> shippingAddressToRemove) async {
    await usersCollection.doc(user.uid).update({
      'shippingAddressInfo': FieldValue.arrayRemove([shippingAddressToRemove])
    });
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
    dynamic result;

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

  Future purchaseAndProposeExchange(String sellingUser, chosenShippingMode, shippingAddress, payCash, List<InsertedBook> booksToPurchase, Map<InsertedBook, Map<String, dynamic>> booksToExchange, Map<int, String> thumbnails) async {

    bool transactionSuccessfullyCompleted = false;
    String usernameToReturn;
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
      bookMap['insertionNumber'] = booksToPurchase[i].insertionNumber;
      bookMap['category'] = booksToPurchase[i].category;
      bookMap['thumbnail'] = thumbnails[booksToPurchase[i].insertionNumber];
      booksToPurchaseMap.add(bookMap);
    }
    transaction['id'] = transactionId;
    transaction['paidBooks'] = booksToPurchaseMap;
    transaction['buyer'] = user.uid;
    transaction['seller'] = sellingUser;
    transaction['chosenShippingMode'] = chosenShippingMode;
    transaction['shippingAddress'] = shippingAddress;
    transaction['payCash'] = payCash;

    transaction['exchanges'] = Utils.exchangedBookFromMap(booksToExchange, thumbnails);

    String buyerUsername = "";
    await usersCollection.doc(user.uid).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        buyerUsername = doc.data()['username'];
      }
    });

    String sellerUsername = "";
    await usersCollection.doc(sellingUser).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        sellerUsername = doc.data()['username'];
      }
    });
    transaction['buyerUsername'] = buyerUsername;
    transaction['sellerUsername'] = sellerUsername;
    transaction['time'] = DateTime.now();

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
      usernameToReturn = sellerUserSnapshot.data()['username'];
      booksToExchangeKeys = booksToExchange.keys.toList();
      for (int i = 0; i < sellerBooks.length; i++){
        for (int j = 0; j < booksToPurchase.length; j++) {
          if (sellerBooks[i]['insertionNumber'] ==
              booksToPurchase[j].insertionNumber) {
            booksToRemove.add(i);
          }
        }
        for (int j = 0; j < booksToExchange.length; j++){
          if (sellerBooks[i]['insertionNumber'] == booksToExchangeKeys[j].insertionNumber){
            exchangingBooks.add(i);
            if (sellerBooks[i]['exchangeStatus'] != 'available')
              throw Exception("Some books you want to exchange are no more available");
          }
        }
      }
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
            sellerHasDuplicate[i] = true;
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

        String category;
        for (int i = 0; i < booksToPurchase.length; i++){
          if (bookData['id'] == booksToPurchase[i].id) {
            category = booksToPurchase[i].category;
            break;
          }
        }

        if (bookData['availableNum'] == 0) {
          booksFromBooksCollectionToDelete.add(booksToRemoveIdNoDuplicates[i]);
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
          bool removeBookFromBooksPerGenre = true;

          for (int j = 0; j < bookData['owners'].length && removeBookFromBooksPerGenre; j++){
            List<String> owners = List.from(bookData['owners']);
            print(owners[j]);
            DocumentReference bookRef = usersCollection.doc(owners[j]);
            DocumentSnapshot bookSnap = await transactionOnDb.get(bookRef);
            dynamic userBooks = bookSnap.data()['books'];
            print(userBooks);
            for (int k = 0; k < userBooks.length && removeBookFromBooksPerGenre; k++) {
              if (userBooks[k]['id'] == bookData['id'] && userBooks[k]['category'] == category)
                removeBookFromBooksPerGenre = false;
            }
          }

          if (removeBookFromBooksPerGenre) {
            if (booksToRemoveFromBooksPerGenres[category] == null)
              booksToRemoveFromBooksPerGenres[category] = [bookData['id']];
            else {
              List<String> books = booksToRemoveFromBooksPerGenres[category];
              books.add(bookData['id']);
              booksToRemoveFromBooksPerGenres[category] = books;
            }
          }
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

      /*
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

      if (booksToExchange != null && booksToExchange.length > 0) {
        print(buyerBooks);
      }
      print(sellerBooks);

       */
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
      .catchError((error) => "The following error occurred: $error");

    if (transactionSuccessfullyCompleted) {
      print('Step 7');
      await transactionsCollection.doc(transaction['id']).set(transaction)
          .catchError((error) => "Failed to add transaction: $error");

      print('Step 8');
      await usersCollection.doc(transaction['seller']).update({
        'transactionsAsSeller': FieldValue.arrayUnion([
          {'transactionId': transaction['id'], 'buyer': transaction['buyer']}
        ]),
      }).then((value) => print("transaction added for seller"))
          .catchError((error) =>
          "Failed to add transaction for seller: $error");

      print('Step 9');
      await usersCollection.doc(user.uid).update({
        'transactionsAsBuyer': FieldValue.arrayUnion([transaction['id']]),
      }).then((value) => print("transaction added for buyer"))
          .catchError((error) =>
          "Failed to add transaction for buyer: $error");
      print('Step 10');
    }

    return [usernameToReturn];
  }


  Future acceptExchange(String transactionId, String seller, Map<String, dynamic> sellerBook,
      String buyer, Map<String, dynamic> buyerBook
      ) async {


    bool transactionSuccessfullyCompleted = false;
    DocumentReference buyerUserReference = usersCollection.doc(buyer);
    DocumentReference sellerUserReference = usersCollection.doc(seller);
    DocumentReference transactionReference = transactionsCollection.doc(transactionId);

    List<dynamic> buyerBooks;
    List<dynamic> sellerBooks;
    int buyerBookToRemoveIndex;
    int sellerBookToRemoveIndex;
    List<String> booksToRemoveId;
    List<bool> thereAreDuplicates;
    List<dynamic> booksFromTransaction;

    await FirebaseFirestore.instance.runTransaction((transactionOnDb) async {
      // check on the seller's books exchanged
      DocumentSnapshot sellerUserSnapshot = await transactionOnDb.get(
          sellerUserReference);
      DocumentSnapshot buyerUserSnapshot = await transactionOnDb.get(
          buyerUserReference);
      DocumentSnapshot transactionSnapshot = await transactionOnDb.get(
          transactionReference);
      if (!sellerUserSnapshot.exists) {
        throw Exception("User does not exist!");
      }

      booksFromTransaction = transactionSnapshot.data()['exchanges'];
      for (int i = 0; i < booksFromTransaction.length; i++){
        if (booksFromTransaction[i]['receivedBook']['insertionNumber'] == sellerBook['insertionNumber'] &&
            booksFromTransaction[i]['offeredBook']['insertionNumber'] == buyerBook['insertionNumber'])
          booksFromTransaction[i]['exchangeStatus'] = 'accepted';
      }

      sellerBooks = sellerUserSnapshot.data()['books'];
      for (int i = 0; i < sellerBooks.length &&
          sellerBookToRemoveIndex == null; i++) {
        if (sellerBooks[i]['insertionNumber'] ==
            sellerBook['insertionNumber']) {
          sellerBookToRemoveIndex = i;
        }
      }

      buyerBooks = buyerUserSnapshot.data()['books'];
      for (int i = 0; i < buyerBooks.length &&
          buyerBookToRemoveIndex == null; i++) {
        if (buyerBooks[i]['insertionNumber'] == buyerBook['insertionNumber']) {
          buyerBookToRemoveIndex = i;
        }
      }
      print(buyerBookToRemoveIndex);

      // check on the buyer's books exchanged
      // still to check this if

      //remove books from seller user document
      booksToRemoveId = List<String>();
      var removedFromSeller = sellerBooks.removeAt(sellerBookToRemoveIndex);
      booksToRemoveId.add(removedFromSeller['id']);
      var removedFromBuyer = buyerBooks.removeAt(buyerBookToRemoveIndex);
      booksToRemoveId.add(removedFromBuyer['id']);

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

      booksAreExchangeableById[sellerBook['id']]++;
      booksAreExchangeableById[buyerBook['id']]++;

      if (sellerBook['imagesUrl'] != null && sellerBook['imagesUrl'].length > 0)
        booksHaveImagesById[sellerBook['id']]++;
      if (buyerBook['imagesUrl'] != null && buyerBook['imagesUrl'].length > 0)
        booksHaveImagesById[buyerBook['id']]++;

      thereAreDuplicates = List.filled(2, false);
      for (int j = 0; j < sellerBooks.length && !thereAreDuplicates[0]; j++) {
        if (sellerBooks[j]['id'] == booksToRemoveId[0]) {
          thereAreDuplicates[0] = true;
        }
      }
      for (int j = 0; j < buyerBooks.length && !thereAreDuplicates[1]; j++) {
        if (buyerBooks[j]['id'] == booksToRemoveId[1]) {
          thereAreDuplicates[1] = true;
        }
      }

      Map<String, dynamic> booksFromBooksCollectionToModify = Map<String,dynamic>();
      List<String> booksFromBooksCollectionToDelete = List<String>();
      Map<String, List<String>> booksToRemoveFromBooksPerGenres = Map<String,List<String>>();


      if (booksToRemoveIdNoDuplicates.length == 1) {
        DocumentReference bookRef = bookCollection.doc(
            booksToRemoveIdNoDuplicates[0]);
        DocumentSnapshot bookSnap = await transactionOnDb.get(bookRef);
        dynamic bookData = bookSnap.data();

        bookData['availableNum'] = bookData['availableNum'] - 2;
        bookData['exchangeable'] = bookData['exchangeable'] - 2;
        bookData['haveImages'] = bookData['haveImages'] -
            booksHaveImagesById[booksToRemoveIdNoDuplicates[0]];
        for (int j = 0; j < thereAreDuplicates.length; j++) {
          if (!thereAreDuplicates[j]) {
            List<String> owners = List.from(bookData['owners']);
            if (j == 0)
              owners.remove(seller);
            else
              owners.remove(buyer);
            bookData['owners'] = owners;
          }
        }

        for (int i = 0; i < booksToRemoveId.length; i++) {
          String category;
          if (i == 0)
            category = sellerBook['category'];
          else
            category = buyerBook['category'];
          bool removeBookFromBooksPerGenre = true;
          for (int j = 0; j < bookData['owners'].length &&
              removeBookFromBooksPerGenre; j++) {
            List<String> owners = List.from(bookData['owners']);
            DocumentReference bookRef = usersCollection.doc(owners[j]);
            DocumentSnapshot bookSnap = await transactionOnDb.get(bookRef);
            dynamic userBooks = bookSnap.data()['books'];
            for (int k = 0; k < userBooks.length &&
                removeBookFromBooksPerGenre; k++) {
              if (userBooks[k]['id'] == bookData['id'] &&
                  userBooks[k]['category'] == category)
                removeBookFromBooksPerGenre = false;
            }
          }
          if (removeBookFromBooksPerGenre) {
            if (booksToRemoveFromBooksPerGenres[category] == null)
              booksToRemoveFromBooksPerGenres[category] = [bookData['id']];
            else {
              List<String> books = booksToRemoveFromBooksPerGenres[category];
              books.add(bookData['id']);
              booksToRemoveFromBooksPerGenres[category] = books;
            }
          }
        }
      } else {
        for (int i = 0; i < booksToRemoveIdNoDuplicates.length; i++) {
          DocumentReference bookRef = bookCollection.doc(
              booksToRemoveIdNoDuplicates[i]);
          DocumentSnapshot bookSnap = await transactionOnDb.get(bookRef);
          dynamic bookData = bookSnap.data();

          bookData['availableNum'] = bookData['availableNum'] -
              booksCountById[booksToRemoveIdNoDuplicates[i]];
          bookData['exchangeable'] = bookData['exchangeable'] -
              booksAreExchangeableById[booksToRemoveIdNoDuplicates[i]];
          bookData['haveImages'] = bookData['haveImages'] -
              booksHaveImagesById[booksToRemoveIdNoDuplicates[i]];
          if (!thereAreDuplicates[i]) {
            List<String> owners = List.from(bookData['owners']);
            if (i == 0)
              owners.remove(seller);
            else
              owners.remove(buyer);
            bookData['owners'] = owners;
          }

          String category;
          if (i == 0)
            category = sellerBook['category'];
          else
            category = buyerBook['category'];
          if (bookData['availableNum'] == 0) {
            booksFromBooksCollectionToDelete.add(
                booksToRemoveIdNoDuplicates[i]);
            if (booksToRemoveFromBooksPerGenres[category] == null)
              booksToRemoveFromBooksPerGenres[category] = [bookData['id']];
            else {
              List<String> books = booksToRemoveFromBooksPerGenres[category];
              books.add(bookData['id']);
              booksToRemoveFromBooksPerGenres[category] = books;
            }
          }
          else {
            booksFromBooksCollectionToModify[booksToRemoveIdNoDuplicates[i]] =
                bookData;
            bool removeBookFromBooksPerGenre = true;

            for (int j = 0; j < bookData['owners'].length &&
                removeBookFromBooksPerGenre; j++) {
              List<String> owners = List.from(bookData['owners']);
              print(owners[j]);
              DocumentReference bookRef = usersCollection.doc(owners[j]);
              DocumentSnapshot bookSnap = await transactionOnDb.get(bookRef);
              dynamic userBooks = bookSnap.data()['books'];
              print(userBooks);
              for (int k = 0; k < userBooks.length &&
                  removeBookFromBooksPerGenre; k++) {
                if (userBooks[k]['id'] == bookData['id'] &&
                    userBooks[k]['category'] == category)
                  removeBookFromBooksPerGenre = false;
              }
            }

            if (removeBookFromBooksPerGenre) {
              if (booksToRemoveFromBooksPerGenres[category] == null)
                booksToRemoveFromBooksPerGenres[category] = [bookData['id']];
              else {
                List<String> books = booksToRemoveFromBooksPerGenres[category];
                books.add(bookData['id']);
                booksToRemoveFromBooksPerGenres[category] = books;
              }
            }
          }
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

      /*
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
       */

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

      print('Step 6');
      batch.update(sellerUserReference, {'books': sellerBooks});
      batch.update(buyerUserReference, {'books': buyerBooks});
      batch.update(transactionReference, {'exchanges': booksFromTransaction});

      batch.commit();
    }).then((value) {print("transaction ended successfully"); transactionSuccessfullyCompleted = true;})
        .catchError((error) => print("The following error occurred: $error")); //TODO fare return dell'errore e stampare a schermo

    if (transactionSuccessfullyCompleted)
      return 'ok';

  }


  Future declineExchange(String transactionId, String seller, Map<String, dynamic> sellerBook,
      String buyer, Map<String, dynamic> buyerBook
      ) async {

    bool transactionSuccessfullyCompleted;
    DocumentReference buyerUserReference = usersCollection.doc(user.uid);
    DocumentReference sellerUserReference = usersCollection.doc(seller);
    DocumentReference transactionReference = transactionsCollection.doc(transactionId);

    List<dynamic> buyerBooks;
    List<dynamic> sellerBooks;
    List<dynamic> booksFromTransaction;

    await FirebaseFirestore.instance.runTransaction((transactionOnDb) async {
      DocumentSnapshot sellerUserSnapshot = await transactionOnDb.get(
          sellerUserReference);
      DocumentSnapshot buyerUserSnapshot = await transactionOnDb.get(
          buyerUserReference);
      DocumentSnapshot transactionSnapshot = await transactionOnDb.get(
          transactionReference);

      if (!sellerUserSnapshot.exists) {
        throw Exception("User does not exist!");
      }
      sellerBooks = sellerUserSnapshot.data()['books'];
      for (int i = 0; i < sellerBooks.length; i++) {
        if (sellerBooks[i]['insertionNumber'] ==
            sellerBook['insertionNumber']) {
          sellerBooks[i]['exchangeStatus'] = 'available';
        }
      }

      buyerBooks = buyerUserSnapshot.data()['books'];
      for (int i = 0; i < buyerBooks.length; i++) {
        if (buyerBooks[i]['insertionNumber'] == buyerBook['insertionNumber']) {
          buyerBooks[i]['exchangeStatus'] = 'available';
        }
      }

      booksFromTransaction = transactionSnapshot.data()['exchanges'];
      for (int i = 0; i < booksFromTransaction.length; i++){
        if (booksFromTransaction[i]['receivedBook']['insertionNumber'] == sellerBook['insertionNumber'] &&
            booksFromTransaction[i]['offeredBook']['insertionNumber'] == buyerBook['insertionNumber'])
          booksFromTransaction[i]['exchangeStatus'] = 'rejected';
      }

      print('Step 1');
      WriteBatch batch = FirebaseFirestore.instance.batch();

      print('Step 2');
      batch.update(sellerUserReference, {'books': sellerBooks});
      batch.update(buyerUserReference, {'books': buyerBooks});
      batch.update(transactionReference, {'exchanges': booksFromTransaction});
      batch.commit();
    }).then((value) {print("the exchange has been declined"); transactionSuccessfullyCompleted = true;})
        .catchError((error) => print("The following error occurred: $error")); //TODO fare return dell'errore e stampare a schermo

    if (transactionSuccessfullyCompleted)
      return 'ok';
  }


  Future<dynamic> getTransactionFromKey(String transactionKey) async {
    dynamic result;
    await transactionsCollection.doc(transactionKey).get().then((DocumentSnapshot doc) {
      if(doc.exists) {
        result = doc.data();
      }
    });
    return result;
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

  Future<dynamic> createNewChat(String userUid1, String userUid2, String userUid1Username, String userUid2Username) async {
    dynamic result = null;

    String keyPart1 = userUid1.compareTo(userUid2) > 0 ? userUid1 : userUid2;
    String keyPart2 = userUid1.compareTo(userUid2) > 0 ? userUid2 : userUid1;
    DateTime time = DateTime.now();
    String chatKey = Utils.encodeBase64(keyPart1 + "_" + keyPart2);

    bool newChatCreated = true;

    await chatsCollection.doc(chatKey).get().then((DocumentSnapshot doc) async {
      if (!doc.exists) {
        Chat newChat = Chat(
            userUid1, userUid2, userUid1Username, userUid2Username, List<Message>(), time
        );
        newChat.setKnownKey(chatKey);
        await chatsCollection.doc(chatKey).set(newChat.toMap())
            .then((value) {result = newChat.toMap(); print("Chat Added");})
            .catchError((error) {print("Failed to add chat: $error");});
      }
      else {
        newChatCreated = false;
        result = doc.data();
      }
    });

    if(result != null && newChatCreated) {
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
    }

    return result;
  }

  Future<List<Message>> addMessageToChat(String message, Chat chat, CustomUser userFromDb) async {
    dynamic currentMessages;
    await chatsCollection.doc(chat.chatKey).get().then((DocumentSnapshot doc) async {
      if (doc.exists) {
        currentMessages = doc.get("messages");
      }
    });

    Message newMessage = Message (
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

  /*Future<void> addFakeTransaction() async {
    String randomId = Random.secure().nextInt(100).toString();
    await transactionsCollection.doc('RandomId'+randomId).set(
      {
        'id': ('RandomId'+randomId),
        'time': DateTime.now(),
        'buyer': 'Fake Buyer UID',
        'buyerUsername': 'Fake Buyer Username',
        'seller': user.uid,
      }
    );
    await usersCollection.doc(user.uid).update({
      'transactionsAsSeller': FieldValue.arrayUnion([{
        'buyer': 'Fake Buyer UID',
        'transactionId': 'RandomId'+randomId,
      }]),
    });
  }*/

}
