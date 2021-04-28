import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationText.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';

class NotificationPageBody extends StatelessWidget {

  final dynamic transactions;
  final Timestamp lastNotificationDate;

  const NotificationPageBody({Key key, this.transactions, this.lastNotificationDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    transactions.sort((a ,b) {
      Timestamp timeA = a['time'];
      Timestamp timeB = b['time'];
      return -timeA.compareTo(timeB);
    });

    return
      transactions == null || transactions.length == 0 ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("No notifications yet",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: _isTablet ? 17.0 : 15.0,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.5),
              child: Icon(Icons.notifications_none_outlined)
          ),
        ],
      ) :
      Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              for(int i = 0; i < transactions.length; i++)
                Padding(
                  padding: EdgeInsets.only(top: i != 0 ? 0.0: _isTablet ? 40.0 : 15.0),
                  child: ManuallyCloseableExpansionTile(
                    title: Text("Transaction ID: " + transactions[i]['id'].substring(0,10) + " ... " + DateTime.fromMillisecondsSinceEpoch(transactions[i]['time'].seconds * 1000).toString().split('.')[0],
                      overflow: TextOverflow.ellipsis,
                    ),
                    initiallyExpanded: lastNotificationDate.compareTo(transactions[i]['time']) < 0,
                    children: <Widget>[
                      NotificationText(
                        transaction: transactions[i],
                        lastNotificationDate: lastNotificationDate
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      );
  }
}