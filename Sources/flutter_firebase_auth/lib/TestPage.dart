import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/actions/addBookSelection.dart';
import 'package:flutter_firebase_auth/screens/actions/addImage.dart';
import 'package:flutter_firebase_auth/services/googleBooksAPI.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bottomThreeDots.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();

  //static _TestPageState of(BuildContext context) => context.findAncestorStateOfType<_TestPageState>();
}

class _TestPageState extends State<TestPage> {

  final PageController controller = PageController();
  dynamic _selected;

  void setSelected(dynamic sel) {
    setState(() {
      _selected = sel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        title: Text('Insert book'),
      ),
      resizeToAvoidBottomInset: false,
      body: _selected != null ?
        PageView(
          controller: controller,
          children: <Widget>[
            AddBookSelection(setSelected: setSelected, selected: _selected, showDots: true,),
            Container(
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  BottomThreeDots(darkerIndex: 1, size: 9.0,),
                ]
              )
            ),
            Container(
              // container containing the addImage section
                padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      BottomThreeDots(darkerIndex: 2, size: 9.0,),
                    ]
                )
            ),
          ],
        ) :
        PageView(
          controller: controller,
          children: <Widget>[
            AddBookSelection(setSelected: setSelected, selected: _selected, showDots: false,),
          ],
        )
    );
  }
}
