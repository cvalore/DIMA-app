import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class ChooseBooksForExchange extends StatefulWidget {

  List<dynamic> myExchangeableBooks;

  ChooseBooksForExchange({Key key, @required this.myExchangeableBooks});

  @override
  _ChooseBooksForExchangeState createState() => _ChooseBooksForExchangeState();
}

class _ChooseBooksForExchangeState extends State<ChooseBooksForExchange> {

  @override
  Widget build(BuildContext context) {


    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tap on book to exchange'),
      ),
      body: GridView.count(
        crossAxisCount: _isPortrait ? 2 : 5,
        padding: EdgeInsets.symmetric(vertical: 36.0 * (_isTablet ? 3 : 1),
            horizontal: 24.0 * (_isTablet ? 5 : 1)),
        //2// columns
        mainAxisSpacing: 36.0 * (_isTablet ? 2.5 : 1),
        crossAxisSpacing: 36.0 * (_isTablet ? 4.5 : 1),
        scrollDirection: Axis.vertical,
        childAspectRatio: imageWidth / (imageHeight * 1.1),
        children:
        widget.myExchangeableBooks.map((book) {
          return InkWell(
            onTap: () async {
              Navigator.pop(context, book);
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
                            borderRadius: BorderRadius.all(
                                Radius.circular(4.0)),
                            image: DecorationImage(
                              image: book['imagePath'] != null ?
                                  FileImage(File(book['imagePath'])) :
                                  book['thumbnail'] != null && book['thumbnail'].toString() != '' ?
                                  NetworkImage(book['thumbnail']) : AssetImage(
                                  "assets/images/no_image_available.png"),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              book["title"],
                              style: TextStyle(color: Colors.white,
                                  fontSize: _isTablet ? 24 : 17,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Center(
                            child: Text(
                              book["author"],
                              style: TextStyle(color: Colors.white,
                                  fontSize: _isTablet ? 20 : 15,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
            ),
          );
        }).toList(),
      ),
    );
  }
}

        /*
      ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.white,
              indent: _isTablet ? 150.0 : 15.0,
              endIndent: _isTablet ? 150.0 : 15.0,
            );
          },
          itemCount: widget.booksToExchange.length,
          itemBuilder: (context, index) {
            final book = widget.booksToExchange[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: _isTablet ? 150.0 : 0.0),
              child: RadioListTile(
                activeColor: Colors.white,
                title: Text(genre, style: TextStyle(color: Colors.white),),
                value: genre,
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: chosenGenre,
                onChanged: (value) {
                  setState(() {
                    chosenGenre = value;
                  });
                  Navigator.pop(context, chosenGenre);
                },
              ),
            );
          }
      ),*/
