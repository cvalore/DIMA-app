import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:image_picker/image_picker.dart';

class InsertedBook {

  final String title;   //redundant but useful for search
  final String author;
  final String isbn13;      //redundant but useful for search
  List<PickedFile> images;
  BookGeneralInfo bookGeneralInfo;
  int status;
  String description;
      //TODO add purpose


  InsertedBook(this.title, this.author, this.isbn13, this.status, {this.images, this.description});

  void addBookGeneralInfo(BookGeneralInfo bookGeneralInfo) {
    this.bookGeneralInfo = bookGeneralInfo;
  }

  /// returns mapping of the class excluding the bookGeneralInfo attribute
  Map<String, dynamic> toMap() {
    var insertedBook = new Map<String, dynamic>();
    insertedBook['title'] = title;
    insertedBook['author'] = author;
    insertedBook['isbn'] = isbn13;
    insertedBook['status'] = status;        //make it optional??
    if (images != null) insertedBook['images'] = images;
    if (description != null) insertedBook['description'] = description;
    return insertedBook;
  }

  Map<String, dynamic> generalInfoToMap() {
    return bookGeneralInfo.toMap();
  }

}