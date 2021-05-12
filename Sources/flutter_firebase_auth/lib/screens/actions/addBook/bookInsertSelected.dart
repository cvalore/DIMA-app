import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/saveButtonAddBook.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/loading.dart';

import 'addBookSelection.dart';
import 'addBookUserInfo.dart';

class BookInsertSelected extends StatefulWidget {

  InsertedBook insertedBook;
  BookGeneralInfo selectedBook;
  int currentPageValue = 0;
  final pageViewSize = 2;
  DatabaseService db;
  final Function clearFields;

  BookInsertSelected({Key key, this.db, this.selectedBook, this.insertedBook, this.clearFields}) : super(key: key);

  @override
  _BookInsertSelectedState createState() => _BookInsertSelectedState();
}

class _BookInsertSelectedState extends State<BookInsertSelected> {

  final PageController controller = PageController();

  bool loading = false;
  void setLoading(bool newValue) {
    setState(() {
      loading = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.black,
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text('Insert book - ' + widget.selectedBook.title.toString(), style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
          letterSpacing: 1.0,
        ),),
      ),
      floatingActionButton: (widget.currentPageValue == widget.pageViewSize - 1) ?
      SaveButtonAddBook(
        insertedBook: widget.insertedBook,
        db: widget.db,
        selectedBook: widget.selectedBook,
        edit: false,
        editIndex: -1,
        updateBook: null,
        clearFields: widget.clearFields,
        setLoading: setLoading,
      ) : null,
      body: Builder(
          builder: (BuildContext context) {
            return loading ? Loading() : PageView(
              controller: controller,
              onPageChanged: (index) {
                //print("the index is $index");
                setState(() {
                  widget.currentPageValue = index;
                  //print("Setting current page value to " + widget.currentPageValue.toString());
                  //print("Eq " + (widget.currentPageValue == widget.pageViewSize - 1 ? "True" : "False"));
                });
              },
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(_isTablet ? 100.0 : 0.0, _isTablet ? 32.0 : 0.0, _isTablet ? 100.0 : 0.0, 0.0),
                  child: AddBookSelection(
                    setSelected: null, //non dovrebbe importare
                    selectedBook: widget.selectedBook,
                    showDots: true,
                    appBarHeight: Scaffold.of(context).appBarMaxHeight,
                    showGeneralInfo: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(_isTablet ? 100.0 : 0.0, _isTablet ? 32.0 : 0.0, _isTablet ? 100.0 : 0.0, 0.0),
                  child: AddBookUserInfo(
                    insertedBook: widget.insertedBook,
                    isInsert: true,
                    appBarHeight: Scaffold.of(context).appBarMaxHeight,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
