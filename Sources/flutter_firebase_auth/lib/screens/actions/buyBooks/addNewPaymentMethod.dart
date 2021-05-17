import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class AddNewPaymentMethod extends StatefulWidget {

  Map<String, dynamic> paymentMethod;
  bool viewModeOn;

  AddNewPaymentMethod({Key key, this.paymentMethod, this.viewModeOn = false});


  @override
  AddNewPaymentMethodState createState() => AddNewPaymentMethodState();
}

class AddNewPaymentMethodState extends State<AddNewPaymentMethod> {

  final _ownerNameKey = GlobalKey<FormFieldState>();
  final _cardNumber = GlobalKey<FormFieldState>();
  final _expiringDateKey = GlobalKey<FormFieldState>();
  final _securityCodeKey = GlobalKey<FormFieldState>();
  Map<String, dynamic> infoState = Map<String, dynamic>();
  FocusNode myFocusNode;


  @override
  void initState() {
    myFocusNode = FocusNode();
    infoState['ownerName'] = '';
    infoState['cardNumber'] = '';
    infoState['expiringDate'] = '';
    infoState['securityCode'] = '';
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
        title: Text('Payment method info'),
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
                key: ValueKey('SavePaymentMethod'),
                onPressed: () async {
                  myFocusNode.requestFocus();
                  myFocusNode.unfocus();
                  final snackBar = SnackBar(
                    backgroundColor: Colors.white24,
                    duration: Duration(seconds: 1),
                    content: Text(
                      'Your card has been successfully added',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  );
                  if (_ownerNameKey.currentState.validate() && _cardNumber.currentState.validate()
                      && _expiringDateKey.currentState.validate() && _securityCodeKey.currentState.validate()) {
                    await Utils.databaseService.savePaymentCardInfo(infoState);
                    Scaffold.of(context).showSnackBar(snackBar);
                    Timer(Duration(milliseconds: 1500), () {Navigator.pop(context, infoState);});
                  }
                },
                //label: Text('Save payment method'),
                icon: Icon(Icons.check_outlined),
              );
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: TextFormField(
                  enabled: !widget.viewModeOn,
                  key: _ownerNameKey,
                  focusNode: myFocusNode,
                  initialValue: widget.paymentMethod != null && widget.paymentMethod['ownerName'] != '' ? widget.paymentMethod['ownerName'] : null,
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
                    filled: true,
                  ),
                  validator: (value) {
                    RegExp regExp = RegExp(r'^[A-Za-z]+( [A-Za-z]+){1,2}');
                    return !regExp.hasMatch(value) ? 'Enter a valid name' : null;
                  },
                  onChanged: (value) {
                    if(value != '') {
                      setState(() {
                        infoState['ownerName'] = value;
                      });
                    }
                  },
                ),
              ),
              Divider(height: 20, thickness: 2, indent: _isTablet ? 20.0 : 0.0, endIndent: _isTablet ? 20.0 : 0.0,),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: TextFormField(
                  key: _cardNumber,
                  enabled: !widget.viewModeOn,
                  initialValue: widget.paymentMethod != null && widget.paymentMethod['cardNumber'] != '' ? widget.paymentMethod['cardNumber'] : null,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '0000 0000 0000 0000',
                    labelStyle: TextStyle(fontSize: 16,
                    ),
                    labelText: "Card number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    RegExp regExp = RegExp(r'^\d{4}( \d{4}){3}$');
                    return !regExp.hasMatch(value) ? 'Enter a valid card number' : null;
                  },
                  onChanged: (value) {
                    setState(() {
                      infoState['cardNumber'] = value;
                    });
                  },
                ),
              ),
              Divider(height: 20, thickness: 2, indent: _isTablet ? 20.0 : 0.0, endIndent: _isTablet ? 20.0 : 0.0,),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: TextFormField(
                  key: _expiringDateKey,
                  enabled: !widget.viewModeOn,
                  initialValue: widget.paymentMethod != null && widget.paymentMethod['expiringDate'] != '' ? widget.paymentMethod['expiringDate'] : null,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(
                    hintText: 'MM/AA',
                    labelStyle: TextStyle(fontSize: 16,
                    ),
                    labelText: "Expiring date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    RegExp regExp = RegExp(r'^\d{2}/\d{2}$');
                    if (!regExp.hasMatch(value) || int.parse(value.substring(0,2)) > 12
                        || int.parse(value.substring(0,2)) < 1) {
                      return 'Enter a valid expiring date';
                    }
                    int expiringYearCard = int.parse("20" + value.substring(3,5));
                    int expiringMonthCard = int.parse(value.substring(0,2));
                    if (expiringYearCard > DateTime.now().year || (expiringYearCard == DateTime.now().year && expiringMonthCard > DateTime.now().month))
                      return null;
                    else return 'Enter a valid expiring date';
                  },
                  onChanged: (value) {
                    setState(() {
                      infoState['expiringDate'] = value;
                    }
                    );
                  },
                ),
              ),
              Divider(height: 20, thickness: 2, indent: _isTablet ? 20.0 : 0.0, endIndent: _isTablet ? 20.0 : 0.0,),
              Padding(
                padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
                child: TextFormField(
                  key: _securityCodeKey,
                  enabled: !widget.viewModeOn,
                  initialValue: widget.paymentMethod != null && widget.paymentMethod['securityCode'] != '' ? widget.paymentMethod['securityCode'] : null,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'E.g. 000',
                    labelStyle: TextStyle(fontSize: 16,
                    ),
                    labelText: "CVV/CV2",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0),),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    filled: true,
                  ),
                  validator: (value) {
                    RegExp regExp1 = RegExp(r'^[\d]{3,4}$');
                    return !regExp1.hasMatch(value) ?
                    'Enter a valid security code' : null;
                  },
                  onChanged: (value) {
                    if(value != '') {
                      setState(() {
                        infoState['securityCode'] = value;
                      });
                    }
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
