import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookStatus extends StatefulWidget {

  double height;

  BookStatus({Key key, @required this.height}) : super(key: key);

  @override
  _BookStatusState createState() => _BookStatusState();
}

class _BookStatusState extends State<BookStatus> {

  int status = 1;

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
                      width: MediaQuery.of(context).size.width / 10,
                      child: IconButton(
                        padding: EdgeInsets.symmetric(vertical: 1.0),
                        icon: status > i ? Icon(Icons.star, color: Colors.yellow,) : Icon(Icons.star_border, color: Colors.yellow,),
                        onPressed: () {
                          setState(() {
                            status = i + 1;
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
