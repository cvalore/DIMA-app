import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationProfile.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

import 'notificationProfileFake.dart';

class NotificationProfileManager extends StatelessWidget {

  final double height;
  Timestamp lastNotificationDate;

  NotificationProfileManager({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<MyTransaction> transactions = Provider.of<List<MyTransaction>>(context);

    return
    transactions == null || transactions.length == 0 ?
    NotificationProfile(height: height, transactions: null, oldContext: context, ) :
    FutureBuilder(
        future: _onlyTranslationInvolved(transactions),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: NotificationProfileFake(height: height,));
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return NotificationProfile(
                  height: height,
                  transactions: snapshot.data,
                  oldContext: context,
                  lastNotificationDate: lastNotificationDate,
                );
          }
        }
    );
  }

    Future<dynamic> _onlyTranslationInvolved(List<MyTransaction> transaction) async {
      dynamic result = [];
      for(int i = 0; i < transaction.length; i++) {
        dynamic tr = await Utils.databaseService.getTransactionFromKey(transaction[i].transactionKey);
        result.add(tr);
      }

      result.sort((a ,b) {
        Timestamp timeA = a['time'];
        Timestamp timeB = b['time'];
        return -timeA.compareTo(timeB);
      });

      lastNotificationDate = await Utils.databaseService.getLastNotificationDate();

      return result;
    }
}

