import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';

class InsertedBook {

  String id;
  String title;   //redundant but useful for search
  String author;
  String isbn13;      //redundant but useful for search
  List<String> imagesPath;
  List<String> imagesUrl;
  List<String> likedBy;
  BookGeneralInfo bookGeneralInfo;
  String category;
  int insertionNumber;
  int status;
  String comment;
  double price;
  bool exchangeable;



  InsertedBook({
    this.id,
    this.title,
    this.author,
    this.isbn13,
    this.status = 3,
    this.category,
    this.imagesPath,
    this.imagesUrl,
    this.likedBy,
    this.comment = '',
    this.insertionNumber,
    this.price,
    this.exchangeable = false,
    this.bookGeneralInfo});

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

  void setCategory(String category){
    this.category = category;
  }

  void setInsertionNumber(int insertionNumber){
    this.insertionNumber = insertionNumber;
  }

  void setPrice(double price){
    this.price = price;
  }

  void toggleExchangeable(){
    this.exchangeable = !this.exchangeable;
  }

  void addImage(String imagePath){
    if (imagesPath == null){
      imagesPath = List<String>();
    }
    imagesPath.add(imagePath);
  }

  void removeImage(int index){
    imagesPath.removeAt(index);
  }

  Map<String, dynamic> generalInfoToMap() {
    Map<String, dynamic> completeGeneralInfoMap = Map<String, dynamic>();
    completeGeneralInfoMap.addAll(bookGeneralInfo.toMap());
    completeGeneralInfoMap.addAll({
      "availableNum": 1,
      "exchangeable": exchangeable ? 1 : 0,
      "haveImages": (imagesPath != null && imagesPath.length != 0) ? 1 : 0,
    });
    return completeGeneralInfoMap;
  }

  /// returns mapping of the class excluding the bookGeneralInfo attribute
  Map<String, dynamic> toMap() {
    var insertedBook = new Map<String, dynamic>();
    insertedBook['id'] = id;
    insertedBook['title'] = title;
    insertedBook['author'] = author;
    insertedBook['isbn'] = isbn13;
    insertedBook['status'] = status;
    //if (images != null) insertedBook['images'] = images;
    insertedBook['comment'] = comment ?? "";
    insertedBook['imagesUrl'] = imagesUrl ?? "";
    insertedBook['likedBy'] = likedBy ?? [];
    insertedBook['insertionNumber'] = insertionNumber;
    insertedBook['exchangeable'] = exchangeable ?? false;
    insertedBook['price'] = price ?? 0.0;
    insertedBook['category'] = category ?? "Generic";
    insertedBook['thumbnail'] = bookGeneralInfo.thumbnail ?? null;
    return insertedBook;
  }

  /*
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
   */

}

