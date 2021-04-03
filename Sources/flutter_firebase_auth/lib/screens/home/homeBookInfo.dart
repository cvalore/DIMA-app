import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/home/homeGeneralInfoView.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:provider/provider.dart';

class HomeBookInfo extends StatefulWidget {

  final PerGenreBook book;

  const HomeBookInfo({Key key, this.book}) : super(key: key);

  @override
  _HomeBookInfoState createState() => _HomeBookInfoState();
}

class _HomeBookInfoState extends State<HomeBookInfo> {

  final sectionTitles = [
    Text('Book general info'),
    Text('Sold by'),
    Text('Exchanged by'),
  ];

  final sectionContents = [];

  DatabaseService _db;
  CustomUser user;

  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    user = CustomUser(userFromAuth.uid, userFromAuth.email, userFromAuth.isAnonymous);
    _db = DatabaseService(user: user);

    //dynamic result = _db.getGeneralBookInfo(widget.book);

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(widget.book.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            initiallyExpanded: index == 1 ? true : false,
            title: sectionTitles[index],
            children: <Widget>[
              index == 0 ?
              FutureBuilder(
                future: _db.getGeneralBookInfo(widget.book.id),
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
                  future: _db.getBookSoldBy(widget.book.id),
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
                  future: _db.getBookSoldBy(widget.book.id),
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
      ),
    );
  }
}
