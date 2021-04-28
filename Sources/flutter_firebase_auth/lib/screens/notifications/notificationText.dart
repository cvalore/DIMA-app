import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/viewPendingBook.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:toast/toast.dart';

class NotificationText extends StatelessWidget {

  final dynamic transaction;
  final Timestamp lastNotificationDate;

  const NotificationText({Key key, this.transaction, this.lastNotificationDate}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          _isTablet ? 20.0 : 8.0,
          0,
          _isTablet ? 20.0 : 8.0,
          _isTablet ? 40.0 : 15.0
      ),
      child: Card(
        color: lastNotificationDate == null || lastNotificationDate.compareTo(transaction['time']) < 0 ?
          Colors.white24 :
          Colors.white10,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Transaction ID: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(new ClipboardData(text: transaction['id']));
                              Toast.show(
                                "Copied: " +
                                transaction['id'], context,
                                duration: Toast.LENGTH_LONG,
                                gravity:  Toast.BOTTOM,
                              );
                            },
                            child: Text(transaction['id'],
                              style: TextStyle(decoration: TextDecoration.underline),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(""),
                    Row(
                      children: <Widget>[
                        Text("Timestamp: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(DateTime.fromMillisecondsSinceEpoch(transaction['time'].seconds * 1000).toString().split('.')[0]),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Buyer: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        InkWell(
                          onTap: () async {
                            DatabaseService databaseService = DatabaseService(
                                user: CustomUser(
                                    transaction['buyer']));
                            CustomUser user = await databaseService
                                .getUserSnapshot();
                            BookPerGenreUserMap userBooks = await databaseService
                                .getUserBooksPerGenreSnapshot();
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    VisualizeProfileMainPage(
                                        user: user,
                                        books: userBooks.result,
                                        self: false)
                                )
                            );
                          },
                          child: Text(transaction['buyerUsername'], style: TextStyle(decoration: TextDecoration.underline),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Shipping: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(transaction['chosenShippingMode'],),
                      ],
                    ),
                    transaction['chosenShippingMode'] == "express courier" ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Ship to: ", style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(transaction['shippingAddress']['fullName'] + "\n"
                              + transaction['shippingAddress']['city'] + ", "
                              + transaction['shippingAddress']['state'] + ", "
                              + transaction['shippingAddress']['address 1'] + " "
                              + transaction['shippingAddress']['address 2'] + ", "
                              + transaction['shippingAddress']['CAP']
                          ),
                      ],
                    ) :
                      Container(),
                    Text(""),
                    transaction['paidBooks'] != null && transaction['paidBooks'].length > 0 ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Paid books: ", style: TextStyle(fontWeight: FontWeight.bold),),
                          for(int i = 0; i < transaction['paidBooks'].length; i++)
                            InkWell(
                              onTap: () async {
                                /*String bookId = transaction['paidBooks'][i]['id'];
                                int bookInsertionNumber = transaction['paidBooks'][i]['insertionNumber'];
                                dynamic bookGeneralInfo = await Utils.databaseService.getGeneralBookInfo(bookId);
                                dynamic book = await Utils.databaseService.viewBookByIdAndInsertionNumber(bookId, bookInsertionNumber, transaction['seller']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (newContext) => ViewPendingBook(
                                          youGet: true,
                                          book: book,
                                          bookGeneralInfo: bookGeneralInfo
                                      ),
                                    )
                                );*/
                              },
                              child: Text(transaction['paidBooks'][i]['title'] + " by " + transaction['paidBooks'][i]['author'] + "\n(€" + transaction['paidBooks'][i]['price'].toStringAsFixed(2) + ")",
                                style: TextStyle(decoration: TextDecoration.underline),
                              ),
                            ),
                        ],
                      ) :
                      Container(),
                    transaction['paidBooks'] != null && transaction['paidBooks'].length > 0 ?
                      Text("") : Container(),
                    transaction['exchanges'] != null && transaction['exchanges'].length > 0 ?
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Exchanges proposed: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        for(int i = 0; i < transaction['exchanges'].length; i++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text("You give: "),
                                  InkWell(
                                    onTap: () async {
                                      String bookId = transaction['exchanges'][i]['receivedBook']['id'];
                                      int bookInsertionNumber = transaction['exchanges'][i]['receivedBook']['insertionNumber'];
                                      dynamic bookGeneralInfo = await Utils.databaseService.getGeneralBookInfo(bookId);
                                      dynamic book = await Utils.databaseService.viewBookByIdAndInsertionNumber(bookId, bookInsertionNumber, transaction['seller']);
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
                                    child: Text(transaction['exchanges'][i]['receivedBook']['title'] +
                                        " by " + transaction['exchanges'][i]['receivedBook']['author'],
                                      style: TextStyle(decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text("You get: "),
                                  InkWell(
                                    onTap: () async {
                                      String bookId = transaction['exchanges'][i]['offeredBook']['id'];
                                      int bookInsertionNumber = transaction['exchanges'][i]['offeredBook']['insertionNumber'];
                                      dynamic bookGeneralInfo = await Utils.databaseService.getGeneralBookInfo(bookId);
                                      dynamic book = await Utils.databaseService.viewBookByIdAndInsertionNumber(bookId, bookInsertionNumber, transaction['buyer']);
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
                                    child: Text(transaction['exchanges'][i]['offeredBook']['title'] +
                                        " by " + transaction['exchanges'][i]['offeredBook']['author'],
                                      style: TextStyle(decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                      ],
                    ) :
                      Container(),
                    transaction['exchanges'] != null && transaction['exchanges'].length > 0 ?
                      Text("") : Container(),
                  ],
                ),
              ),
            ),
            lastNotificationDate == null || lastNotificationDate.compareTo(transaction['time']) < 0 ?
              Icon(Icons.fiber_new) :
              Container(),
          ],
        ),
      ),
    );
  }
}
