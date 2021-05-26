import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/main.dart' as app;
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsert.dart';
import 'package:flutter_firebase_auth/screens/authenticate/signIn.dart';
import 'package:flutter_firebase_auth/screens/home/home.dart';
import 'package:flutter_firebase_auth/screens/home/homePage.dart';
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

    assert (Utils.mockedInsertedBooks.isEmpty);

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
    
    await tester.drag(find.byType(CachedNetworkImage), Offset(-5000, 0));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(AddBookUserInfo), findsOneWidget);

    final fourthStarIcon = find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border).first;
    await tester.tap(fourthStarIcon);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final categoryText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Category").first;
    await tester.tap(categoryText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final fantasyCategoryText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Fantasy").first;
    await tester.tap(fantasyCategoryText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final commentText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Comment").first;
    await tester.tap(commentText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final commentField = find.byType(TextFormField).first;
    await tester.enterText(commentField, "this is a test comment");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final confirmComment = find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_outlined).first;
    await tester.tap(confirmComment);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final priceText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Price").first;
    await tester.tap(priceText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final priceField = find.byType(TextFormField).first;
    await tester.enterText(priceField, "9.99");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final confirmPrice = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Done").first;
    await tester.tap(confirmPrice);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final exchangeText = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Available for exchange").first;
    await tester.tap(exchangeText);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final saveButton = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Save");
    await tester.tap(saveButton);
    await tester.pump(Duration(seconds: 3)); //to handle the timer

    assert (Utils.mockedInsertedBooks.length == 1);
    InsertedBook insertedBook = Utils.mockedInsertedBooks[0];
    assert (insertedBook.title == "Harry Potter e la Pietra Filosofale");
    assert (insertedBook.author == "[J.K. Rowling]");
    assert (insertedBook.status == 4);
    assert (insertedBook.category == "Fantasy");
    assert (insertedBook.comment == "this is a test comment");
    assert (insertedBook.price == 9.99);
    assert (insertedBook.exchangeable == true);

    final backButton = find.byWidgetPredicate((widget) => widget is Tooltip && widget.message == "Back").first;
    await tester.tap(backButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(HomePage), findsOneWidget);

    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}