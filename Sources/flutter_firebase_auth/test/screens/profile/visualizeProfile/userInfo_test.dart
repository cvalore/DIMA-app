
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/review.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/chat/chatPageBody.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/userInfo.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('visualize my profile without reviews', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    final _childKey = GlobalKey();

    tester.binding.window.physicalSizeTestValue = Size(1000, 1200); //set dim to be portrait and not landscape

    CustomUser user = CustomUser('uid', username: 'Alessio', userProfileImageURL: '', bio: 'Love adventure books', followers: 120, following: 20, averageRating: 3.5, city: 'Paduli', fullName: 'Alessio Russo', birthday: '06/02/1997', email: 'aleruss97@gmail.com');

    await tester.pumpWidget(MaterialApp(home: Scaffold(
        appBar: AppBar(title: Text('test'),),
        body: UserInfo(user: user, self: true)),
    ));

    expect(find.byWidgetPredicate((widget) => widget is InkWell), findsNWidgets(5));
    expect(find.byWidgetPredicate((widget) => widget is ListTile), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is ElevatedButton), findsNothing);

    expect(find.text('Alessio'), findsOneWidget);
    expect(find.text('Alessio Russo'), findsOneWidget);
    expect(find.text('Love adventure books'), findsOneWidget);
    expect(find.text('120  followers'), findsOneWidget);
    expect(find.text('20  following'), findsOneWidget);
    expect(find.text('Paduli'), findsOneWidget);
    expect(find.text('aleruss97@gmail.com'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.email_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_half_outlined), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.email_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.people_alt_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.drive_file_rename_outline), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.place_outlined), findsOneWidget);

  });

  testWidgets('visualize my profile with received reviews', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    final _childKey = GlobalKey();

    tester.binding.window.physicalSizeTestValue = Size(1000, 1100); //set dim to be portrait and not landscape

    CustomUser user = CustomUser('uid', username: 'Alessio', userProfileImageURL: '', bio: 'Love adventure books', followers: 120, following: 20, averageRating: 3.5, city: 'Paduli', fullName: 'Alessio Russo', birthday: '06/02/1997', email: 'aleruss97@gmail.com', receivedReviews: [ReceivedReview()]);

    await tester.pumpWidget(MaterialApp(home: Scaffold(
        appBar: AppBar(title: Text('test'),),
        body: UserInfo(user: user, self: true)),
    ));

    expect(find.byWidgetPredicate((widget) => widget is InkWell), findsNWidgets(5));
    expect(find.byWidgetPredicate((widget) => widget is ListTile), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is ElevatedButton), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_half_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNWidgets(3));
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsOneWidget);

  });



  testWidgets('visualize other users\' profile', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser('uid Carmelo');
    Utils.databaseService = DatabaseService();

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000);

    CustomUser user = CustomUser('uid Alessio', username: 'Alessio', userProfileImageURL: '', bio: 'Love adventure books', followers: 120, following: 20, averageRating: 3.5, city: 'Paduli', fullName: 'Alessio Russo',
        birthday: '06/02/1997', email: 'aleruss97@gmail.com', usersFollowingMe: []);

    StreamController<AuthCustomUser> _authStreamController1 = StreamController<AuthCustomUser>();

    await tester.pumpWidget(MaterialApp(home: StreamProvider(
      create: (BuildContext c) {
        return _authStreamController1.stream;
      },
      child: Scaffold(
          appBar: AppBar(title: Text('test'),),
          body: UserInfo(user: user, self: false)),
    ),
    ));

    expect(find.byWidgetPredicate((widget) => widget is InkWell), findsNWidgets(8));
    expect(find.byWidgetPredicate((widget) => widget is ListTile), findsNWidgets(4));
    expect(find.byWidgetPredicate((widget) => widget is ElevatedButton), findsNWidgets(3));

    expect(find.text('Alessio'), findsOneWidget);
    expect(find.text('Alessio Russo'), findsOneWidget);
    expect(find.text('Love adventure books'), findsOneWidget);
    expect(find.text('120  followers'), findsOneWidget);
    expect(find.text('20  following'), findsOneWidget);
    expect(find.text('Paduli'), findsOneWidget);
    expect(find.text('aleruss97@gmail.com'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.email_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_half_outlined), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.star_border), findsNothing);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.email_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.people_alt_outlined), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.drive_file_rename_outline), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.place_outlined), findsOneWidget);
    expect(find.text('FOLLOW'), findsOneWidget);
    expect(find.text('UNFOLLOW'), findsNothing);
    expect(find.text('CHAT'), findsOneWidget);
    expect(find.text('REVIEW'), findsOneWidget);

    // test follow unfollow
    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'FOLLOW'), findsOneWidget);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'FOLLOW'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('120  followers'), findsNothing);
    expect(find.text('121  followers'), findsOneWidget);

    expect(find.text('FOLLOW'), findsNothing);
    expect(find.text('UNFOLLOW'), findsOneWidget);

    expect(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'UNFOLLOW'), findsOneWidget);
    await tester.tap(find.byWidgetPredicate((widget) => widget is Text && widget.data == 'UNFOLLOW'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('121  followers'), findsNothing);
    expect(find.text('120  followers'), findsOneWidget);

    expect(find.text('UNFOLLOW'), findsNothing);
    expect(find.text('FOLLOW'), findsOneWidget);

  });

}