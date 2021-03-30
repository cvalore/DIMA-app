import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/services/googleBooksAPI.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/bookGeneralInfoListView.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';
import 'package:flutter_firebase_auth/utils/searchBookForm.dart';

class AddBookSelection extends StatefulWidget {

  final Function(dynamic sel) setSelected;
  dynamic selectedBook;
  final bool showDots;
  bool loading = false;
  final appBarHeight;

  AddBookSelection({Key key, this.setSelected, this.selectedBook, this.showDots, this.appBarHeight}) : super(key: key);

  @override
  _AddBookSelectionState createState() => _AddBookSelectionState();
}

class _AddBookSelectionState extends State<AddBookSelection> {
  final _formKey = GlobalKey<FormState>();

  String _title = 'narnia';
  String _author = 'lewis';

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
        padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
        child: Column(
          mainAxisAlignment: _isTablet ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              flex:10,
              child: Row(
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
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.search, color: Colors.white,size: 35.0),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
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
            Flexible(
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
                ) : (widget.selectedBook == null ?
                Container(
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    border: Border.symmetric(
                      vertical: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: listItems != null ? listItems.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: ListTile(
                          title: Text(listItems[index]['volumeInfo']['title'],
                            style: TextStyle(color: Colors.white, fontSize: _isTablet ? 20.0 : 16.0),),
                          subtitle: Text(listItems[index]['volumeInfo']['authors'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: _isTablet ? 20.0 : 16.0),),
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
    selectedBook['volumeInfo']['averageRating'].toDouble() :
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
