import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/loading.dart';

import 'homeBookInfo.dart';

class HomePageBookList extends StatelessWidget {

  final String genre;
  final List<dynamic> books;
  bool _isTablet;

  HomePageBookList({Key key, @required this.genre, @required this.books}) : super(key: key);


  void _pushBookPage(List<PerGenreBook> perGenreBooks, int index, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newContext) =>
          HomeBookInfo(
            book: perGenreBooks[index],
          )
      )
    );
  }


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

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            genre,
            style: TextStyle(
              color: Colors.white,
              fontSize: _isTablet ? 24.0 : 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: _isTablet ? imageHeight*2 : imageHeight*1.2,
          child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: _isTablet ? 16.0 : 12.0, horizontal: 14.0),
          scrollDirection: Axis.horizontal,
          itemCount: perGenreBooks.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: _isTablet ? 12.0 : 5.0),
              child: InkWell(
                key: ValueKey("PushBookPageInkWell"),
                onTap: () {
                  _pushBookPage(perGenreBooks, index, context);
                },
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
                            fit: BoxFit.cover,
                          )
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      height: _isTablet ? imageHeight*1.4 : imageHeight*0.9,
                      width: (_isTablet ? (imageHeight*1.4) : (imageHeight*0.9)) * imageWidth/imageHeight,
                      child: perGenreBooks[index].thumbnail != null &&
                          perGenreBooks[index].thumbnail.toString() != "" ?
                      CachedNetworkImage(
                        imageUrl: perGenreBooks[index].thumbnail,
                        placeholder: (context, url) => Loading(),
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )
                            ),
                          );
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ) : Container(),
                    ),
                    Container(
                      width: (_isTablet ? (imageHeight*1.4) : (imageHeight*0.9)) * imageWidth/imageHeight,
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              perGenreBooks[index].title,
                              style: TextStyle(color: Colors.white, fontSize: _isTablet ? 23 : 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Center(
                            child: Text(
                              perGenreBooks[index].author,
                              style: TextStyle(color: Colors.white, fontSize: _isTablet ? 19 : 12, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
