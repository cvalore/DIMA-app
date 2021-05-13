import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/exchanges.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/purchases.dart';
import 'package:flutter_firebase_auth/utils/myVerticalTabs.dart';

import 'package:flutter_firebase_auth/utils/constants.dart';


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
  int _selectedVerticalTab = 0;

  int getIndexVerticalTab() {
    return this._selectedVerticalTab;
  }

  void setIndexVerticalTab(int newIndex) {
    this._selectedVerticalTab = newIndex;
  }
  


  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

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
          bottom: _isPortrait ?
          TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: 'Purchases',
              icon: Icon(Icons.info_outline)),
              Tab(text: 'Exchanges',
              icon: Icon(Icons.rate_review_outlined)),
              Tab(text: 'Pending',
                  icon: Icon(Icons.rate_review_outlined)),
            ],
          ) : null,
        ),
        body:
        _isPortrait ?
          TabBarView(
            children: [
              Purchases(purchases: widget.completedPurchases),
              Exchanges(exchanges: widget.completedExchanges),
              Exchanges(exchanges: widget.pendingExchanges),
            ]
          ) :
          Builder(builder: (BuildContext context) {
            return MyVerticalTabs(
              setIndex: setIndexVerticalTab,
              getIndex: getIndexVerticalTab,
              //tabBarHeight: 120,
                tabBarHeight: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
                tabBarWidth: 90,
                tabsWidth: 90,
                indicatorColor: Colors.blue,
                selectedTabBackgroundColor: Colors.white10,
                tabBackgroundColor: Colors.black26,
                selectedTabTextStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: <Tab>[
                  Tab(child: Container(
                    //height: 50,
                      height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/3,
                      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Purchases', textAlign: TextAlign.center,),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(Icons.info_outline),
                          ),
                        ],
                      ))
                  )),
                  Tab(child: Container(
                    //height: 50,
                      height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/3,
                      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Exchanges', textAlign: TextAlign.center,),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(Icons.rate_review_outlined),
                          ),
                        ],
                      ))
                  )),
                  Tab(child: Container(
                    //height: 50,
                      height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/3,
                      //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                      child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Pending', textAlign: TextAlign.center,),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(Icons.rate_review_outlined),
                          ),
                        ],
                      ))
                  )),
                ],
                contents: [
                  Purchases(purchases: widget.completedPurchases),
                  Exchanges(exchanges: widget.completedExchanges),
                  Exchanges(exchanges: widget.pendingExchanges),
                ]
            );
          },)
        ),
      );
  }
}

