import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';

class Exchange extends StatefulWidget {

  InsertedBook insertedBook;
  double height;
  bool justView;

  Exchange({Key key, @required this.insertedBook, @required this.height, @required this.justView}) : super(key: key);

  @override
  _ExchangeState createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: GestureDetector(
        onTap: () async {
          if(!widget.justView) {
            setState(() {
              widget.insertedBook.toggleExchangeable();
            });
          }
        },
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Available for exchange",
                  style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: widget.insertedBook.exchangeable ?
                  Icon(Icons.check_box_outlined, color: Colors.white) :
                  Icon(Icons.check_box_outline_blank, color: Colors.white)
              )
          ],
        ),
      ),
    );
  }
}
