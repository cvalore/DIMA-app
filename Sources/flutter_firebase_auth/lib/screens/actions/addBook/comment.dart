import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';



class Comment extends StatefulWidget {

  InsertedBook insertedBook;
  double height;
  bool justView;

  Comment({Key key, @required this.insertedBook, @required this.height, @required this.justView}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        child: InkWell(
          onTap: () async {
            dynamic result = await Navigator.pushNamed(
                context, CommentBox.routeName,
                arguments: CommentBoxArgs(widget.insertedBook.comment, widget.justView));
            setState(() {
              if (result != null)
                widget.insertedBook.setComment(result);
            });
          },
          child: Row(
            children: [
              Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Comment",
                            style: TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      widget.insertedBook.comment != null && widget.insertedBook.comment != '' ?
                      Expanded(
                          flex: 3,
                          child: Text(
                              showComment(widget.insertedBook.comment),
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.white),)) :
                      Container(),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              )
            ],
          ),
        )
    );
  }

  String showComment(String comment) {
    int num_displayed_char = 12;
    int cut_index;
    bool truncated= true;
    if (comment.contains('\n') && comment.indexOf('\n') < num_displayed_char)
      cut_index = comment.indexOf('\n');
    else {
      cut_index = comment.length < num_displayed_char ? comment.length : num_displayed_char;
    }


    return cut_index == comment.length ? comment : comment.substring(0, cut_index) + '...';
  }
}

class CommentBoxArgs {
  final String comment;
  final bool justView;

  CommentBoxArgs(this.comment, this.justView);
}

class CommentBox extends StatefulWidget {
  static const routeName = '/commentBox';
  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {

  String comment = '';

  @override
  Widget build(BuildContext context) {

    final CommentBoxArgs args = ModalRoute.of(context).settings.arguments;
    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        title: Text("Book comment"),
      ),
      //backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      floatingActionButton : args.justView ? null : FloatingActionButton(
        heroTag: "saveCommentButt",
        child: Icon(Icons.check_outlined),
        backgroundColor: Colors.white24,
        onPressed: () {
          Navigator.pop(context, comment);
        },
      ),
      //resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(_isTablet ? 30.0 : 0.0),
        child: Column(
          children: <Widget>[
            Card(
                color: Colors.white24,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: TextFormField(
                    initialValue: args.comment,
                    maxLines: 8,
                    decoration: InputDecoration.collapsed(
                      hintText: "Enter your comment here",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
                        comment = value;
                      });
                    },
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

