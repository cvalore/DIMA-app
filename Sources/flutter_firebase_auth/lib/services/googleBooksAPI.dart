import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleBooksAPI {

  Future performSearch(String searchText) async {

    final response = await http.get(
        'https://www.googleapis.com/books/v1/volumes?q=intitle:"' +
            searchText.toString() +
            '"&fields=items(volumeInfo(title))' +
            '&key=' + googleBookAPIKey
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      print('---------------------');

    }
    else {
      print('GET response error - ' + response.statusCode.toString());
      print(jsonDecode(response.body));
    }
  }

}