import 'package:flutter/material.dart';

const inputFieldDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
  ),
  /*focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
  ),*/
);

const googleBookAPIKey = 'AIzaSyAIbNkEmTSHCeggxoGFlN7D0WiFFORuewA';
const googleBookAPIFields = 'items(id,volumeInfo(title,authors,publisher,publishedDate,description,industryIdentifiers,pageCount,categories,averageRating,ratingsCount,imageLinks,language))';
const imageWidth = 128.0;
const imageHeight = 198.0;