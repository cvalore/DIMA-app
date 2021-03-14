import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';



class CommentBox extends StatefulWidget {

  InsertedBook insertedBook;
  double height;

  CommentBox({Key key, @required this.insertedBook, @required this.height}) : super(key: key);

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: ListTile(
        title: Text(
          "Comment",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () async {
          dynamic result = await Navigator.pushNamed(context, Comment.routeName, arguments: widget.insertedBook.comment);
          setState(() {
            if(result != null)
              widget.insertedBook.comment = result;
          });
        },
      ),
    );
  }
}

class Comment extends StatefulWidget {
  static const routeName = '/comment';
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {

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
          //print(comment);
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

