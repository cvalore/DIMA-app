import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {


  final FirebaseStorage storage = FirebaseStorage.instance;


  Future addUserProfilePic(String useruid, String imagePath) async {

    String basePath = useruid + "/";
    String fileName = 'userProfilePic';
    Reference reference = storage.ref().child("$basePath/$fileName");

    try {
      await reference.putFile(File(imagePath));
    } on FirebaseException catch (e) {
      e.toString();
    }

    return reference;
  }


  Future removeUserProfilePic(String useruid) async {
    String basePath = useruid + "/";
    String fileName = 'userProfilePic';
    Reference reference = storage.ref().child("$basePath/$fileName");
    try {
      await reference.delete();
    } on FirebaseException catch (e) {
      e.toString();
    }
  }

  Future addBookPicture(String useruid, String bookTitle,
      int insertionNumber, String imagePath, int index) async {

    String basePath = useruid + "/" + bookTitle + '_' + insertionNumber.toString();
    String fileName = bookTitle + '_' + index.toString();
    Reference reference = storage.ref().child("$basePath/$fileName");

    try {
      await reference.putFile(File(imagePath));
    } on FirebaseException catch (e) {
      e.toString();
    }

    return reference;
  }

  Future removeBookPicture(String useruid, String bookTitle, int insertionNumber) async {
    String basePath = useruid + "/" + bookTitle + '_' + insertionNumber.toString();
    Reference reference = storage.ref().child("$basePath/");

    ListResult lr = await reference.listAll();
    for(Reference r in lr.items) {
      try {
        await r.delete();
      } on FirebaseException catch (e) {
        e.toString();
      }
    }
  }

  Future getUrlPicture(Reference reference) async {

    String url;

    try {
      url = await reference.getDownloadURL();
    } on FirebaseException catch (e) {
      e.toString();
    }

    return url;
  }

  Reference getBookDirectoryReference(String useruid, InsertedBook book) {
    String basePath = useruid + "/" + book.title + '_' + book.insertionNumber.toString();
    Reference reference = storage.ref().child("$basePath/");
    return reference;
  }

  Reference getBookImageReference(String useruid, InsertedBook book, int index) {
    String basePath = useruid + "/" + book.title + '_' + book.insertionNumber.toString();
    String fileName = book.title + '_' + index.toString();
    Reference reference = storage.ref().child("$basePath/$fileName");
    return reference;
  }

  Future<String> toDownloadFile(Reference ref, int index) async {
    Directory tempDir = await getTemporaryDirectory();
    File downloadToFile = File('${tempDir.path}/tempImage'+ UniqueKey().toString() +'.png');
    try {
      await ref.writeToFile(downloadToFile);
      return downloadToFile.path;
    } on FirebaseException catch (e) {
      e.toString();
      return null;
    }
  }
}