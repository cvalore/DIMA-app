import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchBookInfoBody.dart';
import 'package:flutter_firebase_auth/screens/home/homeBookInfoBody.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreMap.dart';
import 'package:flutter_firebase_auth/utils/searchBookForm.dart';
import 'package:provider/provider.dart';
import 'package:radio_grouped_buttons/custom_buttons/custom_radio_buttons_group.dart';

class SearchBookPage extends StatefulWidget {

  final List<dynamic> books;

  const SearchBookPage({Key key, this.books}) : super(key: key);

  @override
  _SearchBookPageState createState() => _SearchBookPageState();
}

class _SearchBookPageState extends State<SearchBookPage> {

  final _formKey = GlobalKey<FormState>();

  String _title = 'narnia';
  String _author = 'lewis';
  bool searchButtonPressed = false;   //check needed to display 'No results found'

  String _selectedOrder = orderByNoOrderLabel;
  int _selectedOrderValue = 0;
  String _selectedOrderWay = orderByAscendingWay;
  int _dropdownValue = orderByAscendingWayValue;

  List<dynamic> booksAllInfo = List<dynamic>();
  bool _searchLoading = false;

  void setTitle(String title) {
    _title = title;
  }

  void setAuthor(String author) {
    _author = author;
  }

  GlobalKey getFormKey() {
    return _formKey;
  }

  void addBook(List<dynamic> list, dynamic book) {
    list.add(book);
  }

