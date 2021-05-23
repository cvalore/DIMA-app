import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/main.dart' as app;
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/buyBooks.dart';
import 'package:flutter_firebase_auth/screens/authenticate/signIn.dart';
import 'package:flutter_firebase_auth/screens/home/home.dart';
import 'package:flutter_firebase_auth/screens/home/homeBookInfo.dart';
import 'package:flutter_firebase_auth/screens/home/homePage.dart';
import 'package:flutter_firebase_auth/screens/home/soldByView.dart';
import 'package:flutter_firebase_auth/screens/myBooks/viewBookPage.dart';
import 'package:flutter_firebase_auth/screens/wrapper.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Utils.mockedDb = true;
  Utils.mySelf = CustomUser("");
  Utils.databaseService = DatabaseService();

  testWidgets('Buy Book Integration Test', (WidgetTester tester) async {
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

    //region insert book
    final insertBookIcon = find.byWidgetPredicate((widget) => widget is Icon && widget.key == ValueKey("InsertBottomNavTab"));
    await tester.tap(insertBookIcon);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final titleTextField = find.byType(TextFormField).first;
    final authorTextField = find.byType(TextFormField).last;
    await tester.enterText(titleTextField, "harry");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(authorTextField, "rowling");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final searchIcon = find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.search);
    await tester.tap(searchIcon);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final firstBookListTile = find.byType(ListTile).first;
    await tester.tap(firstBookListTile);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    await tester.drag(find.byType(CachedNetworkImage), Offset(-5000, 0));
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

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
    await tester.pump(Duration(milliseconds: 3000)); //to handle the timer

    final backButton = find.byWidgetPredicate((widget) => widget is Tooltip && widget.message == "Back").first;
    await tester.tap(backButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
  //endregion

    assert (Utils.mockedInsertedBooks.length != 0);
    assert (Utils.mockedInsertedBooksMap.length != 0);

    HomePageState homePageState = tester.state(find.byType(HomePage));
    homePageState.rebuildForTest();
    await tester.pump();
    await tester.pump(Duration(seconds: 1));


    expect(find.byType(HomeBookInfo), findsNothing);
    expect(find.byType(SoldByView), findsNothing);

    final bookButton = find.byWidgetPredicate((widget) => widget is InkWell && widget.key == ValueKey("PushBookPageInkWell"));
    expect(bookButton, findsOneWidget);
    await tester.tap(bookButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(HomeBookInfo), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Book general info"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Sold by"), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Exchanged by"), findsOneWidget);
    expect(find.byType(SoldByView), findsOneWidget);

    expect(find.byType(ViewBookPage), findsNothing);

    final soldByBookButton = find.byType(InkWell).at(2);
    await tester.tap(soldByBookButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(ViewBookPage), findsOneWidget);

    expect(find.byType(BuyBooks), findsNothing);

    final buyButton = find.byWidgetPredicate((widget) => widget is FloatingActionButton && widget.heroTag == "purchaseBtn");
    await tester.tap(buyButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.byType(BuyBooks), findsOneWidget);

    final shippingModeButton = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Shipping mode");
    await tester.tap(shippingModeButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final expressCourierButton = find.byWidgetPredicate((widget) => widget is Text && widget.data == "express courier");
    await tester.tap(expressCourierButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final addShippingAddressButton = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Add shipping address");
    await tester.tap(addShippingAddressButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    final addNewShippingAddressButton = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Add new shipping address");
    await tester.tap(addNewShippingAddressButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final nameAndSurnameField = find.byType(TextFormField).first;
    final address1Field = find.byType(TextFormField).at(1);
    final address2Field = find.byType(TextFormField).at(2);
    final capField = find.byType(TextFormField).at(3);
    final cityField = find.byType(TextFormField).last;
    final dropDownButton = find.byWidgetPredicate((widget) => widget.key == ValueKey('DropDownButton'));

    await tester.tap(dropDownButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.data == "Italy").last);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    await tester.enterText(nameAndSurnameField, "name surname");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(address1Field, "address 1");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(address2Field, "address 2");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(capField, "00000");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(cityField, "city");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final confirmNewShippingAddressButton = find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_outlined);
    await tester.tap(confirmNewShippingAddressButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 2));

    final newlyInsertedAddressButton = find.byType(RadioListTile);
    await tester.tap(newlyInsertedAddressButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));


    final paymentModeButton = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Add payment method");
    await tester.tap(paymentModeButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final addNewPaymentModeButton = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Add new card");
    await tester.tap(addNewPaymentModeButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    final nameAndSurnamePaymentField = find.byType(TextFormField).first;
    final cardNumberField = find.byType(TextFormField).at(1);
    final expiringDateField = find.byType(TextFormField).at(2);
    final cvvField = find.byType(TextFormField).last;

    await tester.enterText(nameAndSurnamePaymentField, "name surname");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(cardNumberField, "0000 0000 0000 0000");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(expiringDateField, "03/22");
    await tester.pump();
    await tester.pump(Duration(seconds: 1));
    await tester.enterText(cvvField, "000");
    await tester.pump();

    final confirmNewPaymentCardButton = find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_outlined);
    await tester.tap(confirmNewPaymentCardButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 2));

    final newlyInsertedPaymentButton = find.byType(RadioListTile);
    await tester.tap(newlyInsertedPaymentButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));


    final payButton = find.byWidgetPredicate((widget) => widget is Text && widget.data == "Pay");
    await tester.tap(payButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 4));
    final confirmPayButton = find.byWidgetPredicate((widget) => widget is Text && widget.data == "YES");
    await tester.tap(confirmPayButton);
    await tester.pump();
    await tester.pump(Duration(seconds: 4));

    assert (Utils.mockedInsertedBooks.length == 0);
    assert (Utils.mockedInsertedBooksMap.length == 0);

    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}