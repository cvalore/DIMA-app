import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/searchBookForm.dart';

class SearchBookPage extends StatefulWidget {
  @override
  _SearchBookPageState createState() => _SearchBookPageState();
}

class _SearchBookPageState extends State<SearchBookPage> {

  final _formKey = GlobalKey<FormState>();

  String _title = 'narnia';
  String _author = 'lewis';
  bool searchButtonPressed = false;   //check needed to display 'No results found'

  void setTitle(String title) {
    _title = title;
  }

  void setAuthor(String author) {
    _author = author;
  }

  GlobalKey getFormKey() {
    return _formKey;
  }

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: -100 + (_isTablet ? MediaQuery.of(context).size.width/2 : MediaQuery.of(context).size.width),
                    child: SearchBookForm(
                      setTitle: setTitle,
                      setAuthor: setAuthor,
                      getKey: getFormKey,
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: FloatingActionButton(
                        heroTag: "searchBookBtn",
                        elevation: 0.0,
                        focusElevation: 0.0,
                        hoverElevation: 0.0,
                        highlightElevation: 0.0,
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.search, color: Colors.white,size: 35.0),
                        onPressed: () {
                          print("TODO: search for: " + _title + " by " + _author);
                        }
                    ),
                  ),
                ],
              )
          ),
          Flexible(
            flex: 2,
            child: ExpansionTile(
              title: Text("Filter result"),
              children: <Widget>[
                Text("TODO"),
                Text("TODO"),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: ExpansionTile(
              title: Text("Order by"),
              children: <Widget>[
                Text("TODO"),
                Text("TODO"),
              ],
            ),
          ),
          /*Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Order by", style: TextStyle(fontSize: 16.0),),
                  Text("TODO: check box", style: TextStyle(fontSize: 16.0),),
                ],
              ),
            ),
          ),*/
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(height: 2.0, thickness: 2.0, indent: 12.0, endIndent: 12.0,))
        ],
      ),
    );
  }
}
