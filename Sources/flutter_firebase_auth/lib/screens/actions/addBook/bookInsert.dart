import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookSelection.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookUserInfo.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookInsertSelected.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/saveButtonAddBook.dart';
import 'package:flutter_firebase_auth/services/auth.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:provider/provider.dart';

class BookInsert extends StatefulWidget {

  InsertedBook insertedBook;
  final bool edit;
  BookGeneralInfo selectedBook;
  final int editIndex;
  final Function(InsertedBook) updateBook;

  int currentPageValue = 0;
  final pageViewSize = 2;


  BookInsert({Key key, this.selectedBook, this.insertedBook, this.edit, this.editIndex, this.updateBook}) : super(key: key);

  @override
  _BookInsertState createState() => _BookInsertState();

  //static _TestPageState of(BuildContext context) => context.findAncestorStateOfType<_TestPageState>();
}

class _BookInsertState extends State<BookInsert> {

  final PageController controller = PageController();

  bool _isTablet;
  DatabaseService _db;

  void setSelected(dynamic sel) {
    setState(() {
      widget.selectedBook = sel;
      if(sel == null) {
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (newContext) => BookInsertSelected(
                db: _db,
                insertedBook: widget.insertedBook,
                selectedBook: widget.selectedBook,
              )
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    _db = DatabaseService(user: user);
    _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.black,
      appBar: AppBar(
        //backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(widget.edit ? widget.insertedBook.title.toString() : 'Insert book', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
          letterSpacing: 1.0,
        ),),
      ),
      floatingActionButton:
        ((_isTablet && widget.selectedBook != null) || widget.edit) ?
        SaveButtonAddBook(
          insertedBook: widget.insertedBook,
          db: _db,
          selectedBook: widget.selectedBook,
          edit: widget.edit,
          editIndex: widget.editIndex,
          updateBook: widget.updateBook,
        ) : null,
      body: Builder(
        builder: (BuildContext context) {
        return
            (widget.edit ?
              AddBookUserInfo(
                insertedBook: widget.insertedBook,
                isInsert: false,
                appBarHeight: Scaffold.of(context).appBarMaxHeight,
              ) :
              PageView(
                controller: controller,
                children: <Widget>[
                  AddBookSelection(
                    setSelected: setSelected,
                    selectedBook: widget.selectedBook,
                    showDots: false,
                    appBarHeight: Scaffold.of(context).appBarMaxHeight,
                    showGeneralInfo: false,
                  ),
                ],
              )
            );
      }),
    );
  }
}
