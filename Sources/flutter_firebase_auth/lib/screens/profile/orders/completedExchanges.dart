import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/exchanges.dart';
import 'package:flutter_firebase_auth/utils/loading.dart';
import 'package:flutter_firebase_auth/utils/myVerticalTabs.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';


class CompletedExchanges extends StatefulWidget {

  List<dynamic> acceptedExchanges;
  List<dynamic> rejectedExchanges;

  CompletedExchanges({Key key, this.acceptedExchanges, this.rejectedExchanges});

  @override
  _CompletedExchangesState createState() => _CompletedExchangesState();
}

class _CompletedExchangesState extends State<CompletedExchanges> {

  bool loading = false;

  int _selectedIndexForBottomNavigationBar = 0;
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

    return loading == true ? Loading() : Scaffold(
      bottomNavigationBar: _isPortrait ?
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _selectedIndexForBottomNavigationBar = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Accepted',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.cancel_outlined),
              label: 'Rejected'
          ),
        ],
        currentIndex: _selectedIndexForBottomNavigationBar,
      ) : null,
        body: _isPortrait ? _selectedIndexForBottomNavigationBar == 0 ?
        Exchanges(exchanges: widget.acceptedExchanges, type: 'Accepted') :
        Exchanges(exchanges: widget.rejectedExchanges, type: 'Rejected') :
        MyVerticalTabs(
          setIndex: setIndexVerticalTab,
          getIndex: getIndexVerticalTab,
          indicatorSide: IndicatorSide.end,
          tabBarSide: TabBarSide.right,
          disabledChangePageFromContentView: true,
          tabBarHeight: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
          tabBarWidth: 85,
          tabsWidth: 85,
          indicatorColor: Colors.blue,
          selectedTabBackgroundColor: Colors.white10,
          tabBackgroundColor: Colors.black26,
          selectedTabTextStyle: TextStyle(fontWeight: FontWeight.bold),
          tabs: <Tab>[
            Tab(child: Container(
              //height: 50,
                height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/2,
                //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Accepted', textAlign: TextAlign.center,),
                    Icon(Icons.check_circle_outline),
                  ],
                ))
            )),
            Tab(child: Container(
              //height: 50,
                height: (MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight)/2,
                //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Rejected', textAlign: TextAlign.center,),
                    Icon(Icons.cancel_outlined),
                  ],
                ))
            )),
          ],
          contents: [
            Exchanges(exchanges: widget.acceptedExchanges, type: 'Accepted'),
            Exchanges(exchanges: widget.rejectedExchanges, type: 'Rejected')
          ],
        ),
    );
  }
}
