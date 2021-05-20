import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/status.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/manuallyCloseableExpansionTile.dart';



class ViewExchangedItemPage extends StatefulWidget {

  InsertedBook receivedBook;
  InsertedBook offeredBook;
  Map<String, dynamic> transactionsInfo;
  String type;

  ViewExchangedItemPage({Key key, @required this.receivedBook, @required this.offeredBook, @required this.transactionsInfo, @required this.type});
  @override
  _ViewExchangedItemPageState createState() => _ViewExchangedItemPageState();
}

class _ViewExchangedItemPageState extends State<ViewExchangedItemPage> {
  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Exchanged book',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,// - appBarHeight,
        padding: EdgeInsets.fromLTRB(_isTablet ? 150.0 : 20.0, _isTablet ? 40.0 : 0.0, _isTablet ? 150.0 : 20.0, _isTablet ? 40.0 : 0.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: _isTablet ? MainAxisAlignment.center : MainAxisAlignment.end,
            children: [
              ListTileTheme(
                contentPadding:  EdgeInsets.all(0.0),
                child: ManuallyCloseableExpansionTile(
                  title: Text('Offered book'),
                  initiallyExpanded: false,
                  children: [
                    ImageService(insertedBook: widget.offeredBook, justView: true),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Title",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 10,
                              child: Text(widget.offeredBook.title,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Author",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 10,
                              child: Text(widget.offeredBook.author.substring(1, widget.offeredBook.author.length - 1),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Status(insertedBook: widget.offeredBook, height: 50, offset: 50.0, justView: true),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Category",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 10,
                              child: Text(widget.offeredBook.category,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTileTheme(
                contentPadding:  EdgeInsets.all(0.0),
                child: ManuallyCloseableExpansionTile(
                  title: Text(widget.type == 'Accepted' ? 'Received book' : 'Requested book'),
                  initiallyExpanded: true,
                  children: [
                    ImageService(insertedBook: widget.receivedBook, justView: true),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Title",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 10,
                              child: Text(widget.receivedBook.title,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Author",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 10,
                              child: Text(widget.receivedBook.author.substring(1, widget.receivedBook.author.length - 1),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Status(insertedBook: widget.receivedBook, height: 50, offset: 50.0, justView: true),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Category",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 10,
                              child: Text(widget.receivedBook.category,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTileTheme(
                contentPadding:  EdgeInsets.all(0.0),
                child: ManuallyCloseableExpansionTile(
                  title: Text('Transaction\'s info'),
                  initiallyExpanded: true,
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Seller",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 10,
                              child: Text(widget.transactionsInfo['sellerUsername'],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Shipping Mode",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(widget.transactionsInfo['chosenShippingMode'],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ),
                    Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
                    widget.transactionsInfo['shippingAddress'] != null ? Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Shipping address",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(widget.transactionsInfo['shippingAddress']['address 1'],
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ) : Container(),
                    widget.transactionsInfo['shippingAddress'] != null ? Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,) : Container(),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Exchange proposed on",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(
                                  "${widget.transactionsInfo['time'].toDate().year}-${widget.transactionsInfo['time'].toDate().month}-${widget.transactionsInfo['time'].toDate().day}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: Colors.white)
                              )
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
