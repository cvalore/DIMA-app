import 'package:flutter_firebase_auth/services/googleBooksAPIImpl.dart';
import 'package:flutter_firebase_auth/services/googleBooksAPIMock.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';



abstract class GoogleBooksAPI {

  factory GoogleBooksAPI() {
    if(Utils.mockedDb) {
      return GoogleBooksAPIMock();
    }
    else {
      return GoogleBooksAPIImpl();
    }
  }

  Future performSearch(String title, String author);

  String getISBN10(dynamic selected);

  String getISBN13(dynamic selected);

}