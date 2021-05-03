import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/exchanges.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/purchases.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class OrdersMainPage extends StatefulWidget {

  List<dynamic> completedPurchases;
  List<dynamic> completedExchanges;
  List<dynamic> pendingExchanges;

  OrdersMainPage({Key key, this.completedPurchases, this.completedExchanges, this.pendingExchanges});

  @override
  _OrdersMainPageState createState() => _OrdersMainPageState();
}

class _OrdersMainPageState extends State<OrdersMainPage> {

  bool loading = false;


  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery
        .of(context)
        .size
        .width > mobileMaxWidth;

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          title: Text('My orders', style:
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              letterSpacing: 1.0,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: 'Purchases',
              icon: Icon(Icons.info_outline)),
              Tab(text: 'Exchanges',
              icon: Icon(Icons.rate_review_outlined)),
              Tab(text: 'Pending',
                  icon: Icon(Icons.rate_review_outlined)),
            ],
          ),
        ),
        body: TabBarView(
                children: [
                  Purchases(purchases: widget.completedPurchases),
                  Exchanges(exchanges: widget.completedExchanges),
                  Exchanges(exchanges: widget.pendingExchanges),
                ]
              ),
        ),
      );
  }
}

