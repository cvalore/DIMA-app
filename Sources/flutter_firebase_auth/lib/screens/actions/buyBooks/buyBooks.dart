import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addPaymentMethod.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addShippingInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/itemToPurchase.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

import 'chooseBooksForExchange.dart';

class BuyBooks extends StatefulWidget {

  List<InsertedBook> booksToBuy;
  String sellingUserUid;

  BuyBooks({Key key, @required this.booksToBuy, @required this.sellingUserUid});

  @override
  _BuyBooksState createState() => _BuyBooksState();
}

class _BuyBooksState extends State<BuyBooks> {

  final GlobalKey<ManuallyCloseableExpansionTileState> _shippingModeKey = GlobalKey();
  List<String> shippingModes = ['express courier', 'live dispatch'];
  String chosenShippingMode;
  bool payCash = false;
  Map<String, dynamic> shippingAddress = Map<String, dynamic>();
  Map<String, dynamic> paymentInfo = Map<String, dynamic>();

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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 10.0,
          child: Container(
            //margin: EdgeInsets.symmetric(vertical: 10.0),
            constraints: BoxConstraints(maxHeight: 60),
            child: Container(
                child: Center(
                  child: ElevatedButton(
                    child: booksDefiningTotalPrice.length == 0 ?
                      Text('Propose exchange') :
                        sellerMatchingBooksForExchange.length == 0 ?
                            Text('Pay') :
                            Text('Pay and propose exchange'),
                    onPressed: () {
                      _handleButtonClick(context);
                    },
                  ),
                )
            ),
          ),
        ),
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
              booksDefiningTotalPrice.length > 0 ? Divider(height: 5, thickness: 2,) : Container(),
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
              //booksDefiningTotalPrice.length > 0 ? Divider(height: 2, thickness: 1) : Container(),
              booksDefiningTotalPrice.length > 0 ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        'Total',
                        style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        booksDefiningTotalPrice.map((e) => e.price).reduce((value, element) => value + element).toStringAsFixed(2) + ' €',
                        style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ) : Container(),
              Divider(height: 10, thickness: 2,),
              booksForExchange.length > 0 ?
              Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 0),
                  trailing: bookExchangeTrailingIcon,
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
                      !sellerMatchingBooksForExchange.containsKey(booksForExchange[i]) ?
                      ListTileTheme(
                        tileColor: Colors.white24,
                        child: ListTile(
                          title: Container(
                              child: Text(
                                'match "${booksForExchange[i].title}"',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold)
                              )
                          ),
                          leading: Icon(Icons.add_circle_outlined),
                          onTap: () async {
                            List<dynamic> myExchangeableBooksFromDb = await Utils.databaseService.getMyExchangeableBooks();
                            print(sellerMatchingBooksForExchange.length);
                            List<dynamic> myBookIndexesAlreadyUsed = sellerMatchingBooksForExchange.length > 0 ?
                            sellerMatchingBooksForExchange.values.map((e) => e['insertionNumber']).toList() : List<int>();
                            List<int> bookIndexesToRemove = List<int>();
                            print(myBookIndexesAlreadyUsed.length);
                            print(myBookIndexesAlreadyUsed);
                            print('aaa');
                            for (int j = 0; j < myBookIndexesAlreadyUsed.length; j++){
                              print(myExchangeableBooksFromDb.length);
                              for (int k = 0; k < myExchangeableBooksFromDb.length; k++){
                                if(myBookIndexesAlreadyUsed[j] == myExchangeableBooksFromDb[k]['insertionNumber'])
                                  bookIndexesToRemove.add(k);
                              }
                            }
                            print(bookIndexesToRemove);
                            for (int j = bookIndexesToRemove.length - 1; j > -1; j--)
                              myExchangeableBooksFromDb.removeAt(bookIndexesToRemove[j]);

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
                                          child: Text('OK')),
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
                                  for (int j = 0; j < booksDefiningTotalPrice.length; j++) {
                                    if (booksDefiningTotalPrice[j].insertionNumber == booksForExchange[i].insertionNumber)
                                      booksDefiningTotalPrice.removeAt(j);
                                  }
                                  sellerMatchingBooksForExchange[booksForExchange[i]] = result;
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
                                int removedBookInsertionNumber = booksForExchange[i].insertionNumber;
                                for(int j = 0; j < widget.booksToBuy.length; j++){
                                  if(widget.booksToBuy[j].insertionNumber == removedBookInsertionNumber)
                                    booksDefiningTotalPrice.add(widget.booksToBuy[j]);
                                }
                                sellerMatchingBooksForExchange.remove(booksForExchange[i]);
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
                                        child: Text('OK')),
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
                                if (chosenShippingMode == 'express courier') payCash = false;
                                _shippingModeKey.currentState.collapse();
                              });
                            },
                          ),
                      ]
                  ),
                ),
              ),
              ListTileTheme(
                contentPadding: EdgeInsets.all(0.0),
                child: ListTile(
                  enabled: chosenShippingMode != null && chosenShippingMode == 'express courier',
                  title: Text(
                      'Add shipping address',
                      style: Theme.of(context).textTheme.headline6
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        AddShippingInfo(info: shippingAddress)));
                    if (result != null)
                      shippingAddress = result;
                  },
                ),
              ),
              Divider(height: 5, thickness: 2),
              ListTileTheme(
                contentPadding: EdgeInsets.all(0.0),
                child: ListTile(
                  enabled: booksDefiningTotalPrice.length > 0 && chosenShippingMode != null && chosenShippingMode != 'express courier',
                  title: Text(
                      'Pay cash',
                      style: Theme.of(context).textTheme.headline6
                  ),
                  trailing: booksDefiningTotalPrice.length > 0 && payCash ? Icon(Icons.check_box_outlined) : Icon(Icons.check_box_outline_blank_outlined),
                  onTap: () async {
                    setState(() {
                      payCash = !payCash;
                    });
                  },
                ),
              ),
              ListTileTheme(
                contentPadding: EdgeInsets.all(0.0),
                child: ListTile(
                  enabled: booksDefiningTotalPrice.length > 0 && (chosenShippingMode == 'express courier' || payCash == false),
                  title: Text(
                      'Add payment method',
                      style: Theme.of(context).textTheme.headline6
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        AddPaymentMethod(info: paymentInfo)));
                    if (result != null)
                      paymentInfo = result;
                  },
                ),
              ),
              Divider(height: 5, thickness: 2)
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

  void _handleButtonClick(BuildContext context) {
    if (chosenShippingMode == null){
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => AlertDialog(
            content: Text('You need to specify a valid shipping mode'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          )
      );
    } else if (chosenShippingMode == 'express courier' && shippingAddress.length == 0){
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => AlertDialog(
            content: Text('You need to specify a shipping address associated with this purchase'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          )
      );
    } else if (payCash == false && booksDefiningTotalPrice.length > 0) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => AlertDialog(
            content: Text('You need to specify a valid payment method'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          )
      );
    } else {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => AlertDialog(
            content: Text('Do you confirm your choice?'),
            actions: [
              FlatButton(
                  onPressed: () async {
                    await Utils.databaseService.purchaseAndProposeExchange(widget.sellingUserUid, chosenShippingMode, shippingAddress, payCash, booksDefiningTotalPrice, sellerMatchingBooksForExchange);
                    Navigator.pop(context);
                    //Navigator.pop(context);
                  },
                  child: Text('YES')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('NO')),
            ],
          )
      );
    }
  }
}