import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationText.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class NotificationPageBody extends StatelessWidget {

  final dynamic transactions;

  const NotificationPageBody({Key key, this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

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
      Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for(int i = 0; i < transactions.length; i++)
          NotificationText(transaction: transactions[i]),
      ],
    );
  }
}
