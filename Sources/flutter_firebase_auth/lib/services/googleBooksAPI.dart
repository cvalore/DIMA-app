import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleBooksAPI {

  Future performSearch(String title, String author) async {

    final String url =
        'https://www.googleapis.com/books/v1/volumes?q=' +
        'intitle:\"' + title +
        '\"+inauthor:\"' + author +
        '\"&fields=' + googleBookAPIFields +
        '&key=' + googleBookAPIKey;

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      print('---------------------');
      return jsonDecode(response.body);
    }
    else {
      print('GET response error - ' + response.statusCode.toString());
      print(jsonDecode(response.body));
      return null;
    }
  }

}