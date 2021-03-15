import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';

class Status extends StatefulWidget {

  InsertedBook insertedBook;
  double height;
  double offset;

  Status({Key key, @required this.insertedBook, @required this.height, @required this.offset}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Row(
        children: [
          Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Status",
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
          ),
          Expanded(
              flex: 6,
              child: Row(
                children: [
                  for(int i = 0; i < 5; i++)
                    Container(
                      width: (MediaQuery.of(context).size.width - widget.offset) / 10,
                      child: IconButton(
                        padding: EdgeInsets.symmetric(vertical: 1.0),
                        icon: widget.insertedBook.status > i ? Icon(Icons.star, color: Colors.yellow,) : Icon(Icons.star_border, color: Colors.yellow,),
                        onPressed: () {
                          setState(() {
                            widget.insertedBook.setStatus(i + 1);
                          });
                        })
                    )
                ],
              )
          )
        ],
      )
    );
  }
}
