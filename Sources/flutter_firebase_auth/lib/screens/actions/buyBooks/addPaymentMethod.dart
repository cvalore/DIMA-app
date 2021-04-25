import 'package:flutter/material.dart';

class AddPaymentMethod extends StatefulWidget {

  Map<String, dynamic> info;

  AddPaymentMethod({Key key , @required this.info});

  @override
  _AddPaymentMethodState createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {

  final _ownerNameKey = GlobalKey<FormFieldState>();
  final _cardNumber = GlobalKey<FormFieldState>();
  final _expiringDateKey = GlobalKey<FormFieldState>();
  final _securityCodeKey = GlobalKey<FormFieldState>();
  Map<String, dynamic> infoState = Map<String, dynamic>();


  @override
  void initState() {
    if (widget.info['ownerName'] == null) {
      infoState['ownerName'] = '';
      infoState['cardNumber'] = '';
      infoState['expiringDate'] = '';
      infoState['securityCode'] = '';
    } else {
      infoState['ownerName'] = widget.info['ownerName'];
      infoState['cardNumber'] = widget.info['cardNumber'];
      infoState['expiringDate'] = widget.info['expiringDate'];
      infoState['securityCode'] = widget.info['securityCode'];
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment method info'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_ownerNameKey.currentState.validate() && _cardNumber.currentState.validate()
              && _expiringDateKey.currentState.validate() && _securityCodeKey.currentState.validate()){
            Navigator.pop(context, infoState);
          }
        },
        label: Text('Save payment method'),
        icon: Icon(Icons.check_outlined),
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
                  key: _ownerNameKey,
                  initialValue: infoState['ownerName'] == '' ? null : infoState['ownerName'],
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
              Divider(height: 20, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  key: _cardNumber,
                  initialValue: infoState['cardNumber'] == '' ? null : infoState['cardNumber'],
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
              Divider(height: 20, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  key: _expiringDateKey,
                  initialValue: infoState['expiringDate'] == '' ? null : infoState['expiringDate'],
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
                    return !regExp.hasMatch(value) ? 'Enter a valid expiring date' : null;
                  },
                  onChanged: (value) {
                    setState(() {
                      infoState['expiringDate'] = value;
                    }
                    );
                  },
                ),
              ),
              Divider(height: 20, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextFormField(
                  key: _securityCodeKey,
                  initialValue: infoState['securityCode'] == '' ? null: infoState['securityCode'],
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
