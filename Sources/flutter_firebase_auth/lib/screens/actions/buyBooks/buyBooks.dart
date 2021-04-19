import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

import 'chooseBooksForExchange.dart';

class BuyBooks extends StatefulWidget {

  List<InsertedBook> booksToBuy;

  BuyBooks({Key key, @required this.booksToBuy});

  @override
  _BuyBooksState createState() => _BuyBooksState();
}

class _BuyBooksState extends State<BuyBooks> {

  Widget trailingIconComment = Icon(Icons.keyboard_arrow_right, color: Colors.white);

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;
    List<String> sellerMatchingBooksForExchange = List<String>();
    List<String> myMatchingBooksForExchange = List<String>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,// - appBarHeight,
        padding: EdgeInsets.fromLTRB(_isTablet ? 100.0 : 20.0, 0.0, _isTablet ? 100.0 : 20.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: _isTablet ? MainAxisAlignment.center : MainAxisAlignment.end,
            children: [
              for (int i = 0; i < widget.booksToBuy.length; i++)
                ItemToPurchase(book: widget.booksToBuy[i], isLast: i == widget.booksToBuy.length - 1),
              Divider(height: 5, thickness: 2,),
              for (int i = 0; i < widget.booksToBuy.length; i++)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  //decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.booksToBuy.length == 1 ? 'Price' : 'Price ${i+1}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        widget.booksToBuy[i].price.toStringAsFixed(2) + ' €',
                        style: Theme.of(context).textTheme.headline6
                      ),
                    ],
                  ),
                ),
              Divider(height: 5, thickness: 2,),
              widget.booksToBuy.map((e) => e.exchangeable == true ? 1 : 0).reduce((value, element) => value + element) > 0 ?
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 0),
                  trailing: trailingIconComment,
                  //maintainState: true,
                  onExpansionChanged: (bool open) {
                    if(open) {
                      setState(() {
                        trailingIconComment = Icon(Icons.keyboard_arrow_down, color: Colors.white);
                      });
                    }
                    else {
                      setState(() {
                        trailingIconComment = Icon(Icons.keyboard_arrow_right, color: Colors.white);
                      });
                    }
                  },
                  title: Text('Select books for exchange',
                    style: Theme.of(context).textTheme.headline6
                  ),
                  children: <Widget>[
                    //only if exchangeable still available
                    ListTileTheme(
                      tileColor: Colors.white24,
                      child: ListTile(
                        title: Text('Match new books to exchange'),
                        leading: Icon(Icons.add_circle_outlined),
                        onTap: () async {
                          var result = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  ChooseBooksForExchange(booksToExchange: widget.booksToBuy)
                              )
                          );
                        },
                      ),
                    ),
                    for (int i = 0; i < sellerMatchingBooksForExchange.length; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(sellerMatchingBooksForExchange[i], overflow: TextOverflow.ellipsis),
                          Text('FOR'),
                          Text(myMatchingBooksForExchange[i], overflow: TextOverflow.ellipsis),
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              sellerMatchingBooksForExchange.removeAt(i);
                              myMatchingBooksForExchange.removeAt(i);
                            },
                          )
                        ],
                      )
                  ],
                ),
              ) : Container(),
              Divider(height: 5, thickness: 2,),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}


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
                    child: Image.file(
                        File(book.imagesPath[0])
                    ),
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

