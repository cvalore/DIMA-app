import 'dart:convert';

import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';
import 'package:http/http.dart' as http;

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
      //print(jsonDecode(response.body));
      //print('---------------------');
      return jsonDecode(response.body);
    }
    else {
      print('GET response error - ' + response.statusCode.toString());
      print(jsonDecode(response.body));
      return null;
    }
  }

  String getISBN10(dynamic selected) {
    if(selected['industryIdentifiers'] == null) {
      return "";
    }

    if(selected['industryIdentifiers'][0] != null) {
      if(selected['industryIdentifiers'][0]['type'] == 'ISBN_10') {
        return selected['industryIdentifiers'][0]['identifier'];
      }
      else if(selected['industryIdentifiers'][1] != null) {
        if(selected['industryIdentifiers'][1]['type'] == 'ISBN_10') {
          return selected['industryIdentifiers'][1]['identifier'];
        }
      }
    }
    else if(selected['industryIdentifiers'][1] != null) {
      if(selected['industryIdentifiers'][1]['type'] == 'ISBN_10') {
        return selected['industryIdentifiers'][1]['identifier'];
      }
    }

    return null;
  }

  String getISBN13(dynamic selected) {
    if(selected['industryIdentifiers'] == null) {
      return "";
    }
    if(selected['industryIdentifiers'].length > 0 && selected['industryIdentifiers'][0] != null) {
      if(selected['industryIdentifiers'][0]['type'] == 'ISBN_13') {
        return selected['industryIdentifiers'][0]['identifier'];
      }
      else if(selected['industryIdentifiers'].length > 1 && selected['industryIdentifiers'][1] != null) {
        if(selected['industryIdentifiers'][1]['type'] == 'ISBN_13') {
          return selected['industryIdentifiers'][1]['identifier'];
        }
      }
    }
    else if(selected['industryIdentifiers'].length > 1 && selected['industryIdentifiers'][1] != null) {
      if(selected['industryIdentifiers'][1]['type'] == 'ISBN_13') {
        return selected['industryIdentifiers'][1]['identifier'];
      }
    }

    return null;
  }

}