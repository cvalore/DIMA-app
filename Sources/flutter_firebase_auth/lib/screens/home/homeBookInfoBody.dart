import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/screens/home/homeGeneralInfoView.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class HomeBookInfoBody extends StatelessWidget {

  final PerGenreBook book;
  final DatabaseService db;

  final sectionContents = [];

  HomeBookInfoBody({Key key, this.book, this.db}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          initiallyExpanded: index == 1 ? true : false,
          tilePadding: EdgeInsets.symmetric(horizontal: _isTablet ? 32.0 : 0.0, vertical: _isTablet ? 12.0 : 0.0),
          title:
          index == 0 ?
            Text('Book general info', style: TextStyle(fontSize: _isTablet ? 20.0 : 16.0),) :
          index == 1 ?
            Text('Sold by', style: TextStyle(fontSize: _isTablet ? 20.0 : 16.0),):
            Text('Exchanged by', style: TextStyle(fontSize: _isTablet ? 20.0 : 16.0),),
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
                      return SoldByView(books: snapshot.data, showOnlyExchangeable: false);
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
