import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/viewPendingBook.dart';
import 'package:flutter_firebase_auth/screens/home/homeGeneralInfoView.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:provider/provider.dart';

class PendingPageBody extends StatelessWidget {

  final DatabaseService db;
  final CustomUser user;
  dynamic transactions;

  PendingPageBody({Key key, this.db, this.user, this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //Chat chat = Provider.of<Chat>(context);

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    transactions.forEach((tr) {
      tr['exchanges'].removeWhere((ex) =>
      ex['exchangeStatus'].compareTo("pending") != 0
      );
    });
    transactions.removeWhere((el) =>
      el['exchanges'] == null || el['exchanges'].length == 0
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        transactions == null || transactions.length == 0 ?
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
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    for(int i = 0; i < transactions[index]['exchanges'].length; i++)
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
                                              String bookId = transactions[index]['exchanges'][i]['offeredBook']['id'];
                                              int bookInsertionNumber = transactions[index]['exchanges'][i]['offeredBook']['insertionNumber'];
                                              dynamic bookGeneralInfo = await db.getGeneralBookInfo(bookId);
                                              dynamic book = await db.viewBookByIdAndInsertionNumber(bookId, bookInsertionNumber, transactions[index]['buyer']);
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
                                                  transactions[index]['exchanges'][i]['offeredBook']['title'] +
                                                   " by " + transactions[index]['exchanges'][i]['offeredBook']['author'],
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
                                              String bookId = transactions[index]['exchanges'][i]['receivedBook']['id'];
                                              int bookInsertionNumber = transactions[index]['exchanges'][i]['receivedBook']['insertionNumber'];
                                              dynamic bookGeneralInfo = await db.getGeneralBookInfo(bookId);
                                              dynamic book = await db.viewBookByIdAndInsertionNumber(bookId, bookInsertionNumber, transactions[index]['seller']);
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
                                                transactions[index]['exchanges'][i]['receivedBook']['title'] +
                                                    " by " + transactions[index]['exchanges'][i]['receivedBook']['author'],
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
                                onTap: () {
                                  print("TODO: Exchanged accepted");
                                },
                                child: Icon(Icons.check, color: Colors.green,),
                              ),
                              Container(width: _isTablet ? 50.0 : 10.0,),
                              InkWell(
                                onTap: () {
                                  print("TODO: Exchanged declined");
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
