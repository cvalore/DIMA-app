import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Integration Tests", () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Sign up email and password Test", () async {
      final createAccountButton = find.byValueKey("CreateAccountButton");

      await driver.tap(createAccountButton);

    });

  });
}