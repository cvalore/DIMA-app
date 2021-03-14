import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookSelection.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/commentBox.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bottomThreeDots.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookStatus.dart';
import 'package:provider/provider.dart';

class BookInsert extends StatefulWidget {
  @override
  _BookInsertState createState() => _BookInsertState();

  //static _TestPageState of(BuildContext context) => context.findAncestorStateOfType<_TestPageState>();
}

class _BookInsertState extends State<BookInsert> {

  final PageController controller = PageController();
  int currentPageValue = 0;
  final pageViewSize = 3;
  BookGeneralInfo _selectedBook;
  InsertedBook _insertedBook = InsertedBook();
  DatabaseService _db;

  void setSelected(dynamic sel) {
    setState(() {
      _selectedBook = sel;
    });
  }

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    _db = DatabaseService(user: user);

    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        title: changeAppBar(currentPageValue),
      ),*/
      resizeToAvoidBottomInset: false,
      floatingActionButton: currentPageValue == pageViewSize - 1 ?
          FloatingActionButton.extended(
            heroTag: "saveBtn",
            onPressed: () {
              if (_selectedBook.title != null) {
                _insertedBook.setIdTitleAuthorIsbn(
                    _selectedBook.id,
                    _selectedBook.title,
                    _selectedBook.author,
                    _selectedBook.isbn13);
                _insertedBook.setBookGeneralInfo(_selectedBook);
                _insertedBook.printBook();
                _db.addUserBook(_insertedBook);
              }
            },
            icon: Icon(Icons.save),
            label: Text("Save"),
          ) : null,
      body: _selectedBook != null ?
        PageView(
          controller: controller,
          onPageChanged: (index) {
            print("the index is $index");
            setState(() {
              currentPageValue = index;
            });
          },
          children: <Widget>[
            AddBookSelection(setSelected: setSelected, selectedBook: _selectedBook, showDots: true, controller: controller),
            Container(
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  BottomThreeDots(darkerIndex: 1, size: 9.0,),
                ]
              )
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ImageService(insertedBook: _insertedBook),
                  customSizedBox(1.0),
                  BookStatus(insertedBook: _insertedBook, height: 60),
                  customSizedBox(1.0),
                  CommentBox(insertedBook: _insertedBook, height: 60),
                  customSizedBox(1.0),
                  //backAndForthButtons(60),
                  BottomThreeDots(darkerIndex: 2, size: 9.0,)     //TODO sistemare la posizione dei dots qui
                ],
              ),
            ),
          ],
        ) :
        PageView(
          controller: controller,
          children: <Widget>[
            AddBookSelection(setSelected: setSelected, selectedBook: _selectedBook, showDots: false,),
          ],
        )
    );
  }

  Widget changeAppBar(int page) {
    print(page);
      if(page == 0)
        return Text("Insert book");
      else if(page == 1)
        return Text("Book status");
      else if(page == 2)
        return Text("Insert images");
  }

  Widget backAndForthButtons(double height) {

    return Container(
      height: height,
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: currentPageValue == 0 ?
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ) :
                  ElevatedButton (
                    child: Text("Previous"),
                    onPressed: () {
                      if (controller.hasClients) {
                        controller.animateToPage(
                          currentPageValue = currentPageValue - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  )
          ),
          Expanded(
              flex: 6,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
          ),
          Expanded(
              flex: 3,
              child:  currentPageValue == (pageViewSize - 1)  ?
                ElevatedButton (
                  child: Text("Upload"),
                  onPressed: () {
                    //_db.uploadBook();
                  },
                ) :
                ElevatedButton (
                  child: Text("Next"),
                  onPressed: () {
                    if (controller.hasClients) {
                      controller.animateToPage(
                        currentPageValue++,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                )
          ),
        ],
      ),
    );
  }

  Widget customSizedBox(height) {
    return SizedBox(
      height: height,
      child: Container(
        color: Colors.black,
      ),
    );
  }



}
