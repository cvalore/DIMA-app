import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addUserReview.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/modifyProfile/modifyProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('modify profile info', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();

    tester.binding.window.physicalSizeTestValue = Size(10000, 12000); //set dim to be portrait and not landscape

    CustomUser user = CustomUser('uid', username: 'Alessio', userProfileImageURL: '', fullName: 'Alessio Russo', birthday: '06/02/1997',
      city: 'Paduli', bio: 'Love the sun shining');

    ModifyProfileMainPage modifyProfileMainPage = ModifyProfileMainPage(user: user);

    await tester.pumpWidget(MaterialApp(home: modifyProfileMainPage));

    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(4));
    expect(find.text('Alessio Russo'), findsOneWidget);
    expect(find.text('06/02/1997'), findsOneWidget);
    expect(find.text('Paduli'), findsOneWidget);
    expect(find.text('Love the sun shining'), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Icon && widget.icon == Icons.check_outlined), findsOneWidget);


  });

}