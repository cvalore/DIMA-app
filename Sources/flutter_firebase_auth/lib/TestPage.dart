import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/actions/addImage.dart';
import 'package:flutter_firebase_auth/services/googleBooksAPI.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bottomThreeDosts.dart';

class TestPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final PageController controller = PageController();

  //String _title = '';
  //String _author = '';
  String _title = 'harry potter'; //just to debug easily,
  String _author = 'rowling'; //just to debug easily,


  final booksAPI = GoogleBooksAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        title: Text('Insert book'),
      ),
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: controller,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  flex:10,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            //decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                            decoration: InputDecoration(
                              hintText: 'Title',
                            ),
                            initialValue: 'harry potter',//just to debug easily,
                            validator: (value) =>
                            value.isEmpty ? 'Enter the book title' : null,
                            onChanged: (value) {
                              _title = value;
                            }
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                              //decoration: inputFieldDecoration.copyWith(hintText: 'Author'),
                              decoration: InputDecoration(
                                hintText: 'Author',
                              ),
                              initialValue: 'rowling',//just to debug easily,
                              validator: (value) =>
                              value.isEmpty ? 'Enter the book author' : null,
                              onChanged: (value) {
                                _author = value;
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(height: 20.0,),
                ),
                Flexible(
                  flex: 35,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(color: Colors.grey[500]),
                      ),
                    ),
                    child: ListView(

                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: FloatingActionButton(
                    elevation: 0.0,
                    focusElevation: 0.0,
                    hoverElevation: 0.0,
                    highlightElevation: 0.0,
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.search, color: Colors.blueGrey[600],size: 35.0),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        print('Searching for \"' + _title + '\" by \"' + _author + '\"');
                        final result = await booksAPI.performSearch(_title, _author);
                        if(result != null) {
                          List<dynamic> items = result['items'];
                          print('Item 1 out of ' + items.length.toString());
                          print(items[0]['volumeInfo']['title']);
                        }
                      }
                    },
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    height: 20.0,
                  ),
                ),
                BottomThreeDots(darkerIndex: 0, size: 9.0,),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                BottomThreeDots(darkerIndex: 1, size: 9.0,),
              ]
            )
          ),
          Container(
            // container containing the addImage section
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    BottomThreeDots(darkerIndex: 2, size: 9.0,),
                  ]
              )
          ),
        ],
      ),
    );
  }
}
