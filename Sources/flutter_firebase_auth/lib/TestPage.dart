import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/models/insertedBook.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addBookSelection.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/addImage.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/descriptionBox.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bottomThreeDots.dart';
import 'package:flutter_firebase_auth/screens/actions/addBook/bookStatus.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();

  //static _TestPageState of(BuildContext context) => context.findAncestorStateOfType<_TestPageState>();
}

class _TestPageState extends State<TestPage> {

  final PageController controller = PageController();
  int currentPageValue = 0;
  final pageViewSize = 3;
  dynamic _selected;
  DatabaseService _db;

  void setSelected(dynamic sel) {
    setState(() {
      _selected = sel;
    });
  }

  @override
  Widget build(BuildContext context) {

    CustomUser user = Provider.of<CustomUser>(context);
    _db = DatabaseService(user: user);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        elevation: 0.0,
        title: changeAppBar(currentPageValue),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: currentPageValue == pageViewSize - 1 ?
          FloatingActionButton.extended(
            heroTag: "saveBtn",
            onPressed: () {
              //TODO
              BookGeneralInfo bookGeneralInfo = BookGeneralInfo(
                  _selected['volumeInfo']['title'],
                  _selected['volumeInfo']['authors'].toString(),
                  _selected['volumeInfo']['imageLinks']['thumbnail'],
                  'fake isbn',
                  _selected['volumeInfo']['language']
                  );
              InsertedBook insertedBook = InsertedBook(
                  _selected['volumeInfo']['title'],
                  _selected['volumeInfo']['authors'].toString(),
                  'fake isbn',
                  5);
              insertedBook.addBookGeneralInfo(bookGeneralInfo);
              _db.addUserBook(insertedBook);
            },
            icon: Icon(Icons.save),
            label: Text("Save"),
          ) : null,
      body: _selected != null ?
        PageView(
          controller: controller,
          onPageChanged: (index) {
            print("the index is $index");
            setState(() {
              currentPageValue = index;
            });
          },
          children: <Widget>[
            AddBookSelection(setSelected: setSelected, selected: _selected, showDots: true, controller: controller),
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
                  ImageService(),
                  customSizedBox(1.0),
                  BookStatus(height: 60),
                  customSizedBox(1.0),
                  DescriptionBox(height: 60),
                  customSizedBox(1.0),
                  //backAndForthButtons(60),
                  BottomThreeDots(darkerIndex: 2, size: 9.0,)     //TODO sistemare la posizione dei dots qui
                ],
              ),
            ),
            /*
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

             */
          ],
        ) :
        PageView(
          controller: controller,
          children: <Widget>[
            AddBookSelection(setSelected: setSelected, selected: _selected, showDots: false,),
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
