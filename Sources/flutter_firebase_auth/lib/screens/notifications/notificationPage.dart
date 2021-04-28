import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationPageBody.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List<MyTransaction> transactions = Provider.of<List<MyTransaction>>(context);

    return FutureBuilder(
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
    return result;
  }
}
