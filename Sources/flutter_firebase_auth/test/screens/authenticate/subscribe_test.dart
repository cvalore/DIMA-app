import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/authenticate/subscribe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add username when signing up', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    Map<String,WidgetBuilder> routes = <String,WidgetBuilder>{
      Subscribe.routeName: (context) => Subscribe()
    };
    await tester.pumpWidget(MaterialApp(routes: routes, home:Subscribe()));

    expect(find.byType(Container), findsNWidgets(2));
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'username');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final SubscribeState subscribeState = tester.state(find.byType(Subscribe));
    assert (subscribeState.username == 'username');

  });

}
