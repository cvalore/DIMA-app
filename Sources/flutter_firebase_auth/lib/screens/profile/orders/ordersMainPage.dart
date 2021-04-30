import 'package:flutter/material.dart';

class OrdersMainPage extends StatefulWidget {

  List<dynamic> orders;

  OrdersMainPage({Key key, this.orders});

  @override
  _OrdersMainPageState createState() => _OrdersMainPageState();
}

class _OrdersMainPageState extends State<OrdersMainPage> {

  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Container();

    /*
    bool _isTablet = MediaQuery
        .of(context)
        .size
        .width > mobileMaxWidth;

    return  loading ? Loading() :
    Scaffold(
      appBar: AppBar(
        title: Text('My orders'),
      ),
      /*
      floatingActionButton: selectionModeOn ? FloatingActionButton.extended(
          label: Text('Remove like'),
          onPressed: () {
            //method removing likes from db
          },
          ) : null,
       */
      body: DefaultTabController(
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        //backgroundColor: Colors.black,
        appBar: AppBar(
          //backgroundColor: Colors.black,
          elevation: 0.0,
          title: Text('BookYourBook', style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            letterSpacing: 1.0,
          ),),
          actions: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                textButtonTheme: _textButtonThemeData,
              ),
              child: TextButton.icon(
                icon: Icon(Icons.logout, color: Colors.white,),
                label: Text(''),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ),
          ],
          bottom: _selectedBottomTab == 0 ?
          TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Container(
                  height: _isTablet ? 60.0 : 40.0,
                  child: Center(child: Text('For Sale',
                    style: TextStyle(fontSize: _isTablet ? 20.0 : 14.0),))
              ),
              Container(
                  height: _isTablet ? 60.0 : 40.0,
                  child: Center(child: Text('My Books',
                    style: TextStyle(fontSize: _isTablet ? 20.0 : 14.0),))
              ),
            ],
          ) :
          null,
        ),
        body: Builder(
          builder: (BuildContext context) {
            return _selectedBottomTab != 0 ?
            _widgetsBottomOptions.elementAt(_selectedBottomTab) :
            TabBarView(
                children: [
                  HomePage(),
                  MyBooks(self: true),
                ]
            );

            return _widgetsBottomOptions.elementAt(_selectedBottomTab);
            /*return _selectedBottomTab != 0 ?
                  _widgetsBottomOptions.elementAt(_selectedBottomTab) :
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: UpperTabs(),
                      ),
                      Expanded(
                        flex: 10,
                        child: _widgetsBottomOptions.elementAt(_selectedBottomTab),
                      ),
                    ],
                  );*/
          },
        ),
        bottomNavigationBar: BottomTabs(
          getIndex: getIndex,
          setIndex: setIndex,
        ),
      ),
    ),
    );
  }
}

     */
  }
}
