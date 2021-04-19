import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';

class ChooseBooksForExchange extends StatefulWidget {

  List<InsertedBook> booksToExchange;

  ChooseBooksForExchange({Key key, @required this.booksToExchange});

  @override
  _ChooseBooksForExchangeState createState() => _ChooseBooksForExchangeState();
}

class _ChooseBooksForExchangeState extends State<ChooseBooksForExchange> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
