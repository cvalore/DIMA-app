import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/shared/loading.dart';
import 'package:flutter_firebase_auth/shared/manuallyCloseableExpansionTile.dart';
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

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    AuthCustomUser userFromAuth = Provider.of<AuthCustomUser>(context);
    CustomUser user = CustomUser(userFromAuth.uid, email: userFromAuth.email, isAnonymous: userFromAuth.isAnonymous);
    DatabaseService _db = DatabaseService(user: user);

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
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
                height: 90,
                width: -100 + (_isTablet ? MediaQuery.of(context).size.width/2 : MediaQuery.of(context).size.width),
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
                      style: TextStyle(color: Colors.white, fontSize: 17.0,),
                      validator: (value) =>
                      value.isEmpty ? 'Enter username to search for' : null,
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
                        if(!_searchUserFormKey.currentState.validate()) {
                          return;
                        }

                        setState(() {
                          if(_orderbyExpansionTileKey != null && _orderbyExpansionTileKey.currentState != null) {
                            _orderbyExpansionTileKey.currentState.collapse();
                          }
                          _searchLoading = true;
                          //_openModifiersSection = false;
                        });

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
                title: Text("Order by", style: TextStyle(fontSize: 15),),
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
                    key: UniqueKey(),
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
                        _orderbyExpansionTileKey.currentState.collapse();
                      });
                    },
                  ),
                ],
              ),
            ),
          ) : Container(),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Divider(height: 2.0, thickness: 2.0, indent: 12.0, endIndent: 12.0,)
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
                        Text('No results',
                          style: TextStyle(color: Colors.white,  fontSize: _isTablet ? 20.0 : 14.0,),),
                        Icon(Icons.menu_book_rounded, color: Colors.white, size: _isTablet ? 30.0 : 20.0,),
                      ],
                    ),

                  ),
                ),
              ) :
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
                        Text('TODO SEARCH',
                          style: TextStyle(color: Colors.white,  fontSize: _isTablet ? 20.0 : 50.0,),),
                        Icon(Icons.menu_book_rounded, color: Colors.white, size: _isTablet ? 30.0 : 50.0,),
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
    print("TODO REORDER");
  }
}
