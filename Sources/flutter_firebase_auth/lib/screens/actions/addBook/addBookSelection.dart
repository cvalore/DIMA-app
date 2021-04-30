//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/services/googleBooksAPI.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/bookGeneralInfoListView.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:flutter_firebase_auth/utils/searchBookForm.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class AddBookSelection extends StatefulWidget {

  final Function(dynamic sel) setSelected;
  dynamic selectedBook;
  final bool showDots;
  bool loading = false;
  final appBarHeight;
  final bool showGeneralInfo;

  AddBookSelection({Key key, this.setSelected, this.selectedBook, this.showDots, this.appBarHeight, this.showGeneralInfo}) : super(key: key);

  @override
  _AddBookSelectionState createState() => _AddBookSelectionState();
}

class _AddBookSelectionState extends State<AddBookSelection> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _author = '';
  bool searchButtonPressed = false;   //check needed to display 'No results found'

  final booksAPI = GoogleBooksAPI();

  List<dynamic> listItems;

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

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - widget.appBarHeight,
        padding: EdgeInsets.symmetric(horizontal: _isTablet ? 50.0 : 15.0),
        child: Column(
          mainAxisAlignment: _isTablet ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            widget.showGeneralInfo ? Container() : Flexible(
              flex:10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: -100 + (_isTablet ? MediaQuery.of(context).size.width/1.75 : MediaQuery.of(context).size.width),
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
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          searchButtonPressed = true;
                          setState(() {
                            widget.loading = true;
                          });
                          print('Searching for \"' + _title + '\" by \"' + _author + '\"');
                          final result = await booksAPI.performSearch(_title, _author);
                          if(result != null) {
                            setState(() {
                              widget.loading = false;
                              widget.selectedBook = null;
                              if(widget.setSelected != null) {
                                widget.setSelected(widget.selectedBook);
                              }
                              //TestPage.of(context).selected = null;
                              listItems = result['items'];
                              //print(listItems);
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              )
            ),
            widget.showGeneralInfo ? Container() : Flexible(
              flex: 2,
              child: SizedBox(height: 20.0,),
            ),
            Expanded(
                flex: 35,
                child: widget.loading == true ?
                Container(
                    decoration: BoxDecoration(
                      //color: Colors.black,
                      border: Border.symmetric(
                        vertical: BorderSide(color: Colors.white),
                      ),
                    ),
                    child: Loading()
                ) : (!widget.showGeneralInfo ?
                Container(
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    border: Border.symmetric(
                      vertical: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: searchButtonPressed && (listItems == null || listItems.length == 0) ?
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'No results found',
                        style: Theme.of(context).textTheme.headline6),
                    ) : ListView.builder(
                    itemCount: listItems != null ? listItems.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: _isTablet ? 10.0 : 0.0),
                        child: Container(
                          child: ListTile(
                            title: Text(listItems[index]['volumeInfo']['title'],
                              style: TextStyle(color: Colors.white, fontSize: _isTablet ? 20.0 : 16.0, fontWeight: FontWeight.bold),),
                            subtitle: Text(listItems[index]['volumeInfo']['authors'].toString(),
                              style: TextStyle(color: Colors.white, fontSize: _isTablet ? 20.0 : 15.0, fontStyle: FontStyle.italic),),
                            onTap: () {
                              setState(() {
                                widget.selectedBook = _initializeBookGeneralInfo(listItems[index]);
                                //widget.selectedBook = listItems[index];
                                if(widget.setSelected != null) {
                                  widget.setSelected(widget.selectedBook);
                                }
                                //TestPage.of(context).selected = _selected;
                              });
                            },
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              bottom: BorderSide(width: 0.3, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ) :
                Container(
                  child: BookGeneralInfoListView(selectedBook: widget.selectedBook,)
                ))
            ),
            /*Flexible(
              flex: 2,
              child: SizedBox(
                height: 20.0,
              ),
            ),*/
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 20.0,
              ),
            ),
            widget.showDots ? BottomTwoDots(darkerIndex: 0, size: 9.0,) : Container(),
            SizedBox(height: 15,)
          ],
        ),
      ),
    );
  }

  BookGeneralInfo _initializeBookGeneralInfo(dynamic selectedBook) {

    var imageLink = selectedBook['volumeInfo']['imageLinks'] != null ? (
            selectedBook['volumeInfo']['imageLinks']['thumbnail'] != null ?
              selectedBook['volumeInfo']['imageLinks']['thumbnail'] : null
          ) : null;

    var categories = selectedBook['volumeInfo']['categories'] != null ?
        List<String>.from(selectedBook['volumeInfo']['categories'])
            : null;
    //print(categories.runtimeType);
    //print(categories);

    var averageRating = selectedBook['volumeInfo']['averageRating'] != null ?
    Utils.computeAverageRatingFromAPI(selectedBook['volumeInfo']['averageRating'].toDouble()) :
        null;

    BookGeneralInfo book = BookGeneralInfo(
      selectedBook['id'],
      selectedBook['volumeInfo']['title'],
      selectedBook['volumeInfo']['authors'].toString(),
      selectedBook['volumeInfo']['publisher'] ?? null,
      selectedBook['volumeInfo']['publishedDate'] ?? null,
      booksAPI.getISBN13(selectedBook['volumeInfo']) ?? null,         //check the case it is null
      imageLink,
      selectedBook['volumeInfo']['description'] ?? null,
      categories,    //TODO check this
      selectedBook['volumeInfo']['language'] ?? null,
      selectedBook['volumeInfo']['pageCount'] ?? null,
      averageRating,
      selectedBook['volumeInfo']['ratingsCount'] ?? null,
    );

    return book;
  }
}
