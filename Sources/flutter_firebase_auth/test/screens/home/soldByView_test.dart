import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'package:flutter_firebase_auth/screens/myBooks/viewBookPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets("SoldByView Test", (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(1500, 1600); //set dim to be portrait and not landscape

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    StreamController<AuthCustomUser> _streamControllerAuthUser = StreamController<AuthCustomUser>();
    final _providerKeyAuthUser = GlobalKey();
    _streamControllerAuthUser.add(AuthCustomUser("", "", false));
    final _childKey = GlobalKey();

    dynamic books = [
      {
        "book" : {
          "title" : "title",
          "author" : "author",
          "price" : 9.99,
          "exchangeStatus" : "",
          "exchangeable" : false,
          "likedBy" : [],
          "insertionNumber" : 1,
          "imagesUrl" : [],
          "status" : 3,
        },
        "userProfileImageURL" : "",
        "username" : "username",
        "uid" : "uid",
        "email" : "email",
        "thumbnail": "thumbnail",
      }
    ];

    await tester.pumpWidget(MaterialApp(home: Scaffold(body:
    StreamProvider(
        key: _providerKeyAuthUser,
        create: (BuildContext c) {
          return _streamControllerAuthUser.stream;
        },
        child: Builder(
            builder: (BuildContext context) {
              return SoldByView(key: _childKey, books: books, showOnlyExchangeable: false, fromPending: false, setLoading: (bool){}, fatherContext: context,);
            },
        ),
    )
    )));
    expect(find.byType(InkWell), findsNWidgets(2*books.length));
    expect(find.byType(CircleAvatar), findsNWidgets(books.length));
    expect(find.byType(ListView), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Details"), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "NO IMAGES"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "username"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "email"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "€ 9.99"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Exchange available"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.hourglass_bottom_outlined), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_outlined), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.clear_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.favorite_outlined), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.favorite_border_outlined), findsOneWidget);

    await tester.tap(find.byType(IconButton));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.favorite_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.favorite_border_outlined), findsNothing);

    await tester.tap(find.byType(IconButton));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.favorite_outlined), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.favorite_border_outlined), findsOneWidget);

    expect(find.byType(ViewBookPage), findsNothing);
    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(ViewBookPage), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(VisualizeProfileMainPage), findsNothing);
    await tester.tap(find.byType(InkWell).last);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    expect(find.byType(VisualizeProfileMainPage), findsOneWidget);

    _streamControllerAuthUser.close();
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}