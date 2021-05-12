import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/category.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/price.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/status.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';

class ViewBoughtItemPage extends StatefulWidget {

  InsertedBook boughtBook;
  Map<String, dynamic> transactionsInfo;

  ViewBoughtItemPage({Key key, @required this.boughtBook, @required this.transactionsInfo});

  @override
  _ViewBoughtItemPageState createState() => _ViewBoughtItemPageState();
}

class _ViewBoughtItemPageState extends State<ViewBoughtItemPage> {
  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text('Bought book',
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
              ImageService(insertedBook: widget.boughtBook, justView: true),
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
                        child: Text(widget.boughtBook.title,
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
                        child: Text(widget.boughtBook.author.substring(1, widget.boughtBook.author.length - 1),
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.white)
                        )
                    )
                  ],
                ),
              ),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Status(insertedBook: widget.boughtBook, height: 50, offset: 50.0, justView: true),
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
                        child: Text(widget.boughtBook.category,
                            textAlign: TextAlign.right,
                            style: TextStyle(color: Colors.white)
                        )
                    )
                  ],
                ),
              ),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
              Price(insertedBook: widget.boughtBook, height: 50, justView: true,),
              Divider(height: _isTablet ? 40.0 : 5.0, thickness: 2,),
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
              Container(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Pay cash",
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
                        flex: 1,
                        child: widget.transactionsInfo['payCash'] ?
                        Icon(Icons.check_box_outlined, color: Colors.white) :
                        Icon(Icons.check_box_outline_blank, color: Colors.white)
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
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Date of purchase",
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
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}
