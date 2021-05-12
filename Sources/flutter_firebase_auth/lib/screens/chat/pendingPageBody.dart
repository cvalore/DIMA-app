import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/viewPendingBook.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';


class PendingPageBody extends StatefulWidget {

  final DatabaseService db;
  final CustomUser user;
  List<dynamic> transactions;

  PendingPageBody({Key key, this.db, this.user, this.transactions}) : super(key: key);

  @override
  _PendingPageBodyState createState() => _PendingPageBodyState();
}

class _PendingPageBodyState extends State<PendingPageBody> {

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    widget.transactions.forEach((tr) {
      tr['exchanges'].removeWhere((ex) =>
      ex['exchangeStatus'].compareTo("pending") != 0
      );
    });
    widget.transactions.removeWhere((el) =>
    el['exchanges'] == null || el['exchanges'].length == 0
    );

    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          widget.transactions == null || widget.transactions.length == 0 ?
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('No transaction to approve yet',
                  style: TextStyle(color: Colors.white,  fontSize: _isTablet ? 20.0 : 14.0,),),
                Icon(Icons.add_alert_outlined, color: Colors.white, size: _isTablet ? 30.0 : 20.0,),
              ],
            ),
          ) :
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: _isTablet ? 20.0 : 12.0, vertical: _isTablet ? 20.0 : 12.0),
              child: ListView.builder(
                itemCount: widget.transactions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      for(int i = 0; i < widget.transactions[index]['exchanges'].length; i++)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text("You get:  "),
                                          Flexible(
                                            child: InkWell(
                                              onTap: () async {
                                                String bookId = widget.transactions[index]['exchanges'][i]['offeredBook']['id'];
                                                int bookInsertionNumber = widget.transactions[index]['exchanges'][i]['offeredBook']['insertionNumber'];
                                                dynamic bookGeneralInfo = await widget.db.getGeneralBookInfo(bookId);
                                                dynamic book = await widget.db.viewBookByIdAndInsertionNumber(bookId, bookInsertionNumber, widget.transactions[index]['buyer']);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (newContext) => ViewPendingBook(
                                                          youGet: true,
                                                          book: book,
                                                          bookGeneralInfo: bookGeneralInfo
                                                      ),
                                                    )
                                                );
                                              },
                                              child: Container(
                                                alignment: AlignmentDirectional.centerStart,
                                                height: _isTablet ? 100.0 : 50.0,
                                                child: Text(
                                                  widget.transactions[index]['exchanges'][i]['offeredBook']['title'] +
                                                      " by " + widget.transactions[index]['exchanges'][i]['offeredBook']['author'],
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text("You give: "),
                                          Flexible(
                                            child: InkWell(
                                              onTap: () async {
                                                String bookId = widget.transactions[index]['exchanges'][i]['receivedBook']['id'];
                                                int bookInsertionNumber = widget.transactions[index]['exchanges'][i]['receivedBook']['insertionNumber'];
                                                dynamic bookGeneralInfo = await widget.db.getGeneralBookInfo(bookId);
                                                dynamic book = await widget.db.viewBookByIdAndInsertionNumber(bookId, bookInsertionNumber, widget.transactions[index]['seller']);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (newContext) => ViewPendingBook(
                                                          youGet: true,
                                                          book: book,
                                                          bookGeneralInfo: bookGeneralInfo
                                                      ),
                                                    )
                                                );
                                              },
                                              child: Container(
                                                alignment: AlignmentDirectional.centerStart,
                                                height: _isTablet ? 100.0 : 50.0,
                                                child: Text(
                                                  widget.transactions[index]['exchanges'][i]['receivedBook']['title'] +
                                                      " by " + widget.transactions[index]['exchanges'][i]['receivedBook']['author'],
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var result = await DatabaseService().acceptExchange(widget.transactions[index]['id'], widget.transactions[index]['seller'],
                                        widget.transactions[index]['exchanges'][i]['receivedBook'], widget.transactions[index]['buyer'], widget.transactions[index]['exchanges'][i]['offeredBook']);
                                    if (result is String && result != 'ok') {
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.white24,
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                          result,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      );
                                      Scaffold.of(context).showSnackBar(snackBar);
                                      Timer(Duration(milliseconds: 2500), () {
                                        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                                      });
                                    }
                                    },
                                  child: Icon(Icons.check, color: Colors.green,),
                                ),
                                Container(width: _isTablet ? 50.0 : 10.0,),
                                InkWell(
                                  onTap: () async {
                                    var result = await DatabaseService().declineExchange(widget.transactions[index]['id'], widget.transactions[index]['seller'],
                                        widget.transactions[index]['exchanges'][i]['receivedBook'], widget.transactions[index]['buyer'], widget.transactions[index]['exchanges'][i]['offeredBook']);
                                    if (result is String && result != 'ok') {
                                      final snackBar = SnackBar(
                                        backgroundColor: Colors.white24,
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                          result,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                      );
                                      Scaffold.of(context).showSnackBar(snackBar);
                                      Timer(Duration(milliseconds: 2500), () {
                                        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                                      });
                                    }
                                  },
                                  child: Icon(Icons.delete_forever_outlined, color: Colors.red,),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Divider(height: 10, thickness: 2, indent: _isTablet ? 20.0 : 8.0, endIndent: _isTablet ? 20.0 : 8.0,),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,8.0),
            child: BottomTwoDots(size: 8.0, darkerIndex: 1,),
          ),
        ]
    );
  }
}
