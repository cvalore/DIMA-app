import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("Sign up test with email and password example", (WidgetTester tester) async {
    final Finder signUpEmailField = find.byKey(Key('signUpEmailField'));
    final Finder signUpPasswordField = find.byKey(Key('signUpPasswordField'));
    final Finder signUpButton = find.byKey(Key('signUpButton'));

    await tester.pumpWidget(App());

    await tester.pumpAndSettle();

    await tester.tap(signUpEmailField);
    await tester.enterText(signUpEmailField, "test@gmail.com");

    await tester.tap(signUpPasswordField);
    await tester.enterText(signUpPasswordField, "123456");

    await tester.tap(signUpButton);
    print("button tapped");
    await tester.pumpAndSettle(Duration(seconds: 1));

    // in subscribe page
    expect(find.byType(Container), findsNWidgets(2));
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'username');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byType(TextButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(
        find.byWidgetPredicate((widget) =>
        widget is AppBar &&
            widget.title is Text &&
            (widget.title as Text).data.startsWith("ToDoApp")),
        findsOneWidget);

    await tester.pumpAndSettle(Duration(seconds: 1));
  });
}
