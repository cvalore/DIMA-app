import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/forum/newDiscussionPageFloatingButton.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';


class NewDiscussionPage extends StatefulWidget {

  final DatabaseService db;
  final Function() updateDiscussionView;

  const NewDiscussionPage({Key key, this.db, this.updateDiscussionView}) : super(key: key);

  @override
  _NewDiscussionPageState createState() => _NewDiscussionPageState();
}

class _NewDiscussionPageState extends State<NewDiscussionPage> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  String _title = '';

  int _dropdownValue = 0;
  String _dropdownLabel = forumDiscussionCategories[0];

  GlobalKey<FormState> getKey() {
    return _formKey;
  }

  String getTitle() {
    return _title;
  }

  String getDropdownLabel() {
    return _dropdownLabel;
  }

  DatabaseService getDb() {
    return widget.db;
  }

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Scaffold(
        appBar: AppBar(
          title: Text('Forum discussion'),
        ),
        floatingActionButton: NewDiscussionPageFloatingButton(
          getFormKey: getKey,
          getTitle: getTitle,
          getDropdownLabel: getDropdownLabel,
          getDb: getDb,
          updateDiscussionView: widget.updateDiscussionView,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 28.0, 0.0, 16.0),
                  child: Text("Start a new discussion!", style: TextStyle(fontSize: _isTablet ? 19.0 : 16.0),),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: _isTablet ? 180.0 : 32.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: _isTablet ? 18.0 : 16.0,
                        //color: Colors.white
                      ),
                      labelText: "Title",
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
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
                    style: TextStyle(fontSize: _isTablet ? 18.0 : 16.0),
                    validator: (value) =>
                    value.isEmpty
                        ?
                    'Enter a valid title' : null,
                    onChanged: (value) {
                      if(value != '') {
                        setState(() {
                          _title = value;
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("On forum's thread",style: TextStyle(fontSize: _isTablet ? 18.0 : 16.0),),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        DropdownButton(
                          key: UniqueKey(),
                          dropdownColor: Colors.grey[700],
                          elevation: 0,
                          value: _dropdownValue,
                          selectedItemBuilder: (BuildContext context) {
                            List<Widget> items = [];
                            for(int i = 0; i < forumDiscussionCategories.length; i++)
                              items.add(
                                Center(
                                    child: Container(
                                        width: 150,
                                        alignment: AlignmentDirectional.center,
                                        child: Text(forumDiscussionCategories[i], textAlign: TextAlign.center,style: TextStyle(fontSize: _isTablet ? 18.0 : 16.0),)
                                    )
                                ),
                              );
                            return items;
                          },
                          items: [
                            for(int i = 0; i < forumDiscussionCategories.length; i++)
                              DropdownMenuItem(
                                value: i,
                                child: Text(forumDiscussionCategories[i], textAlign: TextAlign.center,style: TextStyle(fontSize: _isTablet ? 18.0 : 16.0),),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _dropdownValue = value;
                              _dropdownLabel = forumDiscussionCategories[value];
                            });
                          },
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}