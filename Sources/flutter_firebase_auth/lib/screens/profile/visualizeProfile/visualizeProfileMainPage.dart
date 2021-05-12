
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/modifyProfile/modifyProfileMainPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/receivedReviews.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/reviewsMainPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/userInfo.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/myVerticalTabs.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';


class VisualizeProfileMainPage extends StatefulWidget {
  static const routeName = '/visualizeProfileMainPage';

  bool self;
  CustomUser user;
  Map<int, dynamic> books;

  VisualizeProfileMainPage({Key key, this.user, this.books, @required this.self}) : super(key: key);

  @override
  _VisualizeProfileMainPageState createState() => _VisualizeProfileMainPageState();
}

class _VisualizeProfileMainPageState extends State<VisualizeProfileMainPage> {

  int _selectedVerticalTab = 0;

  int getIndexVerticalTab() {
    return this._selectedVerticalTab;
  }

  void setIndexVerticalTab(int newIndex) {
    this._selectedVerticalTab = newIndex;
  }

  int _selectedVerticalTabMain = 0;

  int getIndexVerticalTabMain() {
    return this._selectedVerticalTabMain;
  }

  void setIndexVerticalTabMain(int newIndex) {
    this._selectedVerticalTabMain = newIndex;
  }

  @override
  Widget build(BuildContext context) {

    CustomUser user;
    user = widget.user != null ? widget.user : Provider.of<CustomUser>(context);

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    //DatabaseService _db = DatabaseService(user: user);

    return user != null ?
      DefaultTabController(
        length: widget.self ? 2 : 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(user.username),
            actions: widget.self ? [
              myPopUpMenu(context, user)
            ] : [],
            bottom:
            _isPortrait ?
              widget.self ?
                TabBar(
                  tabs: [
                    Tab(text: 'Information',
                        icon: Icon(Icons.info_outline)),
                    Tab(text: 'Reviews',
                        icon: Icon(Icons.rate_review_outlined)
                    ),
                  ],
                ) :
                TabBar(
                  tabs: [
                    Tab(text: 'Information',
                        icon: Icon(Icons.info_outline)),
                    Tab(text: 'Library',
                        icon: Icon(Icons.menu_book)),
                    Tab(text: 'Reviews',
                        icon: Icon(Icons.rate_review_outlined)
                    ),
                  ],
                ) :
              null,
          ),
          body: Builder(builder: (BuildContext context) {
            return
              widget.self ?
                _isPortrait ?
                  TabBarView(
                    children: [
                      UserInfo(user: user, self: widget.self),
                      ReviewsMainPage(receivedReviews: user.receivedReviews, reviewsWrittenByMe: user.reviewsWrittenByMe, self: widget.self),
                    ],
                  ) :
                  MyVerticalTabs(
                    setIndex: setIndexVerticalTabMain,
                    getIndex: getIndexVerticalTabMain,
                    tabBarHeight: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
                    tabBarWidth: 95,
                    tabsWidth: 95,
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
                              Text('Information', textAlign: TextAlign.center,),
                              Icon(Icons.info_outline),
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
                              Text('Reviews', textAlign: TextAlign.center,),
                              Icon(Icons.rate_review_outlined),
                            ],
                          ))
                      )),
                    ],
                    contents: [
                      UserInfo(user: user, self: widget.self),
                      ReviewsMainPage(receivedReviews: user.receivedReviews, reviewsWrittenByMe: user.reviewsWrittenByMe, self: widget.self),
                    ],
                  ) :
                _isPortrait ?
                  TabBarView(
                    children: [
                      UserInfo(user: user, self: widget.self),
                      widget.books != null ? MyBooks(books: widget.books, self: false, userUid: user.uid) : MyBooks(self: false, userUid: user.uid),   //TODO questo controllo potrebbe essere inutile
                      ReceivedReviews(reviews: user.receivedReviews),
                    ],
                  ) :
                  MyVerticalTabs(
                    setIndex: setIndexVerticalTab,
                    getIndex: getIndexVerticalTab,
                    tabBarHeight: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
                    tabBarWidth: 95,
                    tabsWidth: 95,
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
                              Text('Information', textAlign: TextAlign.center,),
                              Icon(Icons.info_outline),
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
                              Text('Library', textAlign: TextAlign.center,),
                              Icon(Icons.menu_book),
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
                              Text('Reviews', textAlign: TextAlign.center,),
                              Icon(Icons.rate_review_outlined),
                            ],
                          ))
                      )),
                    ],
                    contents: [
                      UserInfo(user: user, self: widget.self),
                      widget.books != null ? MyBooks(books: widget.books, self: false, userUid: user.uid) : MyBooks(self: false, userUid: user.uid),   //TODO questo controllo potrebbe essere inutile
                      ReceivedReviews(reviews: user.receivedReviews),
                    ],
                  );
          },),
        ),
      ) : Container();
  }
}


Widget myPopUpMenu(BuildContext context, CustomUser user) {
  return  PopupMenuButton<String>(
    icon: Icon(Icons.more_vert_outlined),
    onSelected: (value) {
      switch (value) {
        case 'Modify profile':
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ModifyProfileMainPage(user: user))
          );
          break;
      }
    },
    itemBuilder: (BuildContext context) => [
      const PopupMenuItem(
        value: 'Modify profile',
        child: Text('Modify profile'))
    ]
  );
}