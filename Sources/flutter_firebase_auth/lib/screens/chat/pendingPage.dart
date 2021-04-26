import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/chat.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/pendingPageBody.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:provider/provider.dart';

class PendingPage extends StatelessWidget {

  final DatabaseService db;
  final CustomUser user;

  const PendingPage({Key key, this.db, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Chat chat = Provider.of<Chat>(context);
    List<MyTransaction> transactions = Provider.of<List<MyTransaction>>(context);

    return FutureBuilder(
        future: _onlyTranslationInvolved(transactions, chat),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: Loading());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return PendingPageBody(
                  db: db,
                  user: user,
                  transactions: snapshot.data,
                );
          }
        }
    );
  }

  Future<dynamic> _onlyTranslationInvolved(List<MyTransaction> transaction, Chat chat) async {
    dynamic result = [];
    for(int i = 0; i < transaction.length; i++) {
      dynamic tr = await db.getTransactionFromKey(transaction[i].transactionKey);
      result.add(tr);
    }
    return result;
  }
}
