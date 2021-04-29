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

  NotificationProfile({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        height: height,
        child: GestureDetector(
          onTap: () async {

            Timestamp lastNotificationDate = await Utils.databaseService.getLastNotificationDate();
            await Utils.databaseService.setNowAsLastNotificationDate();

            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  body: StreamProvider<List<MyTransaction>>.value(
                    value: Utils.databaseService.allTransactionsInfo,
                    child: NotificationPage(lastNotificationDate: lastNotificationDate),
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
