import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addNewPaymentMethod.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addNewShippingInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addPaymentMethod.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addShippingInfo.dart';
import 'package:flutter_firebase_auth/screens/profile/paymentInfo/savedPaymentMethod.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('view visualize profile from profile main page', (WidgetTester tester) async {

    Utils.mockedDb = true;
    Utils.mySelf = CustomUser("");
    Utils.databaseService = DatabaseService();
    final _childKey = GlobalKey();

    tester.binding.window.physicalSizeTestValue = Size(500, 800); //set dim to be portrait and not landscape

    StreamController<CustomUser> _userStreamController = StreamController<CustomUser>();
    CustomUser user = CustomUser('uid', userProfileImageURL: '', username: 'Alessio');

    await tester.pumpWidget(MaterialApp(home: StreamProvider(
        create: (BuildContext context) {
          return _userStreamController.stream;
        },
        child: Scaffold(appBar: AppBar(title: Text('test'),),body: VisualizeProfile(key :_childKey, height: 100.0))),
    ));

    expect(Provider.of<CustomUser>(_childKey.currentContext, listen: false), isNull);
    expect(find.byType(Container), findsOneWidget);

    _userStreamController.add(user);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is InkWell), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Expanded), findsNWidgets(4));
    expect(find.byType(Icon), findsOneWidget);
    expect(find.text('Alessio'), findsOneWidget);

    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byWidgetPredicate((widget) => widget is Expanded), findsNWidgets(4));
    expect(find.byType(CircleAvatar), findsOneWidget);

  });

}