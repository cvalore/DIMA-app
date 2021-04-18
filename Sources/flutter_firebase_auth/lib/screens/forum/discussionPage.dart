import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/forumDiscussion.dart';
import 'package:flutter_firebase_auth/models/forumMessage.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
import 'package:provider/provider.dart';

class DiscussionPage extends StatefulWidget {

  ForumDiscussion discussion;

  DiscussionPage({Key key, this.discussion}) : super(key: key);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {

  final GlobalKey<FormState> _messageFormKey = GlobalKey();
  final _messageFormFieldController = TextEditingController();

  String _message = "";

  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(
        userFromAuth != null ? userFromAuth.uid : "",
        email: userFromAuth != null ? userFromAuth.email : "",
        isAnonymous: userFromAuth != null ? userFromAuth.isAnonymous : false);
    DatabaseService _db = DatabaseService(user: user);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.discussion.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          widget.discussion.messages.length == 0 ?
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No messages yet", style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),),
                  Icon(Icons.message),
                ],
              ),
            ),
          ) :
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Text("TODO: messages");
              },
            ),
          ),
          ManuallyCloseableExpansionTile(
            initiallyExpanded: true,
            title: Text("Send a new message on this discussion!"),
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Form(
                      key: _messageFormKey,
                      child: Flexible(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                          child: Container(
                            //width: MediaQuery.of(context).size.width / 1.5,
                            child: TextFormField(
                              controller: _messageFormFieldController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(fontSize: 16,
                                  //color: Colors.white
                                ),
                                labelText: "Message",
                                contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                //hintStyle: TextStyle(color: Colors.white,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(7.0),),
                                  //borderSide: BorderSide(color: Colors.white)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  //borderSide: BorderSide(color: Colors.white)
                                ),
                                filled: true,
                                //fillColor: Colors.white24,
                              ),
                              validator: (value) =>
                              value.isEmpty
                                  ?
                              'Enter a valid message' : null,
                              onChanged: (value) {
                                setState(() {
                                  _message = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () async {
                          List<ForumMessage> messages = await _db.addMessage(_message, widget.discussion);
                          setState(() {
                            _messageFormFieldController.clear();
                            widget.discussion.messages = messages;
                          });
                        },
                        shape: CircleBorder(side: BorderSide(width: 2, color: Colors.white, style: BorderStyle.solid)),
                        child: Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
