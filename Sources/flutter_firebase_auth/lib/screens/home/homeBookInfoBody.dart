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

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return
      _isPortrait ?
      ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          initiallyExpanded: index == 1 ? true : false,
          tilePadding: EdgeInsets.symmetric(horizontal: _isTablet ? 32.0 : 12.0, vertical: _isTablet ? 12.0 : 0.0),
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
                      return SoldByView(books: snapshot.data, showOnlyExchangeable: false, fromPending: false,);
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
                      return SoldByView(books: snapshot.data, showOnlyExchangeable: true, fromPending: false,);
                }
              },
            )
            )
          ]
        );
      },
    ) :
      Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: _isTablet ? 30.0 : 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width/2.5,
              height: MediaQuery.of(context).size.height,
              //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              child: Column(
                children: <Widget>[
                  Text("Book general info", style: TextStyle(fontSize: _isTablet ? 20.0 : 16.0, fontWeight: FontWeight.bold),),
                  Container(
                    height: MediaQuery.of(context).size.height - 140,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
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
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: 1.5*MediaQuery.of(context).size.width/2.5,
            height: MediaQuery.of(context).size.height,
            //decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                    initiallyExpanded: index == 0 ? true : false,
                    tilePadding: EdgeInsets.symmetric(horizontal: _isTablet ? 32.0 : 12.0, vertical: _isTablet ? 12.0 : 0.0),
                    title:
                    index == 0 ?
                    Text('Sold by', style: TextStyle(fontSize: _isTablet ? 20.0 : 16.0),):
                    Text('Exchanged by', style: TextStyle(fontSize: _isTablet ? 20.0 : 16.0),),
                    children: <Widget>[
                      index == 0 ?
                      FutureBuilder(
                        future: db.getBookSoldBy(book.id),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting: return Text('Loading....');
                            default:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else
                                return SoldByView(books: snapshot.data, showOnlyExchangeable: false, fromPending: false,);
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
                                return SoldByView(books: snapshot.data, showOnlyExchangeable: true, fromPending: false,);
                          }
                        },
                      )
                    ]
                );
              },
            ),
          ),
        ],
      );
  }
}
