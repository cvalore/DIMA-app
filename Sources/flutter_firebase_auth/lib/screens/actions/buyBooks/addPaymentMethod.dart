import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addNewPaymentMethod.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';

class AddPaymentMethod extends StatefulWidget {

  List<dynamic> savedPaymentMethods;
  dynamic currentPaymentMethod;

  AddPaymentMethod({Key key, @required this.savedPaymentMethods, this.currentPaymentMethod});

  @override
  _AddPaymentMethodState createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {

  dynamic chosenPaymentMethod;

  @override
  void initState() {
    chosenPaymentMethod = widget.currentPaymentMethod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose payment card'),
      ),
      body: ListView.builder(
        itemCount: widget.savedPaymentMethods.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0 ? ListTileTheme(
            tileColor: Colors.white38,
            child: Padding(
              padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
              child: ListTile(
                title: Text('Add new card'),
                trailing: Icon(Icons.add_circle_outlined),
                onTap: () async {
                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      AddNewPaymentMethod()));
                  if (result != null) {
                    setState(() {
                      widget.savedPaymentMethods.add(result);
                    });
                  }
                },
              ),
            ),
          ) : Padding(
            padding: EdgeInsets.symmetric(horizontal: _isTablet ? 150.0 : 0.0),
            child: RadioListTile(
              activeColor: Colors.white,
              title: Text(widget.savedPaymentMethods[index - 1]['ownerName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text('**** **** **** ${widget.savedPaymentMethods[index - 1]['cardNumber']
                    .substring(widget.savedPaymentMethods[index - 1]['cardNumber'].length - 4)}'
                    '\t   ${widget.savedPaymentMethods[index - 1]['expiringDate']}', style: TextStyle(color: Colors.white)),
              ),
              value: widget.savedPaymentMethods[index - 1],
              controlAffinity: ListTileControlAffinity.trailing,
              groupValue: chosenPaymentMethod,
              onChanged: (value) {
                setState(() {
                  chosenPaymentMethod = value;
                });
                Navigator.pop(context, [widget.savedPaymentMethods, chosenPaymentMethod]);
              },
            ),
          );
        },
      ),
    );
  }
}


