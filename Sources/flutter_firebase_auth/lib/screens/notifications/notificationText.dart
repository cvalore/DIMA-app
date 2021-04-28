import 'package:flutter/material.dart';

class NotificationText extends StatelessWidget {

  final dynamic transaction;

  const NotificationText({Key key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text("TODO: " + transaction['id'] + "\n\n"),);
  }
}
