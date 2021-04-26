import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils/availableCountries.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class AddShippingInfo extends StatefulWidget {

  Map<String, dynamic> info;

  AddShippingInfo({Key key, @required this.info});

  @override
  _AddShippingInfoState createState() => _AddShippingInfoState();
}

class _AddShippingInfoState extends State<AddShippingInfo> {

  final _fullNameKey = GlobalKey<FormFieldState>();
  final _addressKey = GlobalKey<FormFieldState>();
  final _CAPKey = GlobalKey<FormFieldState>();
  Map<String, dynamic> infoState = Map<String, dynamic>();


  @override
  void initState() {
    if (widget.info['fullName'] == null) {
      infoState['fullName'] = '';
      infoState['state'] = '';
      infoState['address 1'] = '';
      infoState['address 2 (optional)'] = '';
      infoState['CAP'] = '';
      infoState['city'] = '';
    } else {
      infoState['fullName'] = widget.info['fullName'];
      infoState['state'] = widget.info['state'];
      infoState['address 1'] = widget.info['address 1'];
      infoState['address 2'] = widget.info['address 2'];
      infoState['CAP'] = widget.info['CAP'];
      infoState['city'] = widget.info['city'];
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping info'),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton.extended(
            onPressed: () {
              if (_fullNameKey.currentState.validate() && _addressKey.currentState.validate() && _CAPKey.currentState.validate()){
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => AlertDialog(
                      content: Text('Do you want to save this address for future purchases?'),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Utils.databaseService.saveShippingAddressInfo(infoState);
                              Navigator.pop(context);
                            },
                            child: Text('SAVE')),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('NO')),
                      ],
                    )
                );
                Navigator.pop(context, infoState);
                final snackBar = SnackBar(
                  backgroundColor: Colors.white24,
                  duration: Duration(seconds: 1),
                  content: Text(
                    'The shipping address has been successfully added',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
                Scaffold.of(context).showSnackBar(snackBar);
                Timer(Duration(milliseconds: 1500), () {Navigator.pop(context);});
              }
            },
            label: Text('Confirm address'),
            icon: Icon(Icons.check_outlined),
          );
        },
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  key: _fullNameKey,
                  initialValue: infoState['fullName'] == '' ? null : infoState['fullName'],
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
              Divider(height: 20, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Row(

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
                          isExpanded: true,
                          value: infoState['state'],
                          icon: const Icon(Icons.keyboard_arrow_down),
                          iconSize: 24,
                          elevation: 16,
                          /*style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),*/
                          onChanged: (value) {
                            setState(() {
                               infoState['state'] = value;
                            });
                          },
                          items: Countries.getCountries()
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                  ),
                     ),
                   ),
                ],
                ),
              ),
              Divider(height: 20, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  key: _addressKey,
                  initialValue: infoState['address 1'] == '' ? null : infoState['address 1'],
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
              Divider(height: 20, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  initialValue: infoState['address 2'] == '' ? null : infoState['address 2'],
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
              Divider(height: 20, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  key: _CAPKey,
                  initialValue: infoState['CAP'] == '' ? null: infoState['CAP'],
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
              Divider(height: 15, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  initialValue: infoState['city'] == '' ? null: infoState['city'],
                  keyboardType: TextInputType.number,
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
