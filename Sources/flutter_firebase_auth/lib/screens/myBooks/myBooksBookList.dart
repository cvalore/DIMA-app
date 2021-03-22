import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_auth/services/database.dart';

class MyBooksBookList extends StatelessWidget {

  final String genre;
  final List<dynamic> books;

  const MyBooksBookList({Key key, @required this.genre, @required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<PerGenreBook> perGenreBooks = List<PerGenreBook>();
    for(dynamic b in books) {
      if(b != null) {
        perGenreBooks.add(
            PerGenreBook(
              id: b["id"],
              title: b["title"],
              author: b["author"],
              thumbnail: b["thumbnail"],
            )
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            genre,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: imageHeight,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            scrollDirection: Axis.horizontal,
            itemCount: perGenreBooks.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => print('Tapped My Book - TODO: open edit'),
                child: Stack(
                  children: [
                    Container(
                      decoration: perGenreBooks[index].thumbnail != null &&
                          perGenreBooks[index].thumbnail.toString() != "" ?
                      null : BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          image: DecorationImage(
                            image: AssetImage("assets/images/no_image_available.png"),
                            //fit: BoxFit.cover,
                          )
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      height: imageHeight,
                      width: imageWidth,
                      child: perGenreBooks[index].thumbnail != null &&
                          perGenreBooks[index].thumbnail.toString() != "" ?
                      CachedNetworkImage(
                        imageUrl: perGenreBooks[index].thumbnail,
                        placeholder: (context, url) => Loading(),
                        //width: imageWidth,
                        //height: imageHeight,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: imageWidth,
                            height: imageHeight,
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  //fit: BoxFit.cover,
                                )
                            ),
                          );
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ) : Container(),
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
