import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {


  final FirebaseStorage storage = FirebaseStorage.instance;

  void addBookPictures(String useruid, String bookTitle, List<PickedFile> images) {
    //var result = List<String>();
    String basePath = useruid + "/" + bookTitle;

    images.asMap().forEach((index, image) async {
      String fileName = bookTitle + index.toString();
      Reference reference = storage.ref().child("$basePath/$fileName");

      /*
      final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': image.path});
      pr

       */

      try {
        await reference.putFile(File(image.path));
        print("Images Inserted");
      } on FirebaseException catch (e) {
          e.toString();
      }

      //TODO return the imagesURL
    });
  }
}