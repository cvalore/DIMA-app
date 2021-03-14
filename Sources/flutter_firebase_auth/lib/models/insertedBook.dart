import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:image_picker/image_picker.dart';

class InsertedBook {

  String id;
  String title;   //redundant but useful for search
  String author;
  String isbn13;      //redundant but useful for search
  List<PickedFile> images;
  BookGeneralInfo bookGeneralInfo;
  int status;
  String comment;
  double price;
      //TODO add purpose


  InsertedBook({this.id, this.title, this.author, this.isbn13, this.status = 1, this.images, this.comment = '', this.price});

  void setBookGeneralInfo(BookGeneralInfo bookGeneralInfo) {
    this.bookGeneralInfo = bookGeneralInfo;
  }

  void setIdTitleAuthorIsbn(String id, String title, String author, String isbn13){
    this.id = id;
    this.title = title;
    this.author = author;
    this.isbn13 = isbn13;
  }

  void setStatus(int status){
    this.status = status;
  }

  void setComment(String comment){
    this.comment = comment;
  }

  void addImage(PickedFile imageAsFile){
    if (images == null){
      images = List<PickedFile>();
    }
    images.add(imageAsFile);
  }

  void removeImage(int index){
    images.removeAt(index);
  }

  Map<String, dynamic> generalInfoToMap() {
    return bookGeneralInfo.toMap();
  }

  /// returns mapping of the class excluding the bookGeneralInfo attribute
  Map<String, dynamic> toMap() {
    var insertedBook = new Map<String, dynamic>();
    insertedBook['id'] = id;
    insertedBook['title'] = title;
    insertedBook['author'] = author;
    insertedBook['isbn'] = isbn13;
    insertedBook['status'] = status;        //make it optional??
    //if (images != null) insertedBook['images'] = images;
    if (comment != null) insertedBook['comment'] = comment;
    return insertedBook;
  }

  void printBook(){
    print("${this.title} + ${this.author} + ${this.isbn13} + ${this.status.toString()}");
    print("$comment");
    if (images != null) {
      print("number of images is ${images.length}");
    } else {
      print("no images");
    }
    print(this.bookGeneralInfo.title);
    print(this.bookGeneralInfo.author);
    print(this.bookGeneralInfo.isbn13);
    print(this.bookGeneralInfo.language);


  }

}