import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/bookGeneralInfo.dart';
import 'package:flutter_firebase_auth/services/googleBooksAPI.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_firebase_auth/utils/bottomTwoDots.dart';

class AddBookSelection extends StatefulWidget {

  final Function(dynamic sel) setSelected;
  dynamic selectedBook;
  final bool showDots;
  PageController controller;
  bool loading = false;
  final appBarHeight;

  AddBookSelection({Key key, this.setSelected, this.selectedBook, this.showDots, this.controller, this.appBarHeight}) : super(key: key);

  @override
  _AddBookSelectionState createState() => _AddBookSelectionState();
}

class _AddBookSelectionState extends State<AddBookSelection> {
  final _formKey = GlobalKey<FormState>();

  String _title = 'pandora';
  String _author = 'licia troisi';

  final booksAPI = GoogleBooksAPI();

  List<dynamic> listItems;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - widget.appBarHeight - kBottomNavigationBarHeight,
        padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                          initialValue: 'pandora',//just to debug easily,
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
                          initialValue: 'licia troisi',//just to debug easily,
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
              flex: 2,
              child: SizedBox(height: 20.0,),
            ),
            Expanded(
                flex: 35,
                child: widget.loading == true ?
                Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(color: Colors.grey[500]),
                      ),
                    ),
                    child: Loading()
                ) : (widget.selectedBook == null ?
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(color: Colors.grey[500]),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: listItems != null ? listItems.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: ListTile(
                          title: Text(listItems[index]['volumeInfo']['title']),
                          subtitle: Text(listItems[index]['volumeInfo']['authors'].toString()),
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
                          border: Border(
                            bottom: BorderSide(width: 0.3),
                          ),
                        ),
                      );
                    },
                  ),
                ) :
                Container(
                  child: ListView(
                    children: <Widget>[
                      Text(widget.selectedBook.title, textAlign: TextAlign.center,),
                      Text('by ' + widget.selectedBook.author, style: TextStyle(fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
                      Text(''),
                      ((widget.selectedBook.publisher != null) & (widget.selectedBook.publishedDate != null)) ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(widget.selectedBook.publisher + ' ' + widget.selectedBook.publishedDate, textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic),),
                          Text(''),
                        ],
                      ) : Container(),
                      widget.selectedBook.thumbnail != null ?
                      CachedNetworkImage(
                        imageUrl: widget.selectedBook.thumbnail,
                        placeholder: (context, url) => Loading(),
                        width: imageWidth,
                        height: imageHeight,
                      ) :
                      Container(),
                      Text(''),
                      Text('Description', style: TextStyle(fontWeight: FontWeight.bold),),
                      widget.selectedBook.description != null ?
                      Text(widget.selectedBook.description, textAlign: TextAlign.justify,) :
                      Text('No description provided', style: TextStyle(fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
                      Text(''),
                      /*
                      Text('ISBN 10', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(booksAPI.getISBN10(widget.selectedBook['volumeInfo']) ?? ''),
                      Text(''),
                       */
                      widget.selectedBook.isbn13 != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ISBN 13', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(widget.selectedBook.isbn13),
                          Text('')
                        ],
                      ) : Container(),
                      widget.selectedBook.pageCount != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Page count', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(widget.selectedBook.pageCount.toString()),
                          Text(''),
                        ],
                      ) : Container(),
                      widget.selectedBook.categories != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Categories', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(widget.selectedBook.categories.toString()),
                          Text(''),
                        ],
                      ) : Container(),
                      widget.selectedBook.averageRating != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Average rating', style: TextStyle(fontWeight: FontWeight.bold),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.selectedBook.averageRating.floor().toString()),
                              Text('  '),
                              for(var i = 0; i < 5 && widget.selectedBook.averageRating != null; i++)
                                Icon(i > widget.selectedBook.averageRating - 1 ?
                                Icons.star_border : Icons.star,
                                    size: 15.0,
                                    color: Colors.yellow[700]),
                            ],
                          ),
                          Text(''),
                        ],
                      ) : Container(),
                      widget.selectedBook.ratingsCount != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ratings count', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(widget.selectedBook.ratingsCount.toString()),
                          Text(''),
                        ],
                      ) : Container(),
                      widget.selectedBook.language != null ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Language', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(widget.selectedBook.language.toString().toUpperCase()),
                        ],
                      ) : Container(),
                    ],
                  ),
                ))
            ),
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 20.0,
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
                child: Icon(Icons.search, color: Colors.blueGrey[600],size: 35.0),
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
