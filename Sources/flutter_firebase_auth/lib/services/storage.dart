import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {


  final FirebaseStorage storage = FirebaseStorage.instance;

  Future addBookPicture(String useruid, String bookTitle,
      int numberOfInsertedItems, PickedFile image, int index) async {

    String basePath = useruid + "/" + bookTitle + '_' + numberOfInsertedItems.toString();
    String fileName = bookTitle + '_' + index.toString();
    Reference reference = storage.ref().child("$basePath/$fileName");

    try {
      await reference.putFile(File(image.path));
      print("Images Inserted");
    } on FirebaseException catch (e) {
      e.toString();
    }

    return reference;
  }

  Future addUrlPicture(Reference reference) async {

    String url;

    try {
      url = await reference.getDownloadURL();
      print("Images Inserted");
    } on FirebaseException catch (e) {
      e.toString();
    }

    return url;
  }

  Future<List<String>> addBookPictures(String useruid, String bookTitle,
      int numberOfInsertedItems, List<PickedFile> images) async {

    List<String> result = List<String>();
    String basePath = useruid + "/" + bookTitle + '_' + numberOfInsertedItems.toString();


    images.asMap().forEach((index, image) async {
      String fileName = bookTitle + '_' + index.toString();
      Reference reference = storage.ref().child("$basePath/$fileName");

      try {
        await reference.putFile(File(image.path));
        print("Images Inserted");
      } on FirebaseException catch (e) {
          e.toString();
      }

      try {
        String imgUrl = await reference.getDownloadURL();
        result.add(imgUrl);
      } on FirebaseException catch (e) {
        e.toString();
      }
    });

    return result;
  }
}