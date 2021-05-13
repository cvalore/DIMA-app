import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/utils/constants.dart';

import 'addNewShippingInfo.dart';

class AddShippingInfo extends StatefulWidget {

  List<dynamic> savedShippingAddress;
  dynamic currentShippingAddress;

  AddShippingInfo({Key key, @required this.savedShippingAddress, this.currentShippingAddress});

  @override
  _AddShippingInfoState createState() => _AddShippingInfoState();
}

class _AddShippingInfoState extends State<AddShippingInfo> {

  dynamic chosenShippingAddress;

  @override
  void initState() {
    chosenShippingAddress = widget.currentShippingAddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose address'),
      ),
      body: ListView.builder(
        itemCount: widget.savedShippingAddress.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0 ? ListTileTheme(
            tileColor: Colors.white38,
            child: Padding(
              padding: EdgeInsets.all(_isTablet ? 20.0 : 0.0),
              child: ListTile(
                title: Text('Add new shipping address'),
                trailing: Icon(Icons.add_circle_outlined),
                onTap: () async {
                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      AddNewShippingInfo()));
                  if (result != null) {
                    setState(() {
                      widget.savedShippingAddress.add(result);
                    });
                  }
                },
              ),
            ),
          ) : Padding(
            padding: EdgeInsets.symmetric(horizontal: _isTablet ? 150.0 : 0.0),
            child: RadioListTile(
              activeColor: Colors.white,
              title: Text(widget.savedShippingAddress[index - 1]['fullName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(widget.savedShippingAddress[index - 1]['address 1'], style: TextStyle(color: Colors.white)),
              ),
              value: widget.savedShippingAddress[index - 1],
              controlAffinity: ListTileControlAffinity.trailing,
              groupValue: chosenShippingAddress,
              onChanged: (value) {
                setState(() {
                  chosenShippingAddress = value;
                });
                Navigator.pop(context, [widget.savedShippingAddress, chosenShippingAddress]);
              },
            ),
          );
        },
      ),
    );
  }
}


