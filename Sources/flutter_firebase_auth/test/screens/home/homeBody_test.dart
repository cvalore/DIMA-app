import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchPage.dart';
import 'package:flutter_firebase_auth/screens/forum/forumMainPage.dart';
import 'package:flutter_firebase_auth/screens/home/homeBody.dart';
import 'package:flutter_firebase_auth/screens/home/homePage.dart';
import 'package:flutter_firebase_auth/screens/myBooks/myBooks.dart';
import 'package:flutter_firebase_auth/screens/profile/profileMainPage.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/myVerticalTabs.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  //region portrait test
  testWidgets("HomeBody Portrait Test", (WidgetTester tester) async {

    tester.binding.window.physicalSizeTestValue = Size(500, 800); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();

    StreamController<BookPerGenreMap> _streamControllerBookPerGenreMap = StreamController<BookPerGenreMap>();
    final _providerKeyBookPerGenreMap = GlobalKey();
    StreamController<BookPerGenreUserMap> _streamControllerBookPerGenreUserMap = StreamController<BookPerGenreUserMap>();
    final _providerKeyBookPerGenreUserMap = GlobalKey();
    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));

    final _childKey = GlobalKey();

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: StreamProvider(
        key: _providerKeyBookPerGenreMap,
        create: (BuildContext c) {
          return _streamControllerBookPerGenreMap.stream;
        },
        child: StreamProvider(
          key: _providerKeyBookPerGenreUserMap,
          create: (BuildContext c) {
            return _streamControllerBookPerGenreUserMap.stream;
          },
          child: HomeBody(key: _childKey,)
        ),
      ),
    ),),));
    expect(Provider.of<BookPerGenreMap>(_childKey.currentContext, listen: false), isNull);
    expect(find.byType(TabBarView), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(MyBooks), findsNothing);
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(CustomScrollView), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No books yet, the books for sale will appear here"), findsOneWidget);

    dynamic booksFantasy = {
      "books" : [
        {
          "key1" : {
            "title": "",
            "author": "",
            "thumbnail": "",
          }
        },
        {
          "key2" : {
            "title": "",
            "author": "",
            "thumbnail": "",
          }
        }
      ]
    };
    dynamic books = {
      "Fantasy" : booksFantasy,
    };
    _streamControllerBookPerGenreMap.add(BookPerGenreMap(books));


    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: StreamProvider(
        key: _providerKeyBookPerGenreMap,
        create: (BuildContext c) {
          return _streamControllerBookPerGenreMap.stream;
        },
        child: StreamProvider(
            key: _providerKeyBookPerGenreUserMap,
            create: (BuildContext c) {
              return _streamControllerBookPerGenreUserMap.stream;
            },
            child: HomeBody(key: _childKey,)
        ),
      ),
    ),),));



    expect(Provider.of<BookPerGenreMap>(_childKey.currentContext, listen: false), isNotNull);
    expect(find.byType(TabBarView), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(MyBooks), findsNothing);
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No books yet, the books for sale will appear here"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is ListView && widget.semanticChildCount == booksFantasy['books'].length), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);

    /*expect(find.byType(HomeBookInfo), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is InkWell && widget.key == ValueKey("PushBookPageInkWell")), findsNWidgets(booksFantasy['books'].length));
    await tester.tap(find.byWidgetPredicate((widget) => widget is InkWell && widget.key == ValueKey("PushBookPageInkWell")).at(1));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(HomeBookInfo), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));*/

    await tester.tap(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("MyBooksTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(HomePage), findsNothing);
    expect(find.byType(MyBooks), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("ForSaleTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(MyBooks), findsNothing);

    expect(find.byType(BottomNavigationBar), findsOneWidget);

    expect(find.byType(SearchPage), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Icon && widget.key == ValueKey("SearchBottomNavTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(SearchPage), findsOneWidget);


    expect(find.byType(BottomNavigationBar), findsNothing);
    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    expect(find.byType(BookInsert), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Icon && widget.key == ValueKey("InsertBottomNavTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(BookInsert), findsOneWidget);

    expect(find.byType(BottomNavigationBar), findsNothing);
    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    expect(find.byType(ForumMainPage), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Icon && widget.key == ValueKey("ForumBottomNavTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ForumMainPage), findsOneWidget);

    expect(find.byType(ProfileMainPage), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Icon && widget.key == ValueKey("ProfileBottomNavTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ProfileMainPage), findsOneWidget);

    _streamControllerBookPerGenreMap.close();
    _streamControllerBookPerGenreUserMap.close();
    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
  //endregion

  //region landscape test
  testWidgets("HomeBody Landscape Test", (WidgetTester tester) async {

    tester.binding.window.physicalSizeTestValue = Size(1300, 1200); //set dim to be landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    AuthService auth = AuthService();

    StreamController<BookPerGenreMap> _streamControllerBookPerGenreMap = StreamController<BookPerGenreMap>();
    final _providerKeyBookPerGenreMap = GlobalKey();
    StreamController<BookPerGenreUserMap> _streamControllerBookPerGenreUserMap = StreamController<BookPerGenreUserMap>();
    final _providerKeyBookPerGenreUserMap = GlobalKey();
    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));

    final _childKey = GlobalKey();
    dynamic booksFantasy = {
      "books" : [
        {
          "key1" : {
            "title": "",
            "author": "",
            "thumbnail": "",
          }
        },
        {
          "key2" : {
            "title": "",
            "author": "",
            "thumbnail": "",
          }
        }
      ]
    };
    dynamic books = {
      "Fantasy" : booksFantasy,
    };
    _streamControllerBookPerGenreMap.add(BookPerGenreMap(books));


    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: StreamProvider(
        key: _providerKeyBookPerGenreMap,
        create: (BuildContext c) {
          return _streamControllerBookPerGenreMap.stream;
        },
        child: StreamProvider(
            key: _providerKeyBookPerGenreUserMap,
            create: (BuildContext c) {
              return _streamControllerBookPerGenreUserMap.stream;
            },
            child: HomeBody(key: _childKey,)
        ),
      ),
    ),),));

    await tester.pump();
    await tester.pump(Duration(seconds: 1));


    expect(Provider.of<BookPerGenreMap>(_childKey.currentContext, listen: false), isNotNull);
    expect(find.byType(TabBarView), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(MyBooks), findsNothing);
    expect(find.byType(TabBar), findsNothing);
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "No books yet, the books for sale will appear here"), findsNothing);
    expect(find.byType(MyVerticalTabs), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("SearchVerticalTab")), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("InsertVerticalTab")), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("ForumVerticalTab")), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("ProfileVerticalTab")), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("HomeVerticalTab")), findsOneWidget);

    expect(find.byType(SearchPage), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("SearchVerticalTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(SearchPage), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(BookInsert), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("InsertVerticalTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(BookInsert), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(ForumMainPage), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("ForumVerticalTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ForumMainPage), findsOneWidget);

    expect(find.byType(HomePage), findsNothing);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("HomeVerticalTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(MyBooks), findsNothing);

    await tester.tap(find.byWidgetPredicate((widget) => widget is Container && widget.key == ValueKey("MyBooksVerticalTab")));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(HomePage), findsNothing);
    expect(find.byType(MyBooks), findsOneWidget);

    _streamControllerBookPerGenreMap.close();
    _streamControllerBookPerGenreUserMap.close();
    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
  //endregion

}