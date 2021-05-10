import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/profile/visualizeProfile/visualizeProfileMainPage.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
import 'package:flutter_firebase_auth/utils/bookPerGenreUserMap.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:radio_grouped_buttons/custom_buttons/custom_radio_buttons_group.dart';

class SearchUserPage extends StatefulWidget {
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {

  final GlobalKey<FormState> _searchUserFormKey = GlobalKey();
  final GlobalKey<ManuallyCloseableExpansionTileState> _orderbyExpansionTileKey = GlobalKey();

  List<dynamic> allUsersFound = List<dynamic>();

  String _searchUsername = "";

  bool _openModifiersSection = false;
  bool _searchLoading = false;

  String _selectedOrder = orderByNoOrderLabel;
  int _selectedOrderValue = 0;
  String _selectedOrderWay = orderByAscendingWay;
  int _dropdownValue = orderByAscendingWayValue;

  String _resultMessage = "No results";

  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    return Container(
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
                alignment: AlignmentDirectional.center,
                height: _isTablet ? 150 : 90,
                width: -100 + (_isTablet ? MediaQuery.of(context).size.width/1.75 : MediaQuery.of(context).size.width),
                child: Form(
                  key: _searchUserFormKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0,),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      //decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                      decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: _isTablet ? 21.0 : 17.0,),
                      onChanged: (value) {
                        setState(() {
                          _searchUsername = value;
                        });
                      },
                    ),
                  ),
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
                          if(_orderbyExpansionTileKey != null && _orderbyExpansionTileKey.currentState != null) {
                            _orderbyExpansionTileKey.currentState.collapse();
                          }

                          if(_searchUsername.isEmpty) {
                            _resultMessage = "Insert a username";
                            valid = false;
                            return;
                          }

