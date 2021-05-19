import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/favorites/favoritesMainPage.dart';
import 'package:flutter_firebase_auth/screens/profile/paymentInfo/savedPaymentMethod.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('view payment methods from profile', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    dynamic book = {
      "title" : "title",
      "author" : "author",
      "price" : 9.99,
      "exchangeStatus" : "",
      "exchangeable" : false,
      "likedBy" : [],
      "thumbnail": '',
      "insertionNumber" : 1,
      "imagesUrl" : [],
      "status" : 3,
    };

    await tester.pumpWidget(MaterialApp(home: FavoritesMainPage(likedBooks: [book])));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.text('My favorites'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is InkWell), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Card), findsOneWidget);
    expect(find.text('title'), findsOneWidget);
    expect(find.text('author'), findsOneWidget);
    expect(find.text('Add all your favorite books here!'), findsNothing);

  });

}