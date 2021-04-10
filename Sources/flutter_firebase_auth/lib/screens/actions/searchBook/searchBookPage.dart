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
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text("Filter result"),
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
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text("Order by"),
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
                        bool toReorder = _selectedOrder != value;
                        _selectedOrder = value;
                        _selectedOrderValue = index;
                        if(toReorder) {
                          reorder();
                        }
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
                flex: 26,
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
                flex: 26,
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for(int i = 0; i < booksAllInfo.length; i++)
                          Column(
                            children: <Widget>[
                              i == 0 ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                              ) : Container(),
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
                                    fontSize: 14
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                              ),
                              SearchBookInfoBody(
                                book: booksAllInfo[i],
                                bookInfo: booksAllInfo[i][0]['info'],
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Divider(height: 2.0, thickness: 2.0, indent: 12.0, endIndent: 12.0,)
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15.0),
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
        reorderByFieldInUserCollection("title");
        break;

      case orderByAuthorLabel:
        reorderByFieldInUserCollection("author");
        break;

      case orderByISBNLabel:
        reorderByFieldInUserCollection("isbn");
        break;

      case orderByPriceLabel:
        reorderByFieldInUserCollection("price");
        break;

      case orderByPageCountLabel:
        reorderByFieldInBookCollection("pageCount");
        break;

      case orderByAvgRatingLabel:
        reorderByFieldInBookCollection("ratingsCount");
        break;

      case orderByImagesLabel:
        reorderByNumberOfImages();
        break;

      case orderByStatusLabel:
        reorderByFieldInUserCollection("status");
        break;

      default:
        break;
    }

    for(int i = 0; i < booksAllInfo.length; i++) {
      print(booksAllInfo[i][0]['book']['title'].toString() + " -> " + booksAllInfo[i][0]['book']['imagesUrl'].length.toString());
    }
  }

  void reorderByFieldInUserCollection(String field) {
    booksAllInfo.sort(
            (a, b) => _selectedOrderWay == orderByAscendingWay ?
              (a == null ? 1 : b == null ? -1 :
                a[0]['book'][field].toString().compareTo(
                b[0]['book'][field].toString())) :
              (b == null ? 1 : a == null ? -1 :
              b[0]['book'][field].toString().compareTo(
                  a[0]['book'][field].toString()))
    );
  }

  void reorderByNumberOfImages() {
    booksAllInfo.sort(
            (a, b) => _selectedOrderWay == orderByAscendingWay ?
        (a == null ? 1 : b == null ? -1 :
        a[0]['book']['imagesUrl'].length.toString().compareTo(
            b[0]['book']['imagesUrl'].length.toString())) :
        (b == null ? 1 : a == null ? -1 :
        b[0]['book']['imagesUrl'].length.toString().compareTo(
            a[0]['book']['imagesUrl'].length.toString()))
    );
  }

  void reorderByFieldInBookCollection(String field) {
    booksAllInfo.sort(
            (a, b) => _selectedOrderWay == orderByAscendingWay ?
        (a == null ? 1 : b == null ? -1 :
        a[0]['info'][field].toString().compareTo(
            b[0]['info'][field].toString())) :
        (b == null ? 1 : a == null ? -1 :
        b[0]['info'][field].toString().compareTo(
            a[0]['info'][field].toString()))
    );
  }
}
