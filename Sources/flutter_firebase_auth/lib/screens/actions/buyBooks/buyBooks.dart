import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/itemToPurchase.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

import 'chooseBooksForExchange.dart';

class BuyBooks extends StatefulWidget {

  List<InsertedBook> booksToBuy;

  BuyBooks({Key key, @required this.booksToBuy});

  @override
  _BuyBooksState createState() => _BuyBooksState();
}

class _BuyBooksState extends State<BuyBooks> {

  final GlobalKey<ManuallyCloseableExpansionTileState> _shippingModeKey = GlobalKey();
  List<String> shippingModes = ['express courier', 'live dispatch'];
  String chosenShippingMode;

  Widget bookExchangeTrailingIcon = Icon(Icons.keyboard_arrow_right, color: Colors.white);
  Widget shippingModeTrailingIcon = Icon(Icons.keyboard_arrow_right, color: Colors.white);

  List<InsertedBook> booksDefiningTotalPrice = List<InsertedBook>();
  List<InsertedBook> booksForExchange = List<InsertedBook>();
  Map<InsertedBook, Map<String, dynamic>> sellerMatchingBooksForExchange = Map<InsertedBook, Map<String, dynamic>>();
  
  @override
  void initState() {
    for (int i = 0; i < widget.booksToBuy.length; i++){
      booksDefiningTotalPrice.add(widget.booksToBuy[i]);
      if (widget.booksToBuy[i].exchangeable) {
        booksForExchange.add(widget.booksToBuy[i]);
        sellerMatchingBooksForExchange[widget.booksToBuy[i]] = null;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

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
              for (int i = 0; i < booksDefiningTotalPrice.length; i++)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  //decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          booksDefiningTotalPrice[i].title,
                          style: Theme.of(context).textTheme.headline6,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          booksDefiningTotalPrice[i].price.toStringAsFixed(2) + ' €',
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.end,

                        ),
                      ),
                    ],
                  ),
                ),
              Divider(height: 5, thickness: 2,),
              booksForExchange.length > 0 ?
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 0),
                  trailing: bookExchangeTrailingIcon,
                  //maintainState: true,
                  onExpansionChanged: (bool open) {
                    if(open) {
                      setState(() {
                        bookExchangeTrailingIcon = Icon(Icons.keyboard_arrow_down, color: Colors.white);
                      });
                    }
                    else {
                      setState(() {
                        bookExchangeTrailingIcon = Icon(Icons.keyboard_arrow_right, color: Colors.white);
                      });
                    }
                  },
                  title: Text('Books for exchange',
                    style: Theme.of(context).textTheme.headline6
                  ),
                  children: <Widget>[
                    //only if exchangeable still available
                    for (int i = 0; i < booksForExchange.length; i++)
                      sellerMatchingBooksForExchange[booksForExchange[i]] == null ?
                    ListTileTheme(
                      tileColor: Colors.white24,
                      child: ListTile(
                        title: Row(
                          children: [
                            Text('match '),
                            Text('"${booksForExchange[i].title}"', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        leading: Icon(Icons.add_circle_outlined),
                        onTap: () async {
                          List<dynamic> myExchangeableBooksFromDb = await Utils.databaseService.getMyExchangeableBooks();
                          if (myExchangeableBooksFromDb.length == 0){
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('You have no available books for exchange'),
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok')),
                                  ],
                                )
                            );
                          } else {
                            List<dynamic> myExchangeableBooks = List<dynamic>();
                            for (int j = 0; j < myExchangeableBooksFromDb.length; j++) {
                              var book = await insertedBookFromMap(myExchangeableBooksFromDb[j]);
                              myExchangeableBooks.add(book);
                            }
                            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                ChooseBooksForExchange(myExchangeableBooks: myExchangeableBooks)
                            ));

                            setState(() {
                              if (result != null) {
                                for (int j = 0; j <
                                    booksDefiningTotalPrice.length; j++) {
                                  if (booksDefiningTotalPrice[i]
                                      .insertionNumber ==
                                      result['insertionNumber'])
                                    booksDefiningTotalPrice.removeAt(j);
                                }
                                sellerMatchingBooksForExchange[booksForExchange[i]] =
                                    result;
                              }//continue here
                            });
                          }
                        },
                      ),
                    ) : ListTileTheme(
                        tileColor: Colors.white38,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'You get: ',
                                        style: Theme.of(context).textTheme.bodyText2.copyWith(fontStyle: FontStyle.italic)
                                    ),
                                    Text(
                                      'You give: ',
                                       style: Theme.of(context).textTheme.bodyText2.copyWith(fontStyle: FontStyle.italic)
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        booksForExchange[i].title,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold)
                                    ),
                                    Text(
                                        sellerMatchingBooksForExchange[booksForExchange[i]]['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              setState(() {
                                int removedBookInsertionNumber = sellerMatchingBooksForExchange[booksForExchange[i]]['insertionNumber'];
                                for(int j = 0; j < widget.booksToBuy.length; j++){
                                  if(widget.booksToBuy[j].insertionNumber == removedBookInsertionNumber)
                                    booksDefiningTotalPrice.add(widget.booksToBuy[j]);
                                }
                                sellerMatchingBooksForExchange[booksForExchange[i]] = null;
                              });
                            },
                          ),
                          onTap: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Exchange proposed:\n'),
                                      Text(
                                          booksForExchange[i].title,
                                          style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold)
                                      ),
                                      Text('for'),
                                      Text(
                                          sellerMatchingBooksForExchange[booksForExchange[i]]['title'],
                                          style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold)
                                      )
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Ok')),
                                  ],
                                )
                            );
                          },
                        ),
                    ),
                    ],
                  ),
                ) : Container(),
              booksForExchange.length > 0 ? Divider(height: 5, thickness: 2,) : Container(),
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ListTileTheme(
                  contentPadding: EdgeInsets.all(0.0),
                  child: ManuallyCloseableExpansionTile(
                    key: _shippingModeKey,
                    initiallyExpanded: false,

                    //tilePadding: const EdgeInsets.symmetric(horizontal: 0),
                    trailing: shippingModeTrailingIcon,
                    //maintainState: true,
                    onExpansionChanged: (bool open) {
                      if(open) {
                        setState(() {
                          shippingModeTrailingIcon = Icon(Icons.keyboard_arrow_down, color: Colors.white);
                        });
                      }
                      else {
                        setState(() {
                          shippingModeTrailingIcon = Icon(Icons.keyboard_arrow_right, color: Colors.white);
                        });
                      }
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping mode',
                            style: Theme.of(context).textTheme.headline6
                        ),
                        chosenShippingMode != null ? Text(chosenShippingMode,
                            style: Theme.of(context).textTheme.bodyText2
                        ) : Container()
                      ],
                    ),
                    children: <Widget>[
                      for(int i = 0; i < shippingModes.length; i++)
                        RadioListTile(
                          activeColor: Colors.white,
                          title: Text(shippingModes[i], style: TextStyle(color: Colors.white),),
                          value: shippingModes[i],
                          controlAffinity: ListTileControlAffinity.trailing,
                          groupValue: chosenShippingMode,
                          onChanged: (value) {
                            setState(() {
                              chosenShippingMode = value;
                              _shippingModeKey.currentState.collapse();
                            });
                          },
                        ),
                     ]
                  ),
                ),
              ),
              Divider(height: 5, thickness: 2),
              chosenShippingMode == 'express courier' ?
                  ListTileTheme(
                    contentPadding: EdgeInsets.all(0.0),
                    child: ListTile(
                      title: Text(
                        'Add shipping address',
                        style: Theme.of(context).textTheme.headline6
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                  ) : Container(),
              chosenShippingMode == 'express courier' ? Divider(height: 5, thickness: 2,) : Container(),
              ListTileTheme(
                contentPadding: EdgeInsets.all(0.0),
                child: ListTile(
                  title: Text(
                      'Add payment method',
                      style: Theme.of(context).textTheme.headline6
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
              Divider(height: 5, thickness: 2),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> insertedBookFromMap(Map<String, dynamic> book) async {
    InsertedBook bookToPush = InsertedBook(
      title: book['title'],
      insertionNumber: book['insertionNumber'],
    );
    Reference bookRef = DatabaseService().storageService.getBookDirectoryReference(Utils.mySelf.uid, bookToPush);
    ListResult lr = await bookRef.listAll();
    for(Reference r in lr.items) {
      try {
        String filePath = await DatabaseService().storageService.toDownloadFile(r, 0);
        if(filePath != null) {
          book['imagePath'] = filePath;
        }
      } on FirebaseException catch (e) {
        e.toString();
      }
      break;
    }
    return book;
  }
}