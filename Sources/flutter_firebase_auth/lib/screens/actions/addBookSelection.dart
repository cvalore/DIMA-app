import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/services/googleBooksAPI.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/bottomThreeDots.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddBookSelection extends StatefulWidget {

  final Function(dynamic sel) setSelected;
  dynamic selected;
  final bool showDots;

  AddBookSelection({Key key, this.setSelected, this.selected, this.showDots}) : super(key: key);

  @override
  _AddBookSelectionState createState() => _AddBookSelectionState();
}

class _AddBookSelectionState extends State<AddBookSelection> {
  final _formKey = GlobalKey<FormState>();

  String _title = 'harry potter';
  String _author = 'rowling';

  final booksAPI = GoogleBooksAPI();

  List<dynamic> listItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
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
                        initialValue: 'harry potter',//just to debug easily,
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
                        initialValue: 'rowling',//just to debug easily,
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
            child: widget.selected == null ?
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
                          widget.selected = listItems[index];
                          if(widget.setSelected != null) {
                            widget.setSelected(widget.selected);
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
                  Text(widget.selected['volumeInfo']['title'], textAlign: TextAlign.center,),
                  Text('by ' + widget.selected['volumeInfo']['authors'].toString(), style: TextStyle(fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
                  Text(''),
                  Text(widget.selected['volumeInfo']['publisher'] ?? '' + ' ' + widget.selected['volumeInfo']['publishedDate'] ?? '', textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic),),
                  Text(''),
                  widget.selected['volumeInfo']['imageLinks'] != null ? (
                    widget.selected['volumeInfo']['imageLinks']['thumbnail'] != null ?
                      CachedNetworkImage(
                        imageUrl: widget.selected['volumeInfo']['imageLinks']['thumbnail'],
                        placeholder: (context, url) => Loading(),
                        width: imageWidth,
                        height: imageHeight,
                      ) :
                      Container()
                    ) :
                    Container(),
                  Text(''),
                  Text('Description', style: TextStyle(fontWeight: FontWeight.bold),),
                  widget.selected['volumeInfo']['description'] != null ?
                      Text(widget.selected['volumeInfo']['description'], textAlign: TextAlign.justify,) :
                      Text('No description provided', style: TextStyle(fontStyle: FontStyle.italic), textAlign: TextAlign.center,),
                  Text(''),
                  Text('ISBN 10', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(booksAPI.getISBN10(widget.selected['volumeInfo']) ?? ''),
                  Text(''),
                  Text('ISBN 13', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(booksAPI.getISBN13(widget.selected['volumeInfo']) ?? ''),
                  Text(''),
                  Text('Page count', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.selected['volumeInfo']['pageCount'] != null ? widget.selected['volumeInfo']['pageCount'].toString() : ''),
                  Text(''),
                  Text('Categories', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.selected['volumeInfo']['categories'].toString() ?? ''),
                  Text(''),
                  Text('Average rating', style: TextStyle(fontWeight: FontWeight.bold),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.selected['volumeInfo']['averageRating'] != null ? (widget.selected['volumeInfo']['averageRating'].floor()).toString() : ''),
                      Text('  '),
                      for(var i = 0; i < 5 && widget.selected['volumeInfo']['averageRating'] != null; i++)
                        Icon(i > widget.selected['volumeInfo']['averageRating'] - 1 ?
                          Icons.star_border : Icons.star,
                            size: 15.0,
                            color: Colors.yellow[700]),
                    ],
                  ),
                  Text(''),
                  Text('Ratings count', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.selected['volumeInfo']['ratingsCount'] != null ? widget.selected['volumeInfo']['ratingsCount'].toString() : ''),
                  Text(''),
                  Text('Language', style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.selected['volumeInfo']['language'] != null ? widget.selected['volumeInfo']['language'].toString().toUpperCase() : ''),
                  
                ],
              ),
            ),
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
              elevation: 0.0,
              focusElevation: 0.0,
              hoverElevation: 0.0,
              highlightElevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.search, color: Colors.blueGrey[600],size: 35.0),
              onPressed: () async {
                if(_formKey.currentState.validate()) {
                  print('Searching for \"' + _title + '\" by \"' + _author + '\"');
                  final result = await booksAPI.performSearch(_title, _author);
                  if(result != null) {
                    setState(() {
                      widget.selected = null;
                      if(widget.setSelected != null) {
                        widget.setSelected(widget.selected);
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
          widget.showDots ? BottomThreeDots(darkerIndex: 0, size: 9.0,) : Container(),
        ],
      ),
    );
  }
}
