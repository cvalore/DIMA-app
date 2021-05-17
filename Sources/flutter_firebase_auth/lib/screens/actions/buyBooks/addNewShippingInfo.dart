import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils/availableCountries.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';


class AddNewShippingInfo extends StatefulWidget {

  Map<String, dynamic> shippingAddress;
  bool viewModeOn;

  AddNewShippingInfo({Key key, this.shippingAddress, this.viewModeOn = false});

  @override
  AddNewShippingInfoState createState() => AddNewShippingInfoState();
}

class AddNewShippingInfoState extends State<AddNewShippingInfo> {

  FocusNode myFocusNode;
  final _fullNameKey = GlobalKey<FormFieldState>();
  final _addressKey = GlobalKey<FormFieldState>();
  final _cityKey = GlobalKey<FormFieldState>();
  final _CAPKey = GlobalKey<FormFieldState>();
  Map<String, dynamic> infoState = Map<String, dynamic>();

  @override
  void initState() {
    myFocusNode = FocusNode();
    infoState['fullName'] = '';
    infoState['state'] = null;
    infoState['address 1'] = '';
    infoState['address 2'] = '';
    infoState['CAP'] = '';
    infoState['city'] = '';
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode = FocusNode();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    bool _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool _isTablet =
    _isPortrait ?
    MediaQuery.of(context).size.width > mobileMaxWidth : MediaQuery.of(context).size.height > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping info'),
        actions: [
          widget.viewModeOn == true ?
          IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {
                Navigator.pop(context, 'delete');
              })
              : Builder(
            builder: (BuildContext context) {
              return IconButton(
                key: ValueKey('SaveShippingAddressButton'),
                onPressed: () async {
                  setState(() {
                    myFocusNode.requestFocus();
                    myFocusNode.unfocus();
                  });
                  if (_fullNameKey.currentState.validate() && _addressKey.currentState.validate()
                      && _CAPKey.currentState.validate() && _cityKey.currentState.validate() && infoState['state'] != null){
                    final snackBar = SnackBar(
                      backgroundColor: Colors.white24,
                      duration: Duration(seconds: 1),
                      content: Text(
                        'The shipping address has been successfully added',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    );
                    await Utils.databaseService.saveShippingAddressInfo(infoState);
                    Scaffold.of(context).showSnackBar(snackBar);
                    Timer(Duration(milliseconds: 1500), () {Navigator.pop(context, infoState);});
                  }
                },
                icon: Icon(Icons.check_outlined),
              );
            },
          ),
        ],
      ),
      //floatingActionButton:
      resizeToAvoidBottomInset: true,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: TextFormField(
                  key: _fullNameKey,
                  enabled: !widget.viewModeOn,
                  focusNode: myFocusNode,
                  initialValue: widget.shippingAddress != null && widget.shippingAddress['fullName'] != '' ? widget.shippingAddress['fullName'] : null,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 16,
                    ),
                    labelText: "Name and Surname",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    filled: true
                  ),
                  validator: (value) {
                    RegExp regExp = RegExp(r'^[A-Za-z]+( [A-Za-z]+){1,2}');
                    return !regExp.hasMatch(value) ? 'Enter a valid name' : null;
                  },
                  onChanged: (value) {
                    if(value != '') {
                      setState(() {
                        infoState['fullName'] = value;
                      });
                    }
                  },
                ),
              ),
              Divider(height: 20, thickness: 2, indent: _isTablet ? 20.0 : 0.0, endIndent: _isTablet ? 20.0 : 0.0,),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: widget.viewModeOn ?
                  TextFormField(
                    enabled: false,
                    initialValue: widget.shippingAddress != null && widget.shippingAddress['state'] != '' ? widget.shippingAddress['state'] : null,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 16,
                      ),
                      labelText: "State",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(7.0),),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      filled: true,
                    ),
                  ): Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'State',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      )
                    ),
                   Expanded(
                     flex: 7,
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                       child: DropdownButton<String>(
                          key: ValueKey('DropDownButton'),
                          hint: const Text('Select a state'),
                          isExpanded: true,
                          value: infoState['state'],
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (String value) {
                            setState(() {
                               infoState['state'] = value;
                            });
                          },
                          items: Countries.getCountries()
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                key: ValueKey(value),
                              ),
                            );
                          }).toList(),
                  ),
                     ),
                   ),
                ],
                ),
              ),
              Divider(height: 20, thickness: 2, indent: _isTablet ? 20.0 : 0.0, endIndent: _isTablet ? 20.0 : 0.0,),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: TextFormField(
                  key: _addressKey,
                  enabled: !widget.viewModeOn,
                  initialValue: widget.shippingAddress != null && widget.shippingAddress['address 1'] != '' ? widget.shippingAddress['address 1'] : null,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    hintText: 'E.g. 221B Baker Street',
                    labelStyle: TextStyle(fontSize: 16,
                    ),
                    labelText: "Address 1",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    filled: true,
                  ),
                  validator: (value) =>
                  value.isEmpty ?
                  'Enter a valid address' : null,
                  onChanged: (value) {
                    setState(() {
                      infoState['address 1'] = value;
                    });
                  },
                ),
              ),
              Divider(height: 20, thickness: 2, indent: _isTablet ? 20.0 : 0.0, endIndent: _isTablet ? 20.0 : 0.0,),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: TextFormField(
                  enabled: !widget.viewModeOn,
                  initialValue: widget.shippingAddress != null && widget.shippingAddress['address 2'] != null && widget.shippingAddress['address 2'] != '' ? widget.shippingAddress['address 2'] : null,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    hintText: 'E.g. building n°2',
                    labelStyle: TextStyle(fontSize: 16,
                    ),
                    labelText: "Address 2 (optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    filled: true,
                  ),
                  onChanged: (value) {
                      setState(() {
                        infoState['address 2'] = value;
                        }
                    );
                  },
                ),
              ),
              Divider(height: 20, thickness: 2, indent: _isTablet ? 20.0 : 0.0, endIndent: _isTablet ? 20.0 : 0.0,),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: TextFormField(
                  key: _CAPKey,
                  enabled: !widget.viewModeOn,
                  initialValue: widget.shippingAddress != null && widget.shippingAddress['CAP'] != '' ? widget.shippingAddress['CAP'] : null,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'E.g. 82020',
                    labelStyle: TextStyle(fontSize: 16,
                    ),
                    labelText: "CAP",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    RegExp regExp1 = RegExp(r'^[\d]{5}$');
                    return !regExp1.hasMatch(value) ?
                    'Enter a valid CAP' : null;
                  },
                  onChanged: (value) {
                    if(value != '') {
                      setState(() {
                        infoState['CAP'] = value;
                      });
                    }
                  },
                ),
              ),
              Divider(height: 15, thickness: 2, indent: _isTablet ? 20.0 : 0.0, endIndent: _isTablet ? 20.0 : 0.0,),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: TextFormField(
                  key: _cityKey,
                  enabled: !widget.viewModeOn,
                  initialValue: widget.shippingAddress != null && widget.shippingAddress['city'] != '' ? widget.shippingAddress['city'] : null,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 16,
                    ),
                    labelText: "City",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    filled: true,
                    //fillColor: Colors.white24,
                  ),
                  validator: (value) {
                    RegExp regExp1 = RegExp(r'^[ ]*$');
                    return regExp1.hasMatch(value) ?
                    'Enter a valid city' : null;
                  },
                  onChanged: (value) {
                    setState(() {
                      infoState['city'] = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
