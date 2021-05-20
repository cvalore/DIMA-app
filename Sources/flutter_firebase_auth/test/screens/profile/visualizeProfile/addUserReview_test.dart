import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addUserReview.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('add a review for a user', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    CustomUser user = CustomUser('uid', receivedReviews: []);

    Map<String,WidgetBuilder> routes = <String,WidgetBuilder>{
      AddUserReview.routeName: (context) => AddUserReview()
    };

    await tester.pumpWidget(MaterialApp(routes: routes, home: Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AddUserReview.routeName, arguments: user);
            },
            child: Text('Add review'),
          );
        },
      ),
    )));

    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is TextFormField), findsOneWidget);
    expect(find.text('Add a review...'), findsOneWidget);

    await tester.tap(find.byType(Icon).at(3));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNWidgets(4));

    await tester.enterText(find.byType(TextFormField), 'This is my review');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('This is my review'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(user.receivedReviews[0].review, 'This is my review');

  });

}