import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/ordersMainPage.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class Orders extends StatefulWidget {

  double height;

  Orders({Key key, @required this.height}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {

    return Container(
        height: widget.height,
        child: InkWell(
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FutureBuilder(
                  future: Utils.databaseService.getMyOrders(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting)
                      return Loading();
                    else {
                      print(snapshot.data);
                      return OrdersMainPage(
                          completedPurchases: snapshot.data[0],
                          completedExchanges: snapshot.data[1],
                          pendingExchanges: snapshot.data[2]);
                    }
                  }
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
                              Icons.shopping_cart_outlined,
                            ),
                          )
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("My orders",
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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

