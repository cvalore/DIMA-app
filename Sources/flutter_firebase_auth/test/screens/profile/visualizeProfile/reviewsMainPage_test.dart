import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/receivedReviews.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/reviewsMainPage.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/reviewsWrittenByMe.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('visualize my reviews on my profile', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    DateTime reviewTime = DateTime.now();

    List<ReceivedReview> receivedReviews = [ReceivedReview(review: 'book in good conditions', stars: 4, reviewerUid: 'reviewerUid', time: reviewTime),
      ReceivedReview(review: 'shipping was fine', stars: 5, reviewerUid: 'reviewerUid2', time: reviewTime)];

    List<ReviewWrittenByMe> reviewWrittenByMe = [ReviewWrittenByMe(review: 'life changing book', stars: 5, reviewedUid: 'ManuelUid', reviewedUsername: 'Manuel', reviewedImageProfileURL: '', time: reviewTime)];

    await tester.pumpWidget(MaterialApp(home: ReviewsMainPage(receivedReviews: receivedReviews, reviewsWrittenByMe: reviewWrittenByMe, self: true)),);


    expect(find.byWidgetPredicate((widget) => widget is Scaffold), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is BottomNavigationBar), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.download_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.upload_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is ReceivedReviews), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is ReviewsWrittenByMe), findsNothing);
    expect(find.text('Still no reviews'), findsNothing);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byWidgetPredicate((widget) => widget is Card), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is CircleAvatar), findsNWidgets(2));
    expect(find.text('Carmelo'), findsOneWidget);
    expect(find.text('Francesco'), findsOneWidget);
    expect(find.text('book in good conditions'), findsOneWidget);
    expect(find.text('shipping was fine'), findsOneWidget);
    expect(find.text('Few seconds ago'), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNWidgets(9));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsOneWidget);

    expect(find.text('Sent'), findsOneWidget);
    await tester.tap(find.text('Sent'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byWidgetPredicate((widget) => widget is ReceivedReviews), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is ReviewsWrittenByMe), findsOneWidget);

    expect(find.byWidgetPredicate((widget) => widget is Card), findsNWidgets(1));
    expect(find.byWidgetPredicate((widget) => widget is CircleAvatar), findsNWidgets(1));
    expect(find.text('Carmelo'), findsNothing);
    expect(find.text('Manuel'), findsOneWidget);
    expect(find.text('life changing book'), findsOneWidget);
    expect(find.text('shipping was fine'), findsNothing);
    expect(find.text('Few seconds ago'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNWidgets(5));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsNothing);

  });


  testWidgets('visualize reviews written by me and select them for deletion ', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    DateTime reviewTime = DateTime.now();
    List<ReviewWrittenByMe> reviewsWrittenByMe = [ReviewWrittenByMe(review: 'life changing book', stars: 5, reviewedUid: 'ManuelUid', reviewedUsername: 'Manuel', reviewedImageProfileURL: '', time: reviewTime),
      ReviewWrittenByMe(review: 'book conditions were not as in the pictures', stars: 2, reviewedUid: 'CarmineUid', reviewedUsername: 'Carmine', reviewedImageProfileURL: '', time: reviewTime)];

    await tester.pumpWidget(MaterialApp(theme: ThemeData(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent),
    ),home: Scaffold(body: ReviewsWrittenByMe(reviews: reviewsWrittenByMe))));


    expect(find.byWidgetPredicate((widget) => widget is Scaffold), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.download_outlined), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.upload_outlined), findsNothing);
    expect(find.text('Still no reviews'), findsNothing);

    expect(find.byWidgetPredicate((widget) => widget is Card), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is CircleAvatar), findsNWidgets(2));
    expect(find.text('Carmine'), findsOneWidget);
    expect(find.text('Manuel'), findsOneWidget);
    expect(find.text('life changing book'), findsOneWidget);
    expect(find.text('book conditions were not as in the pictures'), findsOneWidget);
    expect(find.text('Few seconds ago'), findsNWidgets(2));

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Delete'), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank_outlined), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsNothing);

    await tester.longPress(find.text('Carmine'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'Delete'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank_outlined), findsOneWidget);

    await tester.tap(find.text('Manuel'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsNWidgets(2));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank_outlined), findsNothing);

    await tester.tap(find.text('Carmine'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank_outlined), findsOneWidget);

    expect(find.text('YES'), findsNothing);
    expect(find.text('NO'), findsNothing);

    await tester.tap(find.text('Delete'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('YES'), findsOneWidget);
    expect(find.text('NO'), findsOneWidget);
    expect(find.text('The selected reviews will be deleted. Are you sure?'), findsOneWidget);

    await tester.tap(find.text('NO'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    expect(find.text('The selected reviews will be deleted. Are you sure?'), findsNothing);
    expect(find.text('NO'), findsNothing);
    expect(find.text('YES'), findsNothing);

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank_outlined), findsOneWidget);

    await tester.tap(find.text('Manuel'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outlined), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_box_outline_blank_outlined), findsNothing);

  });

}