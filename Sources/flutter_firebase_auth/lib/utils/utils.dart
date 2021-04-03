import 'dart:io';

import 'package:flutter_firebase_auth/models/user.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class Utils {

  static Directory applicationDocumentDirectory;
  static Directory imageDirectory;

  static init() async{
    applicationDocumentDirectory = await getApplicationDocumentsDirectory();
    var imageDirPath = applicationDocumentDirectory.path + '/images';
    if(!Directory(imageDirPath).existsSync()){
      imageDirectory = await Directory(imageDirPath).create(recursive: true);
    } else {
      imageDirectory = Directory(imageDirPath);
    }
  }


  static setUserProfileImagePath(CustomUser user) async {

    if(user.userProfileImageURL != ''){
      var imageDirectoryPath = imageDirectory.path;
      var imageProfilePath = imageDirectoryPath + '/imageProfilePic.png';
      if (File(imageProfilePath).existsSync())
        user.setUserProfileImagePath(imageProfilePath);
      else {
        var response = await get(user.userProfileImageURL);
        File imageFile = new File(imageProfilePath);
        imageFile.writeAsBytesSync(response.bodyBytes);
        user.setUserProfileImagePath(imageProfilePath);
      }
    }
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

}