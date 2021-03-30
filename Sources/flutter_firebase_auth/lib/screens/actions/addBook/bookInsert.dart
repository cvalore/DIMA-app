import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookSelection.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/saveButtonAddBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/tablet/bookInsertTablet.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/addBookParameters.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:provider/provider.dart';

class BookInsert extends StatefulWidget {

  final AddBookParameters param;
  final void Function(int) setIndex;
  BookGeneralInfo selectedBook;

  BookInsert({Key key, this.param, this.setIndex, this.selectedBook}) : super(key: key);

  @override
  _BookInsertState createState() => _BookInsertState();

  //static _TestPageState of(BuildContext context) => context.findAncestorStateOfType<_TestPageState>();
}

class _BookInsertState extends State<BookInsert> {

  final PageController controller = PageController();
  int currentPageValue = 0;
  final pageViewSize = 2;
  InsertedBook _insertedBook = InsertedBook();

  void setSelected(dynamic sel) {
    setState(() {
      widget.selectedBook = sel;
    });
  }

  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, userFromAuth.email, userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);
    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.black,
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text('Insert book', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
          letterSpacing: 1.0,
        ),),
      ),
      floatingActionButton:
        ((currentPageValue == pageViewSize - 1) || (_isTablet && widget.selectedBook != null)) ?
        SaveButtonAddBook(
            insertedBook: _insertedBook,
            db: _db,
            selectedBook: widget.selectedBook,
            setIndex: widget.setIndex,
          ) : null,
      body: Builder(
        builder: (BuildContext context) {
        return
          _isTablet ?
            BookInsertTablet(
              selectedBook: widget.selectedBook,
              insertedBook: _insertedBook,
              setFatherSelected: setSelected,
            ) :
            widget.selectedBook != null ?
              PageView(
                controller: controller,
                onPageChanged: (index) {
                  //print("the index is $index");
                  setState(() {
                    currentPageValue = index;
                  });
                },
                children: <Widget>[
                  AddBookSelection(
                    setSelected: setSelected,
                    selectedBook: widget.selectedBook,
                    showDots: true,
                    appBarHeight: Scaffold.of(context).appBarMaxHeight,
                  ),
                  AddBookUserInfo(
                    insertedBook: _insertedBook,
                    edit: false,
                    justView: false,
                    appBarHeight: Scaffold.of(context).appBarMaxHeight,
                  ),
                ],
              ) :
              PageView(
                controller: controller,
                children: <Widget>[
                  AddBookSelection(
                    setSelected: setSelected,
                    selectedBook: widget.selectedBook,
                    showDots: false,
                    appBarHeight: Scaffold.of(context).appBarMaxHeight,
                  ),
                ],
              );
      }),
    );
  }
}
