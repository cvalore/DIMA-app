import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/services/googleBooksAPI.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class TestPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final booksAPI = GoogleBooksAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        title: Text('Available books'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKey,
            child:
              TextFormField(
                decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                validator: (value) =>
                value.isEmpty ? 'Enter the book title' : null,
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    await booksAPI.performSearch(value);
                  }
                }
              ),
          )
        ],
      ),
    );
  }
}
