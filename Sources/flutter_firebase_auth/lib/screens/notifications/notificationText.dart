import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:toast/toast.dart';

import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';

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
                                await Utils.pushBookFromTransaction(context, transaction['paidBooks'][i], transaction['seller']);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("You give: "),
                                  Flexible(
                                    child: InkWell(
                                      onTap: () async {
                                        await Utils.pushBookFromTransaction(context, transaction['exchanges'][i]['receivedBook'], transaction['seller']);
                                      },
                                      child: Text(transaction['exchanges'][i]['receivedBook']['title'] +
                                          " by " + transaction['exchanges'][i]['receivedBook']['author'],
                                        style: TextStyle(decoration: TextDecoration.underline,),
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("You get: "),
                                  Flexible(
                                    child: InkWell(
                                      onTap: () async {
                                        await Utils.pushBookFromTransaction(context, transaction['exchanges'][i]['offeredBook'], transaction['buyer']);
                                      },
                                      child: Text(transaction['exchanges'][i]['offeredBook']['title'] +
                                          " by " + transaction['exchanges'][i]['offeredBook']['author'],
                                        style: TextStyle(decoration: TextDecoration.underline),
                                        overflow: TextOverflow.visible,
                                      ),
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
