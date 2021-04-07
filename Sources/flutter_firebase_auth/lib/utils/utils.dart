import 'dart:io';

import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class Utils {

  static Directory applicationDocumentDirectory;
  static Directory imageDirectory;
  static DatabaseService databaseService;
  static CustomUser mySelf;


  static initDatabaseService(AuthCustomUser authCustomUser){
    CustomUser customUser = CustomUser(authCustomUser.uid, authCustomUser.email, authCustomUser.isAnonymous);
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

  static double computeAverageRatingFromReviews(List<Review> reviews){
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

}