import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';

class ItemToPurchase extends StatelessWidget {

  InsertedBook book;
  String thumbnail;
  bool isLast;

  ItemToPurchase({Key key, @required this.book,@required this.thumbnail, @required this.isLast});

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;


    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.2,
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius : BorderRadius.circular(8.0),
                    child: book.imagesPath != null && book.imagesPath.length > 0 ?
                    Image.file(
                        File(book.imagesPath[0])
                    ) : thumbnail != null && thumbnail != '' ?
                        Image.network(thumbnail) :
                        Image.asset("assets/images/no_image_available.png"),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * (_isPortrait ? 0.2 : 0.25),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  //decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          book.title,
                          style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Center(
                        child: Text(
                          'by',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          book.author.substring(1, book.author.length-1),
                          style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          isLast ? Container() : Divider(height: 3.0, thickness: 1.0)
        ],
      ),
    );
  }
}

