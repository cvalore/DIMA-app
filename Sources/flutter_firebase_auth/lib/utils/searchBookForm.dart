import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';

class SearchBookForm extends StatelessWidget {

  final Function(String title) setTitle;
  final Function(String author) setAuthor;
  final Function() getKey;

  const SearchBookForm({Key key, this.setTitle, this.setAuthor, this.getKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Form(
      key: getKey(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0,),
              child: TextFormField(
                  cursorColor: Colors.black,
                  //decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.white)
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: _isTablet ? 21.0 : 17.0,),
                  initialValue: '',
                  validator: (value) =>
                  value.isEmpty ? 'Enter the book title' : null,
                  onChanged: (value) {
                    setTitle(value);
                  }
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(height: 5.0,),
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0,),
              child: TextFormField(
                  cursorColor: Colors.black,
                  //decoration: inputFieldDecoration.copyWith(hintText: 'Author'),
                  decoration: InputDecoration(
                    hintText: 'Author',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(7.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.white)
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: _isTablet ? 21.0 : 17.0),
                  initialValue: '',
                  validator: (value) =>
                  value.isEmpty ? 'Enter the book author' : null,
                  onChanged: (value) {
                    setAuthor(value);
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
