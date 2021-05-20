import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchBookInfoBody.dart';
import 'package:flutter_firebase_auth/screens/home/homeGeneralInfoView.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  testWidgets("SearchBookInfoBody Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1500, 1600); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));
    final _childKey = GlobalKey();

    dynamic book = [
      {
        "title" : "title1",
        "author" : "author1",
        "thumbnail" : "",
        "book": {
          "id": "id1",
          "title": "title1",
          "author": "author1",
          "price": 19.99,
          "exchangeable": false,
          "likedBy" : [],
          "imagesUrl" : [],
        },
        "info": {
          "id": "id1",
          "title": "title1",
          "author": "author1",
        },
        "uid": "uid1",
        "username": "username1",
        "email": "email1",
        "userProfileImageURL" : "",
      },
    ];
    dynamic bookInfo = book[0]["info"];
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: StreamProvider(
      key: _providerKeyAuthUser,
      create: (BuildContext c) {
        return _streamControllerAuthUser.stream;
      },
      child: Builder(builder: (BuildContext context) {
        return SearchBookInfoBody(key: _childKey, book: book, bookInfo: bookInfo, setLoading: (bool){}, fatherContext: context,);
      },),
    ),),));

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Book general info"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Sold by"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Exchanged by"), findsOneWidget);
    expect(find.byType(HomeBookGeneralInfoView), findsNothing);
    expect(find.byType(SoldByView), findsNothing);
    expect(find.byType(ExpansionTile), findsNWidgets(3));

    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.byType(ExpansionTile).at(1));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.byType(ExpansionTile).last);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(HomeBookGeneralInfoView), findsOneWidget);
    expect(find.byType(SoldByView), findsNWidgets(2));

    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });

}