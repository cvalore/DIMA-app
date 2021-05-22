import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/message.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/myBooks/viewBookPage.dart';
import 'package:flutter_firebase_auth/screens/notifications/viewBookFromTransaction.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/viewBoughtItemPage.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/viewExchangedItemPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class Utils {

  static Directory applicationDocumentDirectory;
  static Directory imageDirectory;
  static DatabaseService databaseService;
  static CustomUser mySelf;

  static bool mockedDb = false;

  static AuthCustomUser mockedLoggedUser;
  static Map<String, String> mockedUsers = Map<String, String>();
  static List<InsertedBook> mockedInsertedBooks = List<InsertedBook>();
  static Map<String, dynamic> mockedInsertedBooksMap = Map<String, dynamic>();


  static initDatabaseService(AuthCustomUser authCustomUser){
    CustomUser customUser = CustomUser(authCustomUser.uid, email: authCustomUser.email, isAnonymous: authCustomUser.isAnonymous);
    mySelf = customUser;
    databaseService = DatabaseService(user: customUser);
  }


  static init() async{
    applicationDocumentDirectory = await getApplicationDocumentsDirectory();
    var imageDirPath = applicationDocumentDirectory.path + '/images';
    if(!Directory(imageDirPath).existsSync()){
      imageDirectory = await Directory(imageDirPath).create(recursive: true);
    } else {
      imageDirectory = Directory(imageDirPath);
    }
  }


  // the following two methods are useless if using network image
  static saveNewImageProfile(String imagePath) async {
    print(imagePath);
    File image = File(imagePath);
    var imageDirectoryPath = imageDirectory.path;
    File newImageFile = await image.copy('$imageDirectoryPath/imageProfilePic.png');
    print(newImageFile.path);
    print('new copy of the image has been set');
  }

  static Future setUserProfileImagePath(CustomUser user) async {
    if(user.userProfileImageURL != ''){
      var imageDirectoryPath = imageDirectory.path;
      var imageProfilePath = imageDirectoryPath + '/imageProfilePic.png';
      if (File(imageProfilePath).existsSync()) {
        //print('Image already exists in local');
        user.setUserProfileImagePath(imageProfilePath);
      }
      else {
        var response = await get(user.userProfileImageURL);
        File imageFile = new File(imageProfilePath);
        imageFile.writeAsBytesSync(response.bodyBytes);
        user.setUserProfileImagePath(imageProfilePath);
        print('Image has been downloaded and set');
      }
    }
    return true;
  }

  static bool isDateValid(String birthDateString) {
    List<String> partsAsString;
    List<int> partsAsInt = [];
    if (birthDateString.contains('/')) {
      try {
        partsAsString = birthDateString.split('/');
        if (partsAsString.length != 3) {
          return false;
        }
        for (int i = 0; i < partsAsString.length; i++)
          partsAsInt.add(int.parse(partsAsString[i]));
      } on Exception {
        return false;
      }

      DateTime today = DateTime.now();
      DateTime birthDate = DateTime(
          partsAsInt[2], partsAsInt[1], partsAsInt[0]);
      DateTime minDate = DateTime(
          partsAsInt[2] + 10, partsAsInt[1], partsAsInt[0]);
      return minDate.isBefore(today);
    }
    return false;
  }

  /*
  static String parseDateFromDateTime(DateTime dateTime){
    String dateTimeString = dateTime.toString();
    List<String> date = dateTimeString.split(' ');
    print(date[0]);
    return date[0];
  }
   */

  static double computeAverageRatingFromAPI(double avgAPI) {
    if(avgAPI == 0.0) {
      return avgAPI;
    }

    double decimalValue = avgAPI.ceilToDouble() - avgAPI;
    if (decimalValue < 0.25)
      return avgAPI.floorToDouble();
    else if (decimalValue < 0.75)
      return avgAPI.floorToDouble() + 0.5;
    else
      return avgAPI.ceilToDouble();
  }

  static double computeAverageRatingFromReviews(List<ReceivedReview> reviews){
    double averageRating;
    double decimalValue;
    averageRating = reviews.length != 0 ?
    reviews.map((review) => review.stars).reduce((value, element) => value + element) / reviews.length
        : 0.0;

    if (averageRating == 0.0)
      return averageRating;

    decimalValue = averageRating.ceilToDouble() - averageRating;
    if (decimalValue < 0.25)
      return averageRating.floorToDouble();
    else if (decimalValue < 0.75)
      return averageRating.floorToDouble() + 0.5;
    else
      return averageRating.ceilToDouble();
  }

  static String computeHowLongAgo(DateTime time) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(time);
    if (difference.inDays >= 1)
      return (difference.inDays).toString() + ' days ago';
    else if (difference.inHours >= 1)
      return (difference.inHours).toString() + ' hours ago';
    else if(difference.inMinutes >= 1)
      return (difference.inMinutes).toString() + ' minutes ago';
    else
      return 'Few seconds ago';
  }

  static String encodeBase64(String toEncode){
    String encoded = base64.encode(utf8.encode(toEncode));
    return encoded;
  }

  static ForumDiscussion toForumDiscussion(dynamic discussion) {

    List<Message> messages = List<Message>();
    discussion['messages'].forEach(
            (element) {
          messages.add(Message.fromDynamicToMessage(element));
        }
    );

    ForumDiscussion forumDiscussion = ForumDiscussion.FromDynamicToForumDiscussion(discussion, messages);
    forumDiscussion.setStartedByProfilePicture(discussion['startedByProfilePicture']);
    forumDiscussion.setStartedByUsername(discussion['startedByUsername']);
    return forumDiscussion;
  }

  static Chat toChat(dynamic chatMap) {

    List<Message> messages = List<Message>();
    print(chatMap['messages']);
    chatMap['messages'].forEach(
            (element) {
          messages.add(Message.fromDynamicToMessage(element));
        }
    );

    Chat chat = Chat.FromDynamicToChat(chatMap, messages);
    return chat;
  }


  static Future<void> pushBookPage(BuildContext context, book, String userUid, String thumbnail, bool canBuy) async {
    InsertedBook bookToPush = InsertedBook(
      id: book['id'],
      title: book['title'],
      author: book['author'],
      isbn13: book['isbn'],
      status: book['status'],
      category: book['category'],
      imagesUrl: List.from(book['imagesUrl']),
      likedBy: List.from(book['likedBy']),
      comment: book['comment'],
      insertionNumber: book['insertionNumber'],
      price: double.parse(book['price'].toString()),
      exchangeable: book['exchangeable'],
    );

    List<String> bookPickedFilePaths = List<String>();
    if(DatabaseService().storageService() != null) {
      Reference bookRef = DatabaseService()
          .storageService()
          .getBookDirectoryReference(userUid, bookToPush);
      ListResult lr = await bookRef.listAll();
      int count = 0;
      for (Reference r in lr.items) {
        try {
          String filePath = await DatabaseService()
              .storageService()
              .toDownloadFile(r, count);
          if (filePath != null) {
            bookPickedFilePaths.add(filePath);
          }
        } on FirebaseException catch (e) {
          e.toString();
        }
        count = count + 1;
      }
    }

    bookToPush.imagesPath = bookPickedFilePaths;

    if (book['exchangeStatus'] == 'pending') canBuy = false;

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (newContext) => ViewBookPage(
              book: bookToPush,
              userUid: userUid,
              self: userUid == mySelf.uid,
              thumbnail: thumbnail,
              canBuy: canBuy
            )
        )
    );

  }

  static Map<String,dynamic> boughtBookFromInsertedBook(InsertedBook book){
    Map<String, dynamic> bookMap = Map<String, dynamic>();
    bookMap['id'] = book.id;
    bookMap['title'] = book.title;
    bookMap['author'] = book.author;
    bookMap['imagesUrl'] = book.imagesUrl;
    bookMap['status'] = book.status;
    bookMap['price'] = book.price;
    return bookMap;
  }

  static List<Map<String, dynamic>> exchangedBookFromMap(Map<InsertedBook,Map<String,dynamic>> exchangedBooks, Map<int, String> thumbnails){
    List<Map<String, dynamic>> result = List<Map<String, dynamic>>();
    Map<String, dynamic> currentExchange;
    Map<String, dynamic> receivedBook;
    Map<String, dynamic> offeredBook;
    List<InsertedBook> keys = exchangedBooks.keys.toList();
    for (int i = 0; i < keys.length; i++){
      currentExchange = Map<String, dynamic>();
      receivedBook = Map<String, dynamic>();
      offeredBook = Map<String, dynamic>();

      // init receivedBook
      receivedBook['id'] = keys[i].id;
      receivedBook['title'] = keys[i].title;
      receivedBook['author'] = keys[i].author;
      receivedBook['imagesUrl'] = keys[i].imagesUrl;
      receivedBook['status'] = keys[i].status;
      receivedBook['insertionNumber'] = keys[i].insertionNumber;
      receivedBook['category'] = keys[i].category;
      receivedBook['thumbnail'] = thumbnails[keys[i].insertionNumber];


      var value = exchangedBooks[keys[i]];

      // init offeredBook
      offeredBook['id'] = value['id'];
      offeredBook['title'] = value['title'];
      offeredBook['author'] = value['author'];
      offeredBook['imagesUrl'] = value['imagesUrl'];
      offeredBook['status'] = value['status'];
      offeredBook['insertionNumber'] = value['insertionNumber'];
      offeredBook['category'] = value['category'];
      offeredBook['thumbnail'] = value['thumbnail'];

      // init currentExchange
      currentExchange['receivedBook'] = receivedBook;
      currentExchange['offeredBook'] = offeredBook;
      currentExchange['exchangeStatus'] = 'pending';

      result.add(currentExchange);
    }
    return result;
  }

  static String buildDefaultMessage(sellerUsername, List<InsertedBook> soldBooks, Map<InsertedBook, Map<String, dynamic>> sellerMatchingBooksForExchange) {
    String message = "Hi $sellerUsername!\n";
    if (soldBooks != null && soldBooks.length > 0) {
      message = message + 'I just bought: ';
      for (int i = 0; i < soldBooks.length; i++) {
        if (i == soldBooks.length - 1)
          message = message + soldBooks[i].title + '.\n';
        else
          message = message + soldBooks[i].title + ', ';
      }
    }
    if (sellerMatchingBooksForExchange != null && sellerMatchingBooksForExchange.length > 0){
      List<InsertedBook> keys = sellerMatchingBooksForExchange.keys.toList();
      if (soldBooks != null && soldBooks.length > 0)
        message = message + 'I also offer you: ';
      else
        message = message + 'I offer you: ';
      for (int i = 0; i < keys.length; i++){
        if (i == keys.length - 1) {
          message = message + keys[i].title;
          message = message + ' in exchange of my ' +
              sellerMatchingBooksForExchange[keys[i]]['title'] + '.';
        } else {
          message = message + keys[i].title;
          message = message + ' in exchange of my ' +
              sellerMatchingBooksForExchange[keys[i]]['title'] + ',';
        }
      }
    }
    return message;
  }

  static void showNeedToBeLogged(BuildContext context, int duration) {
    final snackBar = SnackBar(
      duration: Duration(seconds: duration),
      backgroundColor: Colors.grey.withOpacity(1.0),
      content: Text(
        'You need to be logged in to access this functionality',
        style: Theme
            .of(context)
            .textTheme
            .bodyText2.copyWith(color: Colors.black),
      ),
    );
    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static pushBoughtItemPage(BuildContext context, Map<String, dynamic> boughtItem) async {
    InsertedBook bookToPush = InsertedBook(title: boughtItem['title'],
        insertionNumber: boughtItem['insertionNumber'],
        author: boughtItem['author'],
        category: boughtItem['category'],
        price: boughtItem['price'],
        status: boughtItem['status'],
    );
    Reference bookRef = DatabaseService().storageService().getBookDirectoryReference(boughtItem['seller'], bookToPush);
    List<String> bookPickedFilePaths = List<String>();
    ListResult lr = await bookRef.listAll();
    int count = 0;
    for(Reference r in lr.items) {
      try {
        String filePath = await DatabaseService().storageService().toDownloadFile(r, count);
        if(filePath != null) {
          bookPickedFilePaths.add(filePath);
        }
      } on FirebaseException catch (e) {
        e.toString();
      }
      count = count + 1;
    }
    bookToPush.imagesPath = bookPickedFilePaths;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (newContext) => ViewBoughtItemPage(
            boughtBook: bookToPush,
            transactionsInfo : boughtItem
          )
      )
    );
  }

  static pushExchangedBookPage(BuildContext context, Map<String, dynamic> exchangedItem, String type) async {
    InsertedBook receivedBook;
    InsertedBook offeredBook;
    Reference bookRef;
    List<String> bookPickedFilePaths;
    ListResult lr;
    int count;
    receivedBook = InsertedBook(
        title: exchangedItem['receivedBook']['title'],
        insertionNumber: exchangedItem['receivedBook']['insertionNumber'],
        author: exchangedItem['receivedBook']['author'],
        category: exchangedItem['receivedBook']['category'],
        price: exchangedItem['receivedBook']['price'],
        status: exchangedItem['receivedBook']['status'],
    );
    bookRef = DatabaseService().storageService().getBookDirectoryReference(exchangedItem['seller'], receivedBook);
    bookPickedFilePaths = List<String>();
    lr = await bookRef.listAll();
    count = 0;
    for(Reference r in lr.items) {
      try {
        String filePath = await DatabaseService().storageService().toDownloadFile(r, count);
        if(filePath != null) {
          bookPickedFilePaths.add(filePath);
        }
      } on FirebaseException catch (e) {
        e.toString();
      }
      count = count + 1;
    }
    receivedBook.imagesPath = bookPickedFilePaths;

    offeredBook = InsertedBook(
        title: exchangedItem['offeredBook']['title'],
        insertionNumber: exchangedItem['offeredBook']['insertionNumber'],
        author: exchangedItem['offeredBook']['author'],
        category: exchangedItem['offeredBook']['category'],
        price: exchangedItem['offeredBook']['price'],
        status: exchangedItem['offeredBook']['status'],
    );
    bookRef = DatabaseService().storageService().getBookDirectoryReference(exchangedItem['buyer'], offeredBook);
    bookPickedFilePaths = List<String>();
    lr = await bookRef.listAll();
    count = 0;
    for(Reference r in lr.items) {
      try {
        String filePath = await DatabaseService().storageService().toDownloadFile(r, count);
        if(filePath != null) {
          bookPickedFilePaths.add(filePath);
        }
      } on FirebaseException catch (e) {
        e.toString();
      }
      count = count + 1;
    }
    offeredBook.imagesPath = bookPickedFilePaths;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (newContext) => ViewExchangedItemPage(
              receivedBook: receivedBook,
              offeredBook: offeredBook,
              transactionsInfo: exchangedItem,
              type: type,
            )
        )
    );
  }


  static pushBookFromTransaction(BuildContext context, Map<String, dynamic> book, String ownerUid) async {
    InsertedBook bookToPush = InsertedBook(title: book['title'],
      insertionNumber: book['insertionNumber'],
      author: book['author'],
      category: book['category'],
      price: book['price'],
      status: book['status'],
    );
    if(DatabaseService().storageService() != null) {
      Reference bookRef = DatabaseService()
          .storageService()
          .getBookDirectoryReference(ownerUid, bookToPush);
      List<String> bookPickedFilePaths = List<String>();
      ListResult lr = await bookRef.listAll();
      int count = 0;
      for (Reference r in lr.items) {
        try {
          String filePath = await DatabaseService()
              .storageService()
              .toDownloadFile(r, count);
          if (filePath != null) {
            bookPickedFilePaths.add(filePath);
          }
        } on FirebaseException catch (e) {
          e.toString();
        }
        count = count + 1;
      }
      bookToPush.imagesPath = bookPickedFilePaths;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (newContext) => ViewBookFromTransaction(
                book: bookToPush,
            )
        )
    );
  }

  /*
  static computeHowLongAgoFromTimestamp(Timestamp timestamp) {
    DateTime transactionDate = timestamp.toDate();
    DateTime now = DateTime.now();
    Datetime difference = now.difference(transactionDate);
  }

   */

}