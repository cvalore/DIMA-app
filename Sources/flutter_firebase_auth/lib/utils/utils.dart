import 'dart:io';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/myBooks/viewBookPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class Utils {

  static Directory applicationDocumentDirectory;
  static Directory imageDirectory;
  static DatabaseService databaseService;
  static CustomUser mySelf;


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
    print(encoded);
    return encoded;
  }



  static Future<void> pushBookPage(BuildContext context, book, String userUid) async {
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
      price: book['price'],
      exchangeable: book['exchangeable'],
    );
    print(userUid);
    print(bookToPush);
    Reference bookRef = DatabaseService().storageService.getBookDirectoryReference(userUid, bookToPush);
    List<String> bookPickedFilePaths = List<String>();
    ListResult lr = await bookRef.listAll();
    int count = 0;
    for(Reference r in lr.items) {
      try {
        String filePath = await DatabaseService().storageService.toDownloadFile(r, count);
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
            builder: (newContext) => ViewBookPage(
              book: bookToPush,
              isSell: true,
            )
        )
    );

  }


}