                          _searchLoading = true;
                          //_openModifiersSection = false;
                        });

                        if(!valid) {
                          allUsersFound.clear();
                          return;
                        }

                        dynamic allUsers = await _db.getAllUsers();

                        setState(() {
                          _searchLoading = false;
                          allUsersFound.clear();
                          allUsersFound.addAll(
                            allUsers.where(
                                    (b) => b['username'].toString().toLowerCase().contains(
                                        _searchUsername.toLowerCase()
                                )
                            )
                          );
                          allUsersFound.forEach((element) {
                            element['averageRating'] =
                                element['receivedReviews'] == null || element['receivedReviews'].length == 0 ?
                                    0.0 :
                            (1.0*((element['receivedReviews']
                                .map((e) => e['stars'] != null ? e['stars'] : 0))
                                .fold(0, (p,c) => p+c))
                                /element['receivedReviews'].length);
                          });
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
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ManuallyCloseableExpansionTile(
                key: _orderbyExpansionTileKey,
                initiallyExpanded: false,
                title: Text("Order by", style: TextStyle(fontSize: _isTablet ? 19.0 : 15),),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    child: CustomRadioButton(
                      initialSelection: _selectedOrderValue,
                      buttonLables: orderByUsersLabels,
                      buttonValues: orderByUsersLabels,
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
          _searchLoading ? Expanded(flex: 26, child: Loading()) : (
              allUsersFound == null || allUsersFound.length == 0 ?
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
                        Icon(Icons.person, color: Colors.white, size: _isTablet ? 30.0 : 20.0,),
                      ],
                    ),

                  ),
                ),
              ) :
              Expanded(
                flex: 30,
                child: Container(
                  /*decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                  ),*/
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        for(int i = 0; i < allUsersFound.length; i++)
                          Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Container(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                child: InkWell(
                                  onTap: () async {
                                    DatabaseService databaseService = DatabaseService(
                                        user: CustomUser(allUsersFound[i]['uid']));
                                    CustomUser user = await databaseService
                                        .getUserSnapshot();
                                    BookPerGenreUserMap userBooks = await databaseService
                                        .getUserBooksPerGenreSnapshot();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            VisualizeProfileMainPage(
                                                user: user,
                                                books: userBooks.result,
                                                self: allUsersFound[i]['uid'] == Utils.mySelf.uid)
                                        )
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 0.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            CircleAvatar(
                                              backgroundColor: Colors.teal[100],
                                              radius: _isTablet ? 40.0 : 25.0,
                                              child: allUsersFound[i]['userProfileImageURL'] != null &&
                                                  allUsersFound[i]['userProfileImageURL'].toString().isNotEmpty ?
                                              CircleAvatar(

                                                radius: _isTablet ? 40.0 : 25.0,
                                                backgroundImage: NetworkImage(allUsersFound[i]['userProfileImageURL']),
                                                //FileImage(File(user.userProfileImagePath))
                                              ) : Text(
                                                allUsersFound[i]['username'][0].toUpperCase(),
                                                textScaleFactor: 1,
                                                ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: _isTablet ? 50.0 : 25.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(allUsersFound[i]['username'].toString(),
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isTablet ? 20.0 : 16.0),),
                                                  Text(allUsersFound[i]['email'].toString(),
                                                    style: TextStyle(fontSize: _isTablet ? 18.0 : 14.0),),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        _isTablet ? Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),) : Container(),
                                        Padding(
                                          padding: EdgeInsets.only(right: _isTablet ? 50.0 : 12.5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              for(int j = 0; j < 5; j++)
                                                Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  width: _isTablet ? 35.0 : 30.0,
                                                  child: allUsersFound[i]['averageRating'] > i && allUsersFound[i]['averageRating'] < i + 1 ?
                                                  Icon(Icons.star_half_outlined, color: Colors.yellow,) :
                                                  allUsersFound[i]['averageRating'] > i ?
                                                  Icon(Icons.star, color: Colors.yellow,) :
                                                  Icon(Icons.star_border, color: Colors.yellow,),
                                                ),
                                                SizedBox(width: 20.0),
                                                Text(
                                                allUsersFound[i]['receivedReviews'].length != 1 ?
                                                allUsersFound[i]['receivedReviews'].length.toString() + ' reviews' :
                                                '1 review',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(fontSize: _isTablet ? 18.0 : 16.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Divider(height: 2.0, thickness: 2.0, indent: _isTablet ? 100.0 : 12.0, endIndent: _isTablet ? 100.0 : 12.0,)
                              ),
                            ]
                          )
                      ],
                    ),

                  ),
                ),
              )
          ),
        ],
      ):
      Row(
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
                        alignment: AlignmentDirectional.center,
                        height: _isTablet ? 150 : 90,
                        width: -100 + (_isTablet ? _isPortrait ? MediaQuery.of(context).size.width/1.75 : MediaQuery.of(context).size.width/2.5 : _isPortrait ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width/2.2),
                        child: Form(
                          key: _searchUserFormKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0,),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              //decoration: inputFieldDecoration.copyWith(hintText: 'Title'),
                              decoration: InputDecoration(
                                hintText: 'Username',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                                filled: true,
                                fillColor: Colors.white12,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: _isTablet ? 21.0 : 17.0,),
                              onChanged: (value) {
                                setState(() {
                                  _searchUsername = value;
                                });
                              },
                            ),
                          ),
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
                                  if(_orderbyExpansionTileKey != null && _orderbyExpansionTileKey.currentState != null) {
                                    _orderbyExpansionTileKey.currentState.collapse();
                                  }

                                  if(_searchUsername.isEmpty) {
                                    _resultMessage = "Insert a username";
                                    valid = false;
                                    return;
                                  }

                                  _searchLoading = true;
                                  //_openModifiersSection = false;
                                });

                                if(!valid) {
                                  allUsersFound.clear();
                                  return;
                                }

                                dynamic allUsers = await _db.getAllUsers();

                                setState(() {
                                  _searchLoading = false;
                                  allUsersFound.clear();
                                  allUsersFound.addAll(
                                      allUsers.where(
                                              (b) => b['username'].toString().toLowerCase().contains(
                                              _searchUsername.toLowerCase()
                                          )
                                      )
                                  );
                                  allUsersFound.forEach((element) {
                                    element['averageRating'] =
                                    element['receivedReviews'] == null || element['receivedReviews'].length == 0 ?
                                    0.0 :
                                    (1.0*((element['receivedReviews']
                                        .map((e) => e['stars'] != null ? e['stars'] : 0))
                                        .fold(0, (p,c) => p+c))
                                        /element['receivedReviews'].length);
                                  });
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
                _openModifiersSection ?
                Container(
                  width: MediaQuery.of(context).size.width/2.5,
                  child: ListTileTheme(
                    dense: true,
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ManuallyCloseableExpansionTile(
                        key: _orderbyExpansionTileKey,
                        initiallyExpanded: false,
                        title: Text("Order by", style: TextStyle(fontSize: _isTablet ? 19.0 : 15),),
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            width: MediaQuery.of(context).size.width,
                            child: CustomRadioButton(
                              initialSelection: _selectedOrderValue,
                              buttonLables: orderByUsersLabels,
                              buttonValues: orderByUsersLabels,
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
                  ),
                ) : Container(),
              ],
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: _isTablet ? 20.0 : 0.0),
                child: Divider(height: 2.0, thickness: 2.0, indent: _isTablet ? 50.0 : 12.0, endIndent: _isTablet ? 50.0 : 12.0,)
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                height: MediaQuery.of(context).size.width,
                width: 1.0,
              ),
            ),
            _searchLoading ? Expanded(flex: 26, child: Loading()) : (
                allUsersFound == null || allUsersFound.length == 0 ?
                Expanded(
                  flex: 30,
                  child: Container(
                    alignment: AlignmentDirectional.topCenter,
                    /*decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                  ),*/
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(_resultMessage,
                              style: TextStyle(color: Colors.white,  fontSize: _isTablet ? 20.0 : 14.0,),),
                            Icon(Icons.person, color: Colors.white, size: _isTablet ? 30.0 : 20.0,),
                          ],
                        ),
                      ),

                    ),
                  ),
                ) :
                Expanded(
                  flex: 30,
                  child: Container(
                    /*decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2.0),
                  ),*/
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          for(int i = 0; i < allUsersFound.length; i++)
                            Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Container(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                    child: InkWell(
                                      onTap: () async {
                                        DatabaseService databaseService = DatabaseService(
                                            user: CustomUser(allUsersFound[i]['uid']));
                                        CustomUser user = await databaseService
                                            .getUserSnapshot();
                                        BookPerGenreUserMap userBooks = await databaseService
                                            .getUserBooksPerGenreSnapshot();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>
                                                VisualizeProfileMainPage(
                                                    user: user,
                                                    books: userBooks.result,
                                                    self: allUsersFound[i]['uid'] == Utils.mySelf.uid)
                                            )
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 0.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  backgroundColor: Colors.teal[100],
                                                  radius: _isTablet ? 40.0 : 25.0,
                                                  child: allUsersFound[i]['userProfileImageURL'] != null &&
                                                      allUsersFound[i]['userProfileImageURL'].toString().isNotEmpty ?
                                                  CircleAvatar(
                                                    radius: _isTablet ? 40.0 : 25.0,
                                                    backgroundImage: NetworkImage(allUsersFound[i]['userProfileImageURL']),
                                                    //FileImage(File(user.userProfileImagePath))
                                                  ) : Text(
                                                    allUsersFound[i]['username'][0].toUpperCase(),
                                                    textScaleFactor: 1,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: _isTablet ? 50.0 : 25.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(allUsersFound[i]['username'].toString(),
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: _isTablet ? 20.0 : 16.0),),
                                                      Text(allUsersFound[i]['email'].toString(),
                                                        style: TextStyle(fontSize: _isTablet ? 18.0 : 14.0),),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            _isTablet ? Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),) : Container(),
                                            Padding(
                                              padding: EdgeInsets.only(right: _isTablet ? 50.0 : 12.5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  for(int j = 0; j < 5; j++)
                                                    Container(
                                                      padding: EdgeInsets.all(5.0),
                                                      width: _isTablet ? 35.0 : 30.0,
                                                      child: allUsersFound[i]['averageRating'] > i && allUsersFound[i]['averageRating'] < i + 1 ?
                                                      Icon(Icons.star_half_outlined, color: Colors.yellow,) :
                                                      allUsersFound[i]['averageRating'] > i ?
                                                      Icon(Icons.star, color: Colors.yellow,) :
                                                      Icon(Icons.star_border, color: Colors.yellow,),
                                                    ),
                                                  SizedBox(width: 20.0),
                                                  Text(
                                                    allUsersFound[i]['receivedReviews'].length != 1 ?
                                                    allUsersFound[i]['receivedReviews'].length.toString() + ' reviews' :
                                                    '1 review',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontSize: _isTablet ? 18.0 : 16.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Divider(height: 2.0, thickness: 2.0, indent: _isTablet ? 100.0 : 12.0, endIndent: _isTablet ? 100.0 : 12.0,)
                                  ),
                                ]
                            )
                        ],
                      ),

                    ),
                  ),
                )
            ),
          ],
        ),
    );
  }

  void reorder() {
    switch(_selectedOrder) {
      case orderByStarsLabel:
        reorderByStars();
        break;

      case orderByNumberReviewLabel:
        reorderByNumberOfReviews();
        break;

      default:
        break;
    }
  }

  void reorderByStars() {
    allUsersFound.sort(
      (a, b) {
        return _selectedOrderWay == orderByAscendingWay ?
            (a == null || a['averageRating'] == null) ? 1 :
            (b == null || b['averageRating'] == null) ? -1 : (
                a['averageRating'] > b['averageRating'] ? 1 : -1
            )
            :
            (b == null || b['averageRating'] == null) ? 1 :
            (a == null || a['averageRating'] == null) ? -1 : (
                b['averageRating'] > a['averageRating'] ? 1 : -1
            );
      }
    );
  }

  void reorderByNumberOfReviews() {
    allUsersFound.sort(
            (a, b) {
          return _selectedOrderWay == orderByAscendingWay ?
          (a == null || a['receivedReviews'] == null) ? 1 :
          (b == null || b['receivedReviews'] == null) ? -1 : (
              a['receivedReviews'].length > b['receivedReviews'].length ? 1 : -1
          )
              :
          (b == null || b['receivedReviews'] == null) ? 1 :
          (a == null || a['receivedReviews'] == null) ? -1 : (
              b['receivedReviews'].length > a['receivedReviews'].length ? 1 : -1
          );
        }
    );
  }

}
