import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationPageBody.dart';

class NotificationPage extends StatelessWidget {

  final Timestamp lastNotificationDate;
  //final List<MyTransaction> transactions;
  final dynamic transactions;

  const NotificationPage({Key key, this.lastNotificationDate, this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return FutureBuilder(
        future: _onlyTranslationInvolved(transactions),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: Loading());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return NotificationPageBody(
                  transactions: snapshot.data,
                  lastNotificationDate: lastNotificationDate,
                );
          }
        }
    );*/
    return NotificationPageBody(
      transactions: transactions,
      lastNotificationDate: lastNotificationDate,
    );
  }

  /*Future<dynamic> _onlyTranslationInvolved(List<MyTransaction> transaction) async {
    dynamic result = [];
    for(int i = 0; i < transaction.length; i++) {
      dynamic tr = await Utils.databaseService.getTransactionFromKey(transaction[i].transactionKey);
      result.add(tr);
    }
    return result;
  }*/
}
