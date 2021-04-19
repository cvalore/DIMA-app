import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';

class ItemToPurchase extends StatelessWidget {

  InsertedBook book;
  bool isLast;

  ItemToPurchase({Key key, @required this.book, @required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius : BorderRadius.circular(8.0),
                    child: book.imagesPath != null && book.imagesPath.length > 0 ?
                    Image.file(
                        File(book.imagesPath[0])
                    ) : Image.asset("assets/images/no_image_available.png"),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  //decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'by',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontStyle: FontStyle.italic
                        ),
                      ),
                      Text(
                        book.author.substring(1, book.author.length-1),
                        style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
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