  @override
  Widget build(BuildContext context) {
    List<PerGenreBook> perGenreBooks = List<PerGenreBook>();
    for(dynamic b in widget.books) {
      if(b != null) {
        perGenreBooks.add(
            PerGenreBook(
              id: b.keys.elementAt(0).toString(),
              title: b[b.keys.elementAt(0).toString()]["title"],
              author: b[b.keys.elementAt(0).toString()]["author"],
              thumbnail: b[b.keys.elementAt(0).toString()]["thumbnail"],
            )
        );
      }
    }

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, userFromAuth.email, userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Container(
      /*decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2.0),
      ),*/
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
              flex: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        backgroundColor: Colors.transparent,
                        child: Icon(Icons.search, color: Colors.white,size: 35.0),
                        onPressed: () async {
                          setState(() {
                            _searchLoading = true;
                          });

                          List<PerGenreBook> realSearchedBooks = List<PerGenreBook>();
                          realSearchedBooks.addAll(
                            perGenreBooks.where((b) =>
                                b.title.toLowerCase().contains(_title.toLowerCase()) ||
                                b.author.toLowerCase().contains(_author.toLowerCase())
                            )
                          );

                          List<dynamic> realBooksAllInfo = List<dynamic>();
                          for(int i = 0; i < realSearchedBooks.length; i++) {
                            dynamic result = await _db.getBookForSearch(realSearchedBooks[i].id);
                            realBooksAllInfo.add(result);
                          }

                          setState(() {
                            _searchLoading = false;
                            booksAllInfo.clear();
                            booksAllInfo.addAll(realBooksAllInfo);
                          });
                        }
                    ),
                  ),
                ],
              )
          ),
          ListTileTheme(
            dense: true,
            child: ExpansionTile(
              title: Text("Filter result", style: TextStyle(fontSize: 15),),
              children: <Widget>[
                Container(
                  //decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2.0)),
                  height: 100,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(child: Text("TODO"));
                    },
                  ),
                )
              ],
            ),
          ),
          ListTileTheme(
            dense: true,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text("Order by", style: TextStyle(fontSize: 15),),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    child: CustomRadioButton(
                      initialSelection: _selectedOrderValue,
                      buttonLables: orderByLabels,
                      buttonValues: orderByLabels,
                      radioButtonValue: (value, index) {
                        setState(() {
                          _searchLoading = true;
                          bool toReorder = _selectedOrder != value;
                          _selectedOrder = value;
                          _selectedOrderValue = index;
                          if(toReorder) {
                            reorder();
                          }
                        });
                        setState(() {
                          _searchLoading = false;
                        });
                      },
                      buttonHeight: 30,
                      lineSpace: 0,
                      fontSize: 14,
                      elevation: 0.0,
                      horizontal: true,
                      enableShape: true,
                      buttonSpace: 5.0,
                      textColor: Colors.white,
                      selectedTextColor: Colors.black,
                      buttonColor: Colors.white12,
                      selectedColor: Colors.white,
                    ),
                  ),
                  DropdownButton(
                    dropdownColor: Colors.grey[700],
                    elevation: 0,
                    value: _dropdownValue,
                    items: [
                      DropdownMenuItem(
                        value: orderByAscendingWayValue,
                        child: Text(orderByAscendingWay),
                      ),
                      DropdownMenuItem(
                        value: orderByDescendingWayValue,
                        child: Text(orderByDescendingWay),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        bool toReorder = _dropdownValue != value;
                        _dropdownValue = value;
                        _selectedOrderWay = orderByWays[value];
                        if(toReorder) {
                          reorder();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          /*Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Order by", style: TextStyle(fontSize: 16.0),),
                  Text("TODO: check box", style: TextStyle(fontSize: 16.0),),
                ],
              ),
            ),
          ),*/
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(height: 2.0, thickness: 2.0, indent: 12.0, endIndent: 12.0,)
          ),
          _searchLoading ? Expanded(flex: 26, child: Loading()) :
          (
            booksAllInfo == null || booksAllInfo.length == 0 ?
              Expanded(
                flex: 30,
                child: Container(
                  /*decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                  ),*/
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('No results',
                          style: TextStyle(color: Colors.white,  fontSize: _isTablet ? 20.0 : 14.0,),),
                        Icon(Icons.menu_book_rounded, color: Colors.white, size: _isTablet ? 30.0 : 20.0,),
                      ],
                    ),
                  ),
                ),
              ):
              Expanded(
                flex: 30,
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for(int i = 0; i < booksAllInfo.length; i++)
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(),
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                                  title: Column(
                                    children: <Widget>[
                                      Text(booksAllInfo[i][0]['book']['title'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17
                                        ),
                                      ),
                                      Text(booksAllInfo[i][0]['book']['author'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      ),
                                      booksAllInfo[i].length == 1 ?
                                        Text("€"+booksAllInfo[i][0]['book']['price'].toStringAsFixed(2),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ) :
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("€"+booksAllInfo[i][0]['book']['price'].toStringAsFixed(2),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(" and others..",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14.0,
                                              ),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        SearchBookInfoBody(
                                          book: booksAllInfo[i],
                                          bookInfo: booksAllInfo[i][0]['info'],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                                        ),
                                      ],
                                    ),
                                  ]
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Divider(height: 2.0, thickness: 2.0, indent: 12.0, endIndent: 12.0,)
                              ),
                            ],
                          )
                      ],
                    ),
                  )
                ),
              )
          )
        ],
      ),
    );
  }

  void reorder() {
    switch(_selectedOrder) {
      case orderByTitleLabel:
        reorderByStringFieldInUserCollection("title");
        break;

      case orderByAuthorLabel:
        reorderByStringFieldInUserCollection("author");
        break;

      case orderByISBNLabel:
        reorderByStringFieldInUserCollection("isbn");
        break;

      case orderByPriceLabel:
        reorderByNumberFieldInUserCollection("price");
        break;

      case orderByPageCountLabel:
        reorderByNumberFieldInBookCollection("pageCount");
        break;

      case orderByAvgRatingLabel:
        reorderByNumberFieldInBookCollection("ratingsCount");
        break;

      case orderByImagesLabel:
        reorderByNumberOfImages();
        break;

      case orderByStatusLabel:
        reorderByNumberFieldInUserCollection("status");
        break;

      default:
        break;
    }
  }

  void reorderByStringFieldInUserCollection(String field) {
    reorderByStringField("book", field);
  }

  void reorderByStringFieldInBookCollection(String field) {
    reorderByStringField("info", field);
  }

  void reorderByNumberFieldInUserCollection(String field) {
    reorderByNumberField('book', field);
  }

  void reorderByNumberFieldInBookCollection(String field) {
    reorderByNumberField('info', field);
  }


  void reorderByStringField(String collection, String field) {
    booksAllInfo.sort(
      (a, b) {
        //sort first the list of the same book from different authors
        a.sort((a1, b1) {
          return _selectedOrderWay == orderByAscendingWay ?
          (
              (a1 == null || a1[collection][field] == null) ? 1 :
              (b1 == null || b1[collection][field] == null) ? -1 :
              (
                  a1[collection][field].toString().compareTo(b1['book'][field].toString())
              )
          ) :
          (
              (b1 == null || b1[collection][field] == null) ? 1 :
              (a1 == null || a1[collection][field] == null) ? -1 :
              (
                  b1[collection][field].toString().compareTo(a1[collection][field].toString())
              )
          );
        });
        //sort first the list of the same book from different authors
        b.sort((a1, b1) {
          return _selectedOrderWay == orderByAscendingWay ?
          (
              (a1 == null || a1[collection][field]) ? 1 :
              (b1 == null || b1[collection][field] == null) ? -1 :
              (
                  a1[collection][field].toString().compareTo(b1[collection][field].toString())
              )
          ) :
          (
              (b1 == null || b1['book'][field] == null) ? 1 :
              (a1 == null || a1['book'][field] == null) ? -1 :
              (
                  b1[collection][field].toString().compareTo(a1[collection][field].toString())
              )
          );
        });


        //sort globally the two elements
        return _selectedOrderWay == orderByAscendingWay ?
        (
            (a == null || a[0][collection][field] == null) ? 1 :
            (b == null || b[0][collection][field] == null) ? -1 : (
                a[0][collection][field].toString().compareTo(b[0][collection][field].toString())
            )
        ) :
        (
            (b == null || b[0][collection][field] == null) ? 1 :
            (a == null || a[0][collection][field] == null) ? -1 :
            (
                b[0][collection][field].toString().compareTo(a[0][collection][field].toString())
            )
        );
      }
    );
  }

  void reorderByNumberField(String collection, String field) {
    booksAllInfo.sort(
      (a, b) {
        //sort first the list of the same book from different authors
        a.sort((a1, b1) {
          return _selectedOrderWay == orderByAscendingWay ?
          (
              (a1 == null || a1[collection][field] == null) ? 1 :
              (b1 == null || b1[collection][field] == null) ? -1 :
              (
                  a1[collection][field] > b1[collection][field] ? 1 : -1
              )
          ) :
          (
              (b1 == null || b1[collection][field] == null) ? 1 :
              (a1 == null || a1[collection][field] == null) ? -1 :
              (
                  b1[collection][field] > a1[collection][field] ? 1 : -1
              )
          );
        });
        //sort first the list of the same book from different authors
        b.sort((a1, b1) {
          return _selectedOrderWay == orderByAscendingWay ?
          (
              (a1 == null || a1[collection][field]) ? 1 :
              (b1 == null || b1[collection][field] == null) ? -1 :
              (
                  a1[collection][field] > b1[collection][field] ? 1 : -1
              )
          ) :
          (
              (b1 == null || b1[collection][field] == null) ? 1 :
              (a1 == null || a1[collection][field] == null) ? -1 :
              (
                  b1[collection][field] > a1[collection][field] ? 1 : -1
              )
          );
        });


        //sort globally the two elements
        return _selectedOrderWay == orderByAscendingWay ?
        (
            (a == null || a[0][collection][field] == null) ? 1 :
            (b == null || b[0][collection][field] == null) ? -1 : (
                a[0][collection][field] > b[0][collection][field] ? 1 : -1
            )
        ) :
        (
            (b == null || b[0][collection][field] == null) ? 1 :
            (a == null || a[0][collection][field] == null) ? -1 :
            (
                b[0][collection][field] > a[0][collection][field] ? 1 : -1
            )
        );

      }
    );
  }


  void reorderByNumberOfImages() {
    booksAllInfo.sort(
      (a, b) {
        return _selectedOrderWay == orderByAscendingWay ?
        (
            a == null ? 1 : b == null ? -1 : (
                a[0]['book']['imagesUrl'].length >
                    b[0]['book']['imagesUrl'].length  ? 1 : -1
            )
        ) :
        (
            b == null ? 1 : a == null ? -1 : (
                b[0]['book']['imagesUrl'].length >
                    a[0]['book']['imagesUrl'].length  ? 1 : -1
            )
        );
    });
  }

}
