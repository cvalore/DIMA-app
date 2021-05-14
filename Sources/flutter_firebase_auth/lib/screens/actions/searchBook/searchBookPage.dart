import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/perGenreBook.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/searchBook/searchBookInfoBody.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/utils/bookGenres.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/loading.dart';
import 'package:flutter_firebase_auth/utils/manuallyCloseableExpansionTile.dart';
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
  final _priceFormKey = GlobalKey<FormState>();
  final _lessThanFormFieldController = TextEditingController();
  final _greaterThanFormFieldController = TextEditingController();
  final _isbnFormFieldController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<PerGenreBook> perGenreBooks;
  DatabaseService _db;
  int lastBookShownIndex = 0;
  bool gettingMoreBooks = false;


  String _title = '';
  String _author = '';
  bool searchButtonPressed = false;   //check needed to display 'No results found'

  bool _openModifiersSection = false;

  String _selectedOrder = orderByNoOrderLabel;
  int _selectedOrderValue = 0;
  String _selectedOrderWay = orderByAscendingWay;
  int _dropdownValue = orderByAscendingWayValue;

  List<dynamic> booksAllInfo = List<dynamic>();
  List<dynamic> booksAllInfoCopy = List<dynamic>();
  bool _searchLoading = false;

  bool _isRemoveFilterEnabled = false;
  String _lessThanPrice = "";
  String _greaterThanPrice = "";
  bool _photosCheckBox = false;
  bool _exchangeableCheckBox = false;

  final GlobalKey<ManuallyCloseableExpansionTileState> _filterExpansionTileKey = GlobalKey();
  final GlobalKey<ManuallyCloseableExpansionTileState> _orderbyExpansionTileKey = GlobalKey();

  int _dropdownGenreValue = 0;
  String _dropdownGenreLabel = "";

  String _isbnFilter = "";

  String _resultMessage = "No results";

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

  getMoreBooks() async {
    List<PerGenreBook> realSearchedBooks = List<PerGenreBook>();

    if (gettingMoreBooks == true)
      return;

    gettingMoreBooks = true;

    realSearchedBooks.addAll(
        perGenreBooks.where((b) {
          if(realSearchedBooks.contains(b)) {
            return false;
          }

          if(_title.isNotEmpty && _author.isNotEmpty) {
            return b.title.toLowerCase().contains(
                _title.toLowerCase()) ||
                b.author.toLowerCase().contains(
                    _author.toLowerCase());
          }
          else if(_title.isNotEmpty) {
            return b.title.toLowerCase().contains(
                _title.toLowerCase());
          }
          else {
            return b.author.toLowerCase().contains(
                _author.toLowerCase());
          }
        })
    );

    List<dynamic> realBooksAllInfo = List<dynamic>();
    for(int i = lastBookShownIndex; i < realSearchedBooks.length && i < lastBookShownIndex + 5; i++) {
      dynamic result = await _db.getBookForSearch(realSearchedBooks[i].id);
      realBooksAllInfo.add(result);
    }
    lastBookShownIndex += 5;

    if (realBooksAllInfo.length > 0) {
      setState(() {
        _searchLoading = false;
        booksAllInfo.addAll(realBooksAllInfo);
      });
    }
    gettingMoreBooks = false;
  }

  @override
  void initState() {
    super.initState();
    perGenreBooks = List<PerGenreBook>();
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

    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta){
        getMoreBooks();
      }
    });
  }

  bool loading = false;

  void setLoading(bool newValue) {
    setState(() {
      loading = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {

    AuthCustomUser userFromAuth;
    try {
      userFromAuth = Provider.of<AuthCustomUser>(context);
    } catch(Exception) {
      print("Cannot read value from AuthCustomUser stream provider");
    }
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    _db = DatabaseService(user: user);

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return loading ? Loading() : Container(
      /*decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2.0),
      ),*/
      height: MediaQuery.of(context).size.height,
      child:
      _isPortrait ?
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(padding: const EdgeInsets.symmetric(vertical: 5.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: _isTablet ? 150 : 90,
                width: -100 + (_isTablet ? MediaQuery.of(context).size.width/1.75 : _isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width/1.75),
                child: SearchBookForm(
                  setTitle: setTitle,
                  setAuthor: setAuthor,
                  getKey: getFormKey,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                      heroTag: "searchBookBtn",
                      elevation: 0.0,
                      focusElevation: 0.0,
                      hoverElevation: 0.0,
                      highlightElevation: 0.0,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.search, color: Colors.white,size: 35.0),
                      onPressed: () async {
                        bool valid = true;
                        setState(() {
                          if(_filterExpansionTileKey != null && _filterExpansionTileKey.currentState != null) {
                            _filterExpansionTileKey.currentState.collapse();
                          }
                          if(_orderbyExpansionTileKey != null && _orderbyExpansionTileKey.currentState != null) {
                            _orderbyExpansionTileKey.currentState.collapse();
                          }
                          //_openModifiersSection = false;

                          if(_title.isEmpty && _author.isEmpty) {
                            valid = false;
                            _resultMessage = "Insert at least either a Title or an Author";
                            return;
                          }

                          _searchLoading = true;
                          _resultMessage = "No results";
                        });

                        if(!valid) {
                          booksAllInfo.clear();
                          return;
                        }

                        List<PerGenreBook> realSearchedBooks = List<PerGenreBook>();
                        realSearchedBooks.addAll(
                            perGenreBooks.where((b) {
                              if(realSearchedBooks.contains(b)) {
                                return false;
                              }

                              if(_title.isNotEmpty && _author.isNotEmpty) {
                                return b.title.toLowerCase().contains(
                                    _title.toLowerCase()) ||
                                    b.author.toLowerCase().contains(
                                        _author.toLowerCase());
                              }
                              else if(_title.isNotEmpty) {
                                return b.title.toLowerCase().contains(
                                    _title.toLowerCase());
                              }
                              else {
                                return b.author.toLowerCase().contains(
                                        _author.toLowerCase());
                              }
                            })
                        );
                        lastBookShownIndex = 5;
                        List<dynamic> realBooksAllInfo = List<dynamic>();
                        for(int i = 0; i < realSearchedBooks.length && i < lastBookShownIndex; i++) {
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
                  IconButton(
                    splashRadius: 24.0,
                    iconSize: 28.0,
                    onPressed: () {
                      setState(() {
                        _openModifiersSection = !_openModifiersSection;
                      });
                    },
                    icon: Icon(Icons.keyboard_arrow_down)),
                ],
              ),
            ],
          ),
          _openModifiersSection ? ListTileTheme(
            dense: true,
            child: ManuallyCloseableExpansionTile(
              onExpansionChanged: (val) {
                if(val) {
                  _orderbyExpansionTileKey.currentState.collapse();
                }
              },
              key: _filterExpansionTileKey,
              initiallyExpanded: false,
              title: Text("Filter result", style: TextStyle(fontSize: _isTablet ? 19.0 : 15),),
              children: <Widget>[
                Form(
                  key: _priceFormKey,
                  child: Container(
                    //decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2.0)),
                    height: 254,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Price", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _isTablet ? 18.0 : 15.0,
                              ),),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),),
                              Text("Min €", style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                width: 60,
                                height: 50,
                                child: TextFormField(
                                  controller: _greaterThanFormFieldController,
                                  //initialValue: _greaterThanPrice,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: _isTablet ? 17.0 : 14.0, color: Colors.white12,),
                                    hintText: "Price",
                                    focusedErrorBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(0.0),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _greaterThanPrice = value;
                                    });
                                  },
                                ),
                              ),
                              Text("Max €", style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                width: 60,
                                height: 50,
                                child: TextFormField(
                                  controller: _lessThanFormFieldController,
                                  //initialValue: _lessThanPrice,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: _isTablet ? 17.0 : 14.0, color: Colors.white12,),
                                    hintText: "Price",
                                    focusedErrorBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(0.0),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _lessThanPrice = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Photos", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _isTablet ? 18.0 : 15.0,
                              ),),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 0.0),),
                              Checkbox(
                                onChanged: (bool value) {
                                  setState(() {
                                    _photosCheckBox = !_photosCheckBox;
                                  });
                                },
                                value: _photosCheckBox,
                              ),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0),),
                              Text("Exchangeable", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _isTablet ? 18.0 : 15.0,
                              ),),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 0.0),),
                              Checkbox(
                                onChanged: (bool value) {
                                  setState(() {
                                    _exchangeableCheckBox = !_exchangeableCheckBox;
                                  });
                                },
                                value: _exchangeableCheckBox,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Genre", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _isTablet ? 18.0 : 15.0,
                              ),),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),),
                              DropdownButton(
                                key: UniqueKey(),
                                dropdownColor: Colors.grey[700],
                                elevation: 0,
                                value: _dropdownGenreValue,
                                selectedItemBuilder: (BuildContext context) {
                                  List<Widget> items = [];
                                  for(int i = 0; i < BookGenres().allBookGenres.length + 1; i++)
                                    i == 0 ?
                                    items.add(
                                      Center(
                                        child: Container(
                                        width: 200,
                                        alignment: AlignmentDirectional.center,
                                        child: Text("All genres", textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),
                                        ))
                                      ),
                                    ) :
                                    items.add(
                                      Center(
                                        child: Container(
                                          width: 200,
                                          alignment: AlignmentDirectional.center,
                                          child: Text(BookGenres().allBookGenres[i-1], textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),
                                          )
                                        )
                                      ),
                                    );
                                  return items;
                                },
                                items: [
                                  for(int i = 0; i < BookGenres().allBookGenres.length + 1; i++)
                                    i == 0 ?
                                      DropdownMenuItem(
                                        value: i,
                                        child: Text("All genres", textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,)
                                        ),
                                      ) :
                                      DropdownMenuItem(
                                        value: i,
                                        child: Text(BookGenres().allBookGenres[i-1], textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),
                                        ),
                                      ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _dropdownGenreValue = value;
                                    _dropdownGenreLabel =
                                        value == 0 ? "" : BookGenres().allBookGenres[value - 1];
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("ISBN", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: _isTablet ? 18.0 : 15.0,
                              ),),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),),
                              Container(
                                width: 220,
                                child: TextFormField(
                                  controller: _isbnFormFieldController,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: _isTablet ? 17.0 : 14.0, color: Colors.white12,),
                                    hintText: "Insert ISBN (also partial)",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _isbnFilter = value;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    filter();
                                    if(!_isRemoveFilterEnabled) {
                                      _isRemoveFilterEnabled = true;
                                    }
                                    _filterExpansionTileKey.currentState.collapse();
                                  });
                                },
                                child: Text("Apply",style: TextStyle(fontSize: _isTablet ? 20.0 : 17.0,),),
                              ),
                              _isRemoveFilterEnabled ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    _lessThanFormFieldController.clear();
                                    _greaterThanFormFieldController.clear();
                                    _isbnFormFieldController.clear();
                                    _greaterThanPrice = "";
                                    _lessThanPrice = "";
                                    _isbnFilter = "";
                                    clearFilter();
                                    _isRemoveFilterEnabled = false;
                                    _photosCheckBox = false;
                                    _exchangeableCheckBox = false;

                                    _filterExpansionTileKey.currentState.collapse();
                                  });
                                },
                                child: Text("Remove",style: TextStyle(fontSize: _isTablet ? 20.0 : 17.0,),)
                              ) : TextButton(child: Text("Remove",style: TextStyle(fontSize: _isTablet ? 20.0 : 17.0,),)
                              )
                            ],
                          ),
                          Padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ) : Container(),
          _openModifiersSection ? ListTileTheme(
            dense: true,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ManuallyCloseableExpansionTile(
                onExpansionChanged: (val) {
                  if(val) {
                    _filterExpansionTileKey.currentState.collapse();
                  }
                },
                key: _orderbyExpansionTileKey,
                initiallyExpanded: false,
                title: Text("Order by", style: TextStyle(fontSize: _isTablet ? 19.0 : 15),),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: _isTablet ? 8.0 : 0.0),
                    width: MediaQuery.of(context).size.width,
                    child: CustomRadioButton(
                      initialSelection: _selectedOrderValue,
                      buttonLables: orderByBookLabels,
                      buttonValues: orderByBookLabels,
                      radioButtonValue: (value, index) {
                        setState(() {
                          _searchLoading = true;
                          bool toReorder = _selectedOrder != value;
                          _selectedOrder = value;
                          _selectedOrderValue = index;
                          if(toReorder) {
                            reorder();
                          }
                          _orderbyExpansionTileKey.currentState.collapse();
                        });
                        setState(() {
                          _searchLoading = false;
                        });
                      },
                      buttonHeight: _isTablet ? 40.0 : 30,
                      lineSpace: _isTablet ? 15.0 : 0.0,
                      fontSize: _isTablet ? 17.0 : 14,
                      elevation: 0.0,
                      horizontal: true,
                      enableShape: true,
                      buttonSpace: _isTablet ? 13.0 : 5.0,
                      textColor: Colors.white,
                      selectedTextColor: Colors.black,
                      buttonColor: Colors.white12,
                      selectedColor: Colors.white,
                    ),
                  ),
                  DropdownButton(
                    key: UniqueKey(),
                    dropdownColor: Colors.grey[700],
                    elevation: 0,
                    value: _dropdownValue,
                    items: [
                      DropdownMenuItem(
                        value: orderByAscendingWayValue,
                        child: Text(orderByAscendingWay, style: TextStyle(fontSize: _isTablet ? 18.0 : 14.0,),),
                      ),
                      DropdownMenuItem(
                        value: orderByDescendingWayValue,
                        child: Text(orderByDescendingWay, style: TextStyle(fontSize: _isTablet ? 18.0 : 14.0,),),
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
                        _orderbyExpansionTileKey.currentState.collapse();
                      });
                    },
                  ),
                ],
              ),
            ),
          ) : Container(),
          Padding(
              padding: EdgeInsets.symmetric(vertical: _isTablet ? 20.0 : 0.0),
              child: Divider(height: 2.0, thickness: 2.0, indent: _isTablet ? 50.0 : 12.0, endIndent: _isTablet ? 50.0 : 12.0,)
          ),
          _searchLoading ? Expanded(flex: 26, child: Loading()) :
          (
            booksAllInfo == null || booksAllInfo.length == 0 ?
              Expanded(
                flex: 30,
                child: Container(
                  alignment: AlignmentDirectional.center,
                  /*decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                  ),*/
                  child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_resultMessage,
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
                    controller: scrollController,
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
                                  tilePadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: _isTablet ? 90.0 : 20.0),
                                  title: Column(
                                    children: <Widget>[
                                      Text(booksAllInfo[i][0]['book']['title'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:  _isTablet ? 22.0 : 17.0
                                        ),
                                      ),
                                      Text(booksAllInfo[i][0]['book']['author'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: _isTablet ? 18.0 : 14.0,
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
                                            fontSize: _isTablet ? 20.0 : 15.0,
                                          ),
                                        ) :
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text("€"+booksAllInfo[i][0]['book']['price'].toStringAsFixed(2),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: _isTablet ? 18.0 : 15.0,
                                              ),
                                            ),
                                            Text(" and others..",
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontSize: _isTablet ? 17.0 : 14.0,
                                              ),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: _isTablet ? 90.0 : 0.0),
                                          child: SearchBookInfoBody(
                                            book: booksAllInfo[i],
                                            bookInfo: booksAllInfo[i][0]['info'],
                                            setLoading: setLoading,
                                            fatherContext: context,
                                          ),
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
                                  child: Divider(height: 2.0, thickness: 2.0, indent: _isTablet ? 100.0 : 12.0, endIndent: _isTablet ? 100.0 : 12.0,)
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
      ) :
      Container(
        width: MediaQuery.of(context).size.width/2.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(padding: const EdgeInsets.symmetric(vertical: 5.0)),
                Container(
                  width: MediaQuery.of(context).size.width/2.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: _isTablet ? 150 : 90,
                        width: -100 + (_isTablet ? _isPortrait ? MediaQuery.of(context).size.width/1.75 : MediaQuery.of(context).size.width/2.5 : _isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width/2.2),
                        child: SearchBookForm(
                          setTitle: setTitle,
                          setAuthor: setAuthor,
                          getKey: getFormKey,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton(
                              heroTag: "searchBookBtn",
                              elevation: 0.0,
                              focusElevation: 0.0,
                              hoverElevation: 0.0,
                              highlightElevation: 0.0,
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.search, color: Colors.white,size: 35.0),
                              onPressed: () async {
                                bool valid = true;
                                setState(() {
                                  if(_filterExpansionTileKey != null && _filterExpansionTileKey.currentState != null) {
                                    _filterExpansionTileKey.currentState.collapse();
                                  }
                                  if(_orderbyExpansionTileKey != null && _orderbyExpansionTileKey.currentState != null) {
                                    _orderbyExpansionTileKey.currentState.collapse();
                                  }
                                  //_openModifiersSection = false;

                                  if(_title.isEmpty && _author.isEmpty) {
                                    valid = false;
                                    _resultMessage = "Insert at least either a Title or an Author";
                                    return;
                                  }

                                  _searchLoading = true;
                                  _resultMessage = "No results";
                                });

                                if(!valid) {
                                  booksAllInfo.clear();
                                  return;
                                }

                                List<PerGenreBook> realSearchedBooks = List<PerGenreBook>();
                                realSearchedBooks.addAll(
                                    perGenreBooks.where((b) {
                                      if(realSearchedBooks.contains(b)) {
                                        return false;
                                      }

                                      if(_title.isNotEmpty && _author.isNotEmpty) {
                                        return b.title.toLowerCase().contains(
                                            _title.toLowerCase()) ||
                                            b.author.toLowerCase().contains(
                                                _author.toLowerCase());
                                      }
                                      else if(_title.isNotEmpty) {
                                        return b.title.toLowerCase().contains(
                                            _title.toLowerCase());
                                      }
                                      else {
                                        return b.author.toLowerCase().contains(
                                            _author.toLowerCase());
                                      }
                                    })
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
                          IconButton(
                              splashRadius: 24.0,
                              iconSize: 28.0,
                              onPressed: () {
                                setState(() {
                                  _openModifiersSection = !_openModifiersSection;
                                });
                              },
                              icon: Icon(Icons.keyboard_arrow_down)),
                        ],
                      ),
                    ],
                  ),
                ),
                _openModifiersSection ? Container(
                  width: MediaQuery.of(context).size.width/2.5,
                  child: ListTileTheme(
                    dense: true,
                    child: ManuallyCloseableExpansionTile(
                      onExpansionChanged: (val) {
                        if(val) {
                          _orderbyExpansionTileKey.currentState.collapse();
                        }
                      },
                      key: _filterExpansionTileKey,
                      initiallyExpanded: false,
                      title: Text("Filter result", style: TextStyle(fontSize: _isTablet ? 19.0 : 15),),
                      children: <Widget>[
                        Form(
                          key: _priceFormKey,
                          child: Container(
                            //decoration: BoxDecoration(border: Border.all(color: Colors.red, width: 2.0)),
                            height: _isTablet ? 260.0 : 80.0,
                            child: ListView.builder(
                              itemCount: 6,
                              itemBuilder: (BuildContext context, int index) {
                                return
                                    index == 0 ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Price", style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _isTablet ? 18.0 : 15.0,
                                        ),),
                                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),),
                                        Text("Min €", style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                          width: 60,
                                          height: 50,
                                          child: TextFormField(
                                            controller: _greaterThanFormFieldController,
                                            //initialValue: _greaterThanPrice,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(fontSize: _isTablet ? 17.0 : 14.0, color: Colors.white12,),
                                              hintText: "Price",
                                              focusedErrorBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              contentPadding: const EdgeInsets.all(0.0),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _greaterThanPrice = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Text("Max €", style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                          width: 60,
                                          height: 50,
                                          child: TextFormField(
                                            controller: _lessThanFormFieldController,
                                            //initialValue: _lessThanPrice,
                                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(fontSize: _isTablet ? 17.0 : 14.0, color: Colors.white12,),
                                              hintText: "Price",
                                              focusedErrorBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              contentPadding: const EdgeInsets.all(0.0),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _lessThanPrice = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ) :
                                    index == 1 ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Photos", style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _isTablet ? 18.0 : 15.0,
                                        ),),
                                        Padding(padding: const EdgeInsets.symmetric(horizontal: 0.0),),
                                        Checkbox(
                                          onChanged: (bool value) {
                                            setState(() {
                                              _photosCheckBox = !_photosCheckBox;
                                            });
                                          },
                                          value: _photosCheckBox,
                                        ),
                                        Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0),),
                                        Text("Exchangeable", style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _isTablet ? 18.0 : 15.0,
                                        ),),
                                        Padding(padding: const EdgeInsets.symmetric(horizontal: 0.0),),
                                        Checkbox(
                                          onChanged: (bool value) {
                                            setState(() {
                                              _exchangeableCheckBox = !_exchangeableCheckBox;
                                            });
                                          },
                                          value: _exchangeableCheckBox,
                                        ),
                                      ],
                                    ) :
                                    index == 2 ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Genre", style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _isTablet ? 18.0 : 15.0,
                                        ),),
                                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),),
                                        DropdownButton(
                                          key: UniqueKey(),
                                          dropdownColor: Colors.grey[700],
                                          elevation: 0,
                                          value: _dropdownGenreValue,
                                          selectedItemBuilder: (BuildContext context) {
                                            List<Widget> items = [];
                                            for(int i = 0; i < BookGenres().allBookGenres.length + 1; i++)
                                              i == 0 ?
                                              items.add(
                                                Center(
                                                    child: Container(
                                                        width: 200,
                                                        alignment: AlignmentDirectional.center,
                                                        child: Text("All genres", textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),
                                                        ))
                                                ),
                                              ) :
                                              items.add(
                                                Center(
                                                    child: Container(
                                                        width: 200,
                                                        alignment: AlignmentDirectional.center,
                                                        child: Text(BookGenres().allBookGenres[i-1], textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),
                                                        )
                                                    )
                                                ),
                                              );
                                            return items;
                                          },
                                          items: [
                                            for(int i = 0; i < BookGenres().allBookGenres.length + 1; i++)
                                              i == 0 ?
                                              DropdownMenuItem(
                                                value: i,
                                                child: Text("All genres", textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,)
                                                ),
                                              ) :
                                              DropdownMenuItem(
                                                value: i,
                                                child: Text(BookGenres().allBookGenres[i-1], textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),
                                                ),
                                              ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _dropdownGenreValue = value;
                                              _dropdownGenreLabel =
                                              value == 0 ? "" : BookGenres().allBookGenres[value - 1];
                                            });
                                          },
                                        ),
                                      ],
                                    ) :
                                    index == 3 ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("ISBN", style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _isTablet ? 18.0 : 15.0,
                                        ),),
                                        Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),),
                                        Container(
                                          width: 220,
                                          child: TextFormField(
                                            controller: _isbnFormFieldController,
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(fontSize: _isTablet ? 17.0 : 14.0, color: Colors.white12,),
                                              hintText: "Insert ISBN (also partial)",
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _isbnFilter = value;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ) :
                                    index == 4 ? Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)) :
                                    index == 5 ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              filter();
                                              if(!_isRemoveFilterEnabled) {
                                                _isRemoveFilterEnabled = true;
                                              }
                                              _filterExpansionTileKey.currentState.collapse();
                                            });
                                          },
                                          child: Text("Apply",style: TextStyle(fontSize: _isTablet ? 20.0 : 17.0,),),
                                        ),
                                        _isRemoveFilterEnabled ? TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _lessThanFormFieldController.clear();
                                                _greaterThanFormFieldController.clear();
                                                _isbnFormFieldController.clear();
                                                _greaterThanPrice = "";
                                                _lessThanPrice = "";
                                                _isbnFilter = "";
                                                clearFilter();
                                                _isRemoveFilterEnabled = false;
                                                _photosCheckBox = false;
                                                _exchangeableCheckBox = false;

                                                _filterExpansionTileKey.currentState.collapse();
                                              });
                                            },
                                            child: Text("Remove",style: TextStyle(fontSize: _isTablet ? 20.0 : 17.0,),)
                                        ) : TextButton(child: Text("Remove",style: TextStyle(fontSize: _isTablet ? 20.0 : 17.0,),)
                                        )
                                      ],
                                    ) :
                                                Padding(padding: const EdgeInsets.symmetric(vertical: 2.0));
                              },
                              /*child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Price", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _isTablet ? 18.0 : 15.0,
                                      ),),
                                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),),
                                      Text("Min €", style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        width: 60,
                                        height: 50,
                                        child: TextFormField(
                                          controller: _greaterThanFormFieldController,
                                          //initialValue: _greaterThanPrice,
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(fontSize: _isTablet ? 17.0 : 14.0, color: Colors.white12,),
                                            hintText: "Price",
                                            focusedErrorBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.all(0.0),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _greaterThanPrice = value;
                                            });
                                          },
                                        ),
                                      ),
                                      Text("Max €", style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        width: 60,
                                        height: 50,
                                        child: TextFormField(
                                          controller: _lessThanFormFieldController,
                                          //initialValue: _lessThanPrice,
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(fontSize: _isTablet ? 17.0 : 14.0, color: Colors.white12,),
                                            hintText: "Price",
                                            focusedErrorBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            contentPadding: const EdgeInsets.all(0.0),
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _lessThanPrice = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Photos", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _isTablet ? 18.0 : 15.0,
                                      ),),
                                      Padding(padding: const EdgeInsets.symmetric(horizontal: 0.0),),
                                      Checkbox(
                                        onChanged: (bool value) {
                                          setState(() {
                                            _photosCheckBox = !_photosCheckBox;
                                          });
                                        },
                                        value: _photosCheckBox,
                                      ),
                                      Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0),),
                                      Text("Exchangeable", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _isTablet ? 18.0 : 15.0,
                                      ),),
                                      Padding(padding: const EdgeInsets.symmetric(horizontal: 0.0),),
                                      Checkbox(
                                        onChanged: (bool value) {
                                          setState(() {
                                            _exchangeableCheckBox = !_exchangeableCheckBox;
                                          });
                                        },
                                        value: _exchangeableCheckBox,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Genre", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _isTablet ? 18.0 : 15.0,
                                      ),),
                                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),),
                                      DropdownButton(
                                        key: UniqueKey(),
                                        dropdownColor: Colors.grey[700],
                                        elevation: 0,
                                        value: _dropdownGenreValue,
                                        selectedItemBuilder: (BuildContext context) {
                                          List<Widget> items = [];
                                          for(int i = 0; i < BookGenres().allBookGenres.length + 1; i++)
                                            i == 0 ?
                                            items.add(
                                              Center(
                                                  child: Container(
                                                      width: 200,
                                                      alignment: AlignmentDirectional.center,
                                                      child: Text("All genres", textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),
                                                      ))
                                              ),
                                            ) :
                                            items.add(
                                              Center(
                                                  child: Container(
                                                      width: 200,
                                                      alignment: AlignmentDirectional.center,
                                                      child: Text(BookGenres().allBookGenres[i-1], textAlign: TextAlign.center,
                                                        style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),
                                                      )
                                                  )
                                              ),
                                            );
                                          return items;
                                        },
                                        items: [
                                          for(int i = 0; i < BookGenres().allBookGenres.length + 1; i++)
                                            i == 0 ?
                                            DropdownMenuItem(
                                              value: i,
                                              child: Text("All genres", textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,)
                                              ),
                                            ) :
                                            DropdownMenuItem(
                                              value: i,
                                              child: Text(BookGenres().allBookGenres[i-1], textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: _isTablet ? 17.0 : 14.0,),
                                              ),
                                            ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _dropdownGenreValue = value;
                                            _dropdownGenreLabel =
                                            value == 0 ? "" : BookGenres().allBookGenres[value - 1];
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("ISBN", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: _isTablet ? 18.0 : 15.0,
                                      ),),
                                      Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),),
                                      Container(
                                        width: 220,
                                        child: TextFormField(
                                          controller: _isbnFormFieldController,
                                          decoration: InputDecoration(
                                            hintStyle: TextStyle(fontSize: _isTablet ? 17.0 : 14.0, color: Colors.white12,),
                                            hintText: "Insert ISBN (also partial)",
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _isbnFilter = value;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 4.0)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            filter();
                                            if(!_isRemoveFilterEnabled) {
                                              _isRemoveFilterEnabled = true;
                                            }
                                            _filterExpansionTileKey.currentState.collapse();
                                          });
                                        },
                                        child: Text("Apply",style: TextStyle(fontSize: _isTablet ? 20.0 : 17.0,),),
                                      ),
                                      _isRemoveFilterEnabled ? TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _lessThanFormFieldController.clear();
                                              _greaterThanFormFieldController.clear();
                                              _isbnFormFieldController.clear();
                                              _greaterThanPrice = "";
                                              _lessThanPrice = "";
                                              _isbnFilter = "";
                                              clearFilter();
                                              _isRemoveFilterEnabled = false;
                                              _photosCheckBox = false;
                                              _exchangeableCheckBox = false;

                                              _filterExpansionTileKey.currentState.collapse();
                                            });
                                          },
                                          child: Text("Remove",style: TextStyle(fontSize: _isTablet ? 20.0 : 17.0,),)
                                      ) : TextButton(child: Text("Remove",style: TextStyle(fontSize: _isTablet ? 20.0 : 17.0,),)
                                      )
                                    ],
                                  ),
                                  Padding(padding: const EdgeInsets.symmetric(vertical: 2.0)),
                                ],
                              ),*/
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ) : Container(),
                _openModifiersSection ? Container(
                  width: MediaQuery.of(context).size.width/2.5,
                  child: ListTileTheme(
                    dense: true,
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ManuallyCloseableExpansionTile(
                        onExpansionChanged: (val) {
                          if(val) {
                            _filterExpansionTileKey.currentState.collapse();
                          }
                        },
                        key: _orderbyExpansionTileKey,
                        initiallyExpanded: false,
                        title: Text("Order by", style: TextStyle(fontSize: _isTablet ? 19.0 : 15),),
                        children: <Widget>[
                          Container(
                            height: _isTablet ? 120.0 : 80.0,
                            child: ListView.builder(
                              itemCount: 2,
                              itemBuilder: (BuildContext context, int index) {
                                return index == 0 ?
                                  Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: _isTablet ? 8.0 : 0.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: CustomRadioButton(
                                    initialSelection: _selectedOrderValue,
                                    buttonLables: orderByBookLabels,
                                    buttonValues: orderByBookLabels,
                                    radioButtonValue: (value, index) {
                                      setState(() {
                                        _searchLoading = true;
                                        bool toReorder = _selectedOrder != value;
                                        _selectedOrder = value;
                                        _selectedOrderValue = index;
                                        if(toReorder) {
                                          reorder();
                                        }
                                        _orderbyExpansionTileKey.currentState.collapse();
                                      });
                                      setState(() {
                                        _searchLoading = false;
                                      });
                                    },
                                    buttonHeight: _isTablet ? 40.0 : 30,
                                    lineSpace: _isTablet ? 15.0 : 0.0,
                                    fontSize: _isTablet ? 17.0 : 14,
                                    elevation: 0.0,
                                    horizontal: true,
                                    enableShape: true,
                                    buttonSpace: _isTablet ? 13.0 : 5.0,
                                    textColor: Colors.white,
                                    selectedTextColor: Colors.black,
                                    buttonColor: Colors.white12,
                                    selectedColor: Colors.white,
                                  ),
                                ) : DropdownButton(
                                  key: UniqueKey(),
                                  dropdownColor: Colors.grey[700],
                                  elevation: 0,
                                  value: _dropdownValue,
                                  items: [
                                    DropdownMenuItem(
                                      value: orderByAscendingWayValue,
                                      child: Text(orderByAscendingWay, style: TextStyle(fontSize: _isTablet ? 18.0 : 14.0,),),
                                    ),
                                    DropdownMenuItem(
                                      value: orderByDescendingWayValue,
                                      child: Text(orderByDescendingWay, style: TextStyle(fontSize: _isTablet ? 18.0 : 14.0,),),
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
                                      _orderbyExpansionTileKey.currentState.collapse();
                                    });
                                  },
                                );
                            },),
                          ),
                        ],
                      ),
                    ),
                  ),
                ) : Container(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                height: MediaQuery.of(context).size.width,
                width: 1.0,
              ),
            ),
            _searchLoading ? Expanded(flex: 26, child: Loading()) :
            (
                booksAllInfo == null || booksAllInfo.length == 0 ?
                Expanded(
                  flex: 30,
                  child: Container(
                    alignment: AlignmentDirectional.topCenter,
                    /*decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.0),
                    ),*/
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(_resultMessage,
                              style: TextStyle(color: Colors.white,  fontSize: _isTablet ? 20.0 : 14.0,),),
                            Icon(Icons.menu_book_rounded, color: Colors.white, size: _isTablet ? 30.0 : 20.0,),
                          ],
                        ),
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
                                        tilePadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: _isTablet ? 90.0 : 20.0),
                                        title: Column(
                                          children: <Widget>[
                                            Text(booksAllInfo[i][0]['book']['title'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:  _isTablet ? 22.0 : 17.0
                                              ),
                                            ),
                                            Text(booksAllInfo[i][0]['book']['author'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: _isTablet ? 18.0 : 14.0,
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
                                                fontSize: _isTablet ? 20.0 : 15.0,
                                              ),
                                            ) :
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text("€"+booksAllInfo[i][0]['book']['price'].toStringAsFixed(2),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: _isTablet ? 18.0 : 15.0,
                                                  ),
                                                ),
                                                Text(" and others..",
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: _isTablet ? 17.0 : 14.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: _isTablet ? 90.0 : 0.0),
                                                child: SearchBookInfoBody(
                                                  book: booksAllInfo[i],
                                                  bookInfo: booksAllInfo[i][0]['info'],
                                                  setLoading: setLoading,
                                                  fatherContext: context,
                                                ),
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
                                      child: Divider(height: 2.0, thickness: 2.0, indent: _isTablet ? 100.0 : 12.0, endIndent: _isTablet ? 100.0 : 12.0,)
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
      ),
    );
  }

  void filter() {
    clearFilter();
    booksAllInfoCopy.addAll(booksAllInfo);

    RegExp regExp1 = RegExp(r'([\d]+\.[\d]{1,2}$|^[\d]+$)');       //well defined price format
    RegExp regExp2 = RegExp(r'(^[0]+$|^[0]+\.[0]{1,2}$)');       //price with all digits equal to zero should not be matched
    if(!regExp1.hasMatch(_greaterThanPrice) || regExp2.hasMatch(_greaterThanPrice)) {
      _greaterThanPrice = "";
      _greaterThanFormFieldController.clear();
    }
    if(!regExp1.hasMatch(_lessThanPrice) || regExp2.hasMatch(_lessThanPrice)) {
      _lessThanPrice = "";
      _lessThanFormFieldController.clear();
    }

    booksAllInfo.removeWhere((element) {

      bool toRemove = false;

      if(_isbnFilter.isNotEmpty) {
        bool toRemovePartial = true;
        for(int i = 0; i < element.length; i++) {
          if(element[i]['book']['isbn'] != null &&
              element[i]['book']['isbn'].toString().contains(_isbnFilter)) {
            toRemovePartial = false;
            break;
          }
        }
        toRemove = toRemovePartial ? true : false;
      }

      if(!toRemove && _dropdownGenreLabel.isNotEmpty) {
        bool toRemovePartial = true;
        for(int i = 0; i < element.length; i++) {
          if(element[i]['book']['category'].toString().compareTo(
              _dropdownGenreLabel) == 0) {
            toRemovePartial = false;
            break;
          }
        }
        toRemove = toRemovePartial ? true : false;
      }

      if(!toRemove && _greaterThanPrice.isNotEmpty) {
        bool toRemovePartial = true;
        for(int i = 0; i < element.length; i++) {
          if(element[i]['book']['price'] >= double.parse(_greaterThanPrice)) {
            toRemovePartial = false;
            break;
          }
        }
        toRemove = toRemovePartial ? true : false;
      }
      if(!toRemove && _lessThanPrice.isNotEmpty) {
        bool toRemovePartial = true;
        for(int i = 0; i < element.length; i++) {
          if(element[i]['book']['price'] <= double.parse(_lessThanPrice)) {
            toRemovePartial = false;
            break;
          }
        }
        toRemove = toRemovePartial ? true : false;
      }

      if(!toRemove && _photosCheckBox) {
        bool toRemovePartial = true;
        for(int i = 0; i < element.length; i++) {
          if(element[i]['book']['imagesUrl'].length > 0) {
            toRemovePartial = false;
            break;
          }
        }
        toRemove = toRemovePartial ? true : false;
      }

      if(!toRemove && _exchangeableCheckBox) {
        bool toRemovePartial = true;
        for(int i = 0; i < element.length; i++) {
          if(element[i]['book']['exchangeable']) {
            toRemovePartial = false;
            break;
          }
        }
        toRemove = toRemovePartial ? true : false;
      }

      return toRemove;
    });
  }

  void clearFilter() {
    if(booksAllInfoCopy.isEmpty) {
      return;
    }
    booksAllInfo.clear();
    booksAllInfo.addAll(booksAllInfoCopy);
    booksAllInfoCopy.clear();
  }

  void reorder() {
    switch(_selectedOrder) {
      case orderByTitleLabel:
        reorderByStringFieldInUserCollection("title");
        break;

      case orderByAuthorLabel:
        reorderByStringFieldInUserCollection("author");
        break;

      case orderByLanguageLabel:
        reorderByStringFieldInBookCollection("language");
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
