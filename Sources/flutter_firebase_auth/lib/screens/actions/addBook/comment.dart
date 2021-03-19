import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';



class Comment extends StatefulWidget {

  InsertedBook insertedBook;
  double height;

  Comment({Key key, @required this.insertedBook, @required this.height}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        child: GestureDetector(
          onTap: () async {
            dynamic result = await Navigator.pushNamed(context, CommentBox.routeName, arguments: widget.insertedBook.comment);
            setState(() {
              if(result != null)
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
                                fontSize: 20,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      widget.insertedBook.comment != null && widget.insertedBook.comment != '' ?
                      Expanded(
                          flex: 3,
                          child: Text(
                              showComment(widget.insertedBook.comment),
                              textAlign: TextAlign.right)) :
                      Container(),
                    ],
                  )
              ),
              Expanded(
                  flex: 1,
                  child: Icon(Icons.arrow_forward_ios),
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

class CommentBox extends StatefulWidget {
  static const routeName = '/commentBox';
  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {

  String comment = '';

  @override
  Widget build(BuildContext context) {

    final String args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Book comment"),
      ),
      floatingActionButton : FloatingActionButton(
        heroTag: "saveCommentButt",
        child: Icon(Icons.check_outlined),
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.pop(context, comment);
        },
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Card(
              color: Colors.white10,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: args,
                  maxLines: 8,
                  decoration: InputDecoration.collapsed(hintText: "Enter your comment here"),
                  onChanged: (value) {
                    setState(() {
                      comment = value;
                    });
                  },
                ),
              )
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
        ],
      ),
    );
  }
}
