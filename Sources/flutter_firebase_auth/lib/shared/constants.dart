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
const googleBookAPIFields = 'items(volumeInfo(title))';