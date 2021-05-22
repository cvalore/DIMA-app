import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/main.dart' as app;
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/authenticate/signIn.dart';
import 'package:flutter_firebase_auth/screens/home/home.dart';
import 'package:flutter_firebase_auth/screens/home/homeBody.dart';
import 'package:flutter_firebase_auth/screens/wrapper.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookGeneralInfoListView.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Utils.mockedDb = true;
  Utils.mySelf = CustomUser("");
  Utils.databaseService = DatabaseService();

  testWidgets('Book Insert Integration Test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(15000, 16000);

    //region do login
    Utils.mockedUsers.addAll({
      "testEmail@gmail.com" : "testPassword1234",
    });

    app.main();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final emailSignInTextFormField = find.byType(TextFormField).first;
    final passwordSignInTextFormField = find.byType(TextFormField).last;
    await tester.enterText(emailSignInTextFormField, "testEmail@gmail.com");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(passwordSignInTextFormField, "testPassword1234");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final signInText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Sign In");
    await tester.tap(signInText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    WrapperState wrapperWidget = tester.state(find.byType(Wrapper));
    wrapperWidget.rebuildForTest();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(SignIn), findsNothing);
    expect(find.byType(Home), findsOneWidget);
    //endregion

    final insertBookIcon = find.byWidgetPredicate((widget) => widget is Icon && widget.key == ValueKey("InsertBottomNavTab"));
    await tester.tap(insertBookIcon);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(BookInsert), findsOneWidget);

    final titleTextField = find.byType(TextFormField).first;
    final authorTextField = find.byType(TextFormField).last;
    await tester.enterText(titleTextField, "titleTest");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(authorTextField, "authorTest");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final searchIcon = find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.search);
    await tester.tap(searchIcon);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(ListTile), findsNWidgets(10));

    final firstBookListTile = find.byType(ListTile).first;
    await tester.tap(firstBookListTile);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(BookGeneralInfoListView), findsOneWidget);

    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}