import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class HomePageBookList extends StatelessWidget {

  final String genre;
  final List<PerGenreBook> books;

  const HomePageBookList({Key key, @required this.genre, @required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            genre,
            style: TextStyle(
              color: Colors.blueGrey[700],
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 165.0,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => print('Tapped'),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      height: 130.0,
                      width: 130.0,
                      child: CachedNetworkImage(
                        imageUrl: "http://books.google.com/books/content?id=k_eWzQEACAAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
                        placeholder: (context, url) => Loading(),
                        width: imageWidth,
                        height: imageHeight,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
