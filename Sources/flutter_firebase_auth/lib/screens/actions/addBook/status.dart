import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

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

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Container(
      height: widget.height,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Status",
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            )
          ),
          Flexible(
            flex: _isTablet ? 2 : 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for(int i = 0; i < 5; i++)
                      IconButton(
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
                      )
                  ],
                ),

          )
        ],
      )
    );
  }
}
