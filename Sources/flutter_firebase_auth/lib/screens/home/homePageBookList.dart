import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';

class HomePageBookList extends StatelessWidget {

  final String genre;
  final List<dynamic> books;

  const HomePageBookList({Key key, @required this.genre, @required this.books}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<PerGenreBook> perGenreBooks = List<PerGenreBook>();
    for(dynamic b in books) {
      if(b != null) {
        perGenreBooks.add(
            PerGenreBook(
              id: b.keys.elementAt(0).toString(),
              title: b[b.keys.elementAt(0).toString()]["title"],
              author: b[b.keys.elementAt(0).toString()]["author"],
              thumbnail: b[b.keys.elementAt(0).toString()]["thumbnail"],
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
          height: imageHeight + 75,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            scrollDirection: Axis.horizontal,
            itemCount: perGenreBooks.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => print('Tapped'),
                child: Column(
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
                    Container(
                      width: imageWidth,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              perGenreBooks[index].title,
                              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Center(
                            child: Text(
                              perGenreBooks[index].author,
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    )
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
