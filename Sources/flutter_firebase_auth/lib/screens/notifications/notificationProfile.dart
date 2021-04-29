import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/myTransaction.dart';
import 'package:flutter_firebase_auth/screens/notifications/notificationPage.dart';
import 'package:flutter_firebase_auth/screens/profile/chat/chatProfileBody.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';

class NotificationProfile extends StatelessWidget {

  final double height;
  bool newNotifications = false;
  final dynamic transactions;
  final BuildContext oldContext;
  final Timestamp lastNotificationDate;

  NotificationProfile({Key key, this.height, this.transactions, this.oldContext, this.lastNotificationDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    newNotifications = false;
    for(int i = 0; transactions != null && i < transactions.length; i++) {
      if(lastNotificationDate.compareTo(transactions[i]['time']) < 0) {
        newNotifications = true;
        break;
      }
    }

    return Container(
        height: height,
        child: GestureDetector(
          onTap: () async {

            //Timestamp lastNotificationDate = await Utils.databaseService.getLastNotificationDate();
            await Utils.databaseService.setNowAsLastNotificationDate();

            Navigator.push(oldContext, MaterialPageRoute(builder: (context) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  //backgroundColor: Colors.black,
                  appBar: AppBar(
                    //backgroundColor: Colors.black,
                    elevation: 0.0,
                    title: Text('My notification', style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      letterSpacing: 1.0,
                    ),),
                    /*actions: [
                      IconButton(
                        icon: Icon(Icons.system_update),
                        onPressed: () async {
                          await Utils.databaseService.addFakeTransaction();
                        },
                      )
                    ],*/
                  ),
                  body: NotificationPage(
                    lastNotificationDate: lastNotificationDate,
                    transactions: transactions,
                  ),
              );
            }));
          },
          child: Row(
            children: [
              Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.notifications_none_outlined,
                            ),
                          )
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Notifications",
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      newNotifications ? Icon(Icons.fiber_new) : Container(),
                    ],
                  )
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              )
            ],
          ),
        )
    );
  }

}
