import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';

class Status extends StatefulWidget {

  InsertedBook insertedBook;
  double height;
  double offset;
  bool justView;

  Status({Key key, @required this.insertedBook, @required this.height, @required this.offset, @required this.justView}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Container(
      height: widget.height,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Status",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            )
          ),
          Flexible(
            flex: _isTablet ? 2 : 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for(int i = 0; i < 5; i++)
                        Container(
                          padding: EdgeInsets.all(5.0),
                          width: 30.0,
                          child: IconButton(
                            key: ValueKey(i),
                            splashRadius: 10,
                            icon: widget.insertedBook.status > i ?
                              Icon(Icons.star, color: Colors.yellow,) :
                              Icon(Icons.star_border, color: Colors.yellow,),
                            onPressed: () {
                              if(!widget.justView) {
                                setState(() {
                                  widget.insertedBook.setStatus(i + 1);
                                });
                              }
                            }
                          ),
                        )
                    ],
                  ),
                ),
          )
        ],
      )
    );
  }
}
