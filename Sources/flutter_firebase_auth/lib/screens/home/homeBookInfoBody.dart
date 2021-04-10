import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/screens/home/homeGeneralInfoView.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'package:flutter_firebase_auth/services/database.dart';

class HomeBookInfoBody extends StatelessWidget {

  final PerGenreBook book;
  final DatabaseService db;
  final bool fromSearch;

  final sectionTitles = [
    Text('Book general info'),
    Text('Sold by'),
    Text('Exchanged by'),
  ];

  final sectionContents = [];

  HomeBookInfoBody({Key key, this.book, this.db, this.fromSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: fromSearch,
      physics: fromSearch ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
            initiallyExpanded: fromSearch ? false : (index == 1 ? true : false),
            title: sectionTitles[index],
            children: <Widget>[
              index == 0 ?
              FutureBuilder(
                future: db.getGeneralBookInfo(book.id),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return Text('Loading....');
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else
                        return HomeBookGeneralInfoView(selectedBook: snapshot.data,);
                  }
                },
              ) :
              (index == 1 ?
              FutureBuilder(
                future: db.getBookSoldBy(book.id),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return Text('Loading....');
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else
                        return SoldByView(books: snapshot.data, showOnlyExchangeable: false,);
                  }
                },
              ) :
              FutureBuilder(
                future: db.getBookSoldBy(book.id),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return Text('Loading....');
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else
                        return SoldByView(books: snapshot.data, showOnlyExchangeable: true,);
                  }
                },
              )
              )
            ]
        );
      },
    );
  }
}
