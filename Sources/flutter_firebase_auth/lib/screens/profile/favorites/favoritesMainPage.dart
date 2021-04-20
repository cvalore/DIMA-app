import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class FavoritesMainPage extends StatefulWidget {

  List<dynamic> likedBooks;

  FavoritesMainPage({Key key, @required this.likedBooks});

  @override
  _FavoritesMainPageState createState() => _FavoritesMainPageState();
}

class _FavoritesMainPageState extends State<FavoritesMainPage> {

  //bool selectionModeOn = false;
  bool loading = false;


  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery
        .of(context)
        .size
        .width > mobileMaxWidth;

    return  loading ? Loading() :
    Scaffold(
      appBar: AppBar(
        title: Text('My favorites'),
        /*
        actions: [
          PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_outlined),
              onSelected: (value) {
                switch (value) {
                  case 'Select items':
                    setState(() {
                      selectionModeOn = true;
                    });
                    break;
                  case 'Deselect items':
                    setState(() {
                      selectionModeOn = false;
                    });
                    break;
                  default:
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                selectionModeOn == true ?
                const PopupMenuItem(
                    value: 'Deselect items',
                    child: Text('Deselect items'))
                : const PopupMenuItem(
                    value: 'Select items',
                    child: Text('Select items'))
              ]
          )
        ],
         */
      ),
      /*
      floatingActionButton: selectionModeOn ? FloatingActionButton.extended(
          label: Text('Remove like'),
          onPressed: () {
            //method removing likes from db
          },
          ) : null,
       */
      body: widget.likedBooks != null && widget.likedBooks.length != 0 ?
        GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.symmetric(vertical: 36.0 * (_isTablet ? 3 : 1),
            horizontal: 24.0 * (_isTablet ? 5 : 1)),
        //2// columns
        mainAxisSpacing: 36.0 * (_isTablet ? 2.5 : 1),
        crossAxisSpacing: 36.0 * (_isTablet ? 4.5 : 1),
        scrollDirection: Axis.vertical,
        childAspectRatio: imageWidth / (imageHeight * 1.1),
        children:
          widget.likedBooks.map((book) {
            return InkWell(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                await Utils.pushBookPage(context, book, book['uid']);
                setState(() {
                  loading = false;
                });
              },
              child: Card(
                  elevation: 0.0,
                  color: Colors.transparent,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          image: DecorationImage(
                            image: (book['imagesUrl'] != null && book['imagesUrl'].length > 0) ?
                                    NetworkImage(book['imagesUrl'][0]) :
                                    book['thumbnail'] != null && book['thumbnail'].toString() != "" ?
                                    NetworkImage(book['imagesUrl'][0]) :
                                    AssetImage("assets/images/no_image_available.png"),
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                book["title"],
                                style: TextStyle(color: Colors.white, fontSize: _isTablet ? 24 : 17, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                book["author"],
                                style: TextStyle(color: Colors.white, fontSize: _isTablet ? 20 : 15, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
              )
              ),
            );
          }).toList(),
        ) : Container(child: Text('Add all your favorite books here!'))
    );
  }
}