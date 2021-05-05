import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/itemToPurchase.dart';
import 'package:flutter_firebase_auth/screens/chat/chatPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

import 'addPaymentMethod.dart';
import 'addShippingInfo.dart';
import 'chooseBooksForExchange.dart';

class BuyBooks extends StatefulWidget {

  List<InsertedBook> booksToBuy;
  Map<int, String> thumbnails;
  String sellingUserUid;
  Map<String, List<dynamic>> purchaseInfo;

  BuyBooks({Key key, @required this.booksToBuy, @required this.thumbnails, @required this.sellingUserUid, @required this.purchaseInfo});

  @override
  _BuyBooksState createState() => _BuyBooksState();
}

class _BuyBooksState extends State<BuyBooks> {

  final GlobalKey<ManuallyCloseableExpansionTileState> _shippingModeKey = GlobalKey();
  List<String> shippingModes = ['express courier', 'live dispatch'];
  List<dynamic> shippingAddresses;
  List<dynamic> paymentCards;
  String chosenShippingMode;
  bool payCash = false;
  Map<String, dynamic> chosenShippingAddress;
  Map<String, dynamic> chosenPaymentCard;

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
    shippingAddresses = widget.purchaseInfo['shippingAddressInfo'];
    paymentCards = widget.purchaseInfo['paymentCardInfo'];
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase'),
        actions: [
          Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  child: booksDefiningTotalPrice.length == 0 ?
                  Text('Exchange') :
                  sellerMatchingBooksForExchange.length == 0 ?
                  Text('Pay') :
                  Text('Pay and exchange'),
                  onPressed: () {
                    _handleButtonClick(context);
                  },
                );
              }
          ),
        ],
      ),
      /*bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 10.0,
          child: Container(
            //margin: EdgeInsets.symmetric(vertical: 10.0),
            constraints: BoxConstraints(maxHeight: 60),
            child: Container(
                child: Center(
                  child: Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        child: booksDefiningTotalPrice.length == 0 ?
                        Text('Propose exchange') :
                        sellerMatchingBooksForExchange.length == 0 ?
                        Text('Pay') :
                        Text('Pay and propose exchange'),
                        onPressed: () {
                          _handleButtonClick(context);
                        },
                      );
                    }
                  ),
                )
            ),
          ),
        ),
      ),*/
      body: Container(
        height: MediaQuery.of(context).size.height,// - appBarHeight,
        padding: EdgeInsets.fromLTRB(_isTablet ? 100.0 : 20.0, 0.0, _isTablet ? 100.0 : 20.0, 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: _isTablet ? MainAxisAlignment.center : MainAxisAlignment.end,
            children: [
              for (int i = 0; i < widget.booksToBuy.length; i++)
                ItemToPurchase(book: widget.booksToBuy[i], thumbnail: widget.thumbnails[widget.booksToBuy[i].insertionNumber], isLast: i == widget.booksToBuy.length - 1),
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
                            for (int j = 0; j < myBookIndexesAlreadyUsed.length; j++){
                              print(myExchangeableBooksFromDb.length);
                              for (int k = 0; k < myExchangeableBooksFromDb.length; k++){
                                if(myBookIndexesAlreadyUsed[j] == myExchangeableBooksFromDb[k]['insertionNumber'])
                                  bookIndexesToRemove.add(k);
                              }
                            }
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
                                if (chosenShippingMode == 'live dispatch') payCash = true;
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
                        AddShippingInfo(savedShippingAddress: shippingAddresses, currentShippingAddress: chosenShippingAddress,)));
                    if (result != null){
                      shippingAddresses = result[0];
                      chosenShippingAddress = result[1];
                    }
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
                  trailing: booksDefiningTotalPrice.length > 0 && payCash ? Icon(Icons.check_outlined, color: Colors.green) : Icon(Icons.clear_outlined, color: Colors.red,),
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
                        AddPaymentMethod(savedPaymentMethods: paymentCards, currentPaymentMethod: chosenPaymentCard)));
                    if (result != null){
                      paymentCards = result[0];
                      chosenPaymentCard = result[1];
                    }
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
    bool transactionCompleted = false;
    dynamic chat;
    dynamic sellerUsername;
    String message;
    String myUsername;
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
    } else if (chosenShippingMode == 'express courier' && chosenShippingAddress.length == 0){
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
    } else if (payCash == false && booksDefiningTotalPrice.length > 0 && chosenPaymentCard == null) {
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
                    sellerUsername = await Utils.databaseService.purchaseAndProposeExchange(widget.sellingUserUid, chosenShippingMode, chosenShippingAddress, payCash, booksDefiningTotalPrice, sellerMatchingBooksForExchange, widget.thumbnails);
                    if (sellerUsername != null) {
                      print('username diverso da null');
                      if (sellerUsername is List<String>) {
                        transactionCompleted = true;
                        CustomUser me = await Utils.databaseService.getUserById(Utils.mySelf.uid);
                        myUsername = me.username;
                        chat = await Utils.databaseService.createNewChat(
                            Utils.mySelf.uid, widget.sellingUserUid, myUsername, sellerUsername[0]);
                        print('chat creata');
                      } else {
                        print('error');
                        //TODO
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Text('YES')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('NO')),
            ],
          )
      ).then((value) {
        if (transactionCompleted) {
          final snackBar = SnackBar(
            backgroundColor: Colors.white24.withOpacity(0.2),
            duration: Duration(seconds: 2),
            content: Text(
              'The transaction completed successfully',
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyText2,
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
          Timer(Duration(milliseconds: 2500), () async {
            //Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
            if (chat != null && (payCash || (sellerMatchingBooksForExchange != null && sellerMatchingBooksForExchange.length > 0))) {
              message = Utils.buildDefaultMessage(
                  sellerUsername[0], booksDefiningTotalPrice,
                  sellerMatchingBooksForExchange);
              await Utils.databaseService.addMessageToChat(
                  message, Utils.toChat(chat),
                  CustomUser(Utils.mySelf.uid, username: myUsername));
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) => ChatPage(chat: Utils.toChat(chat))),
                  ModalRoute.withName(Navigator.defaultRouteName));
            } else {
              Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
            }
            });
        } else {
          //TODO stampare a schermo l'errore
        }
      }
      );
    }
  }
}