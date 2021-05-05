import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addNewShippingInfo.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'package:flutter_firebase_auth/shared/constants.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class SavedShippingAddress extends StatefulWidget {

  List<dynamic> savedShippingAddress;

  SavedShippingAddress({Key key, @required this.savedShippingAddress});

  @override
  _SavedShippingAddressState createState() => _SavedShippingAddressState();
}

class _SavedShippingAddressState extends State<SavedShippingAddress> {
  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('My addresses'),
      ),
      body: ListView.builder(
        itemCount: widget.savedShippingAddress.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0 ? ListTileTheme(
            tileColor: Colors.white38,
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
          ) : Padding(
            padding: EdgeInsets.symmetric(horizontal: _isTablet ? 150.0 : 0.0),
            child: ListTile(
              onLongPress: () async {
                CustomUser user = CustomUser(Utils.mySelf.uid);
                await DatabaseService(user: user).removeShippingAddress(widget.savedShippingAddress[index - 1]);
                setState(() {
                  widget.savedShippingAddress.removeAt(index - 1);
                });
              },
              onTap: () async {
                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    AddNewShippingInfo(shippingAddress: widget.savedShippingAddress[index - 1], viewModeOn: true)));
                if (result != null) {
                  CustomUser user = CustomUser(Utils.mySelf.uid);
                  await DatabaseService(user: user).removeShippingAddress(widget.savedShippingAddress[index - 1]);
                  setState(() {
                    widget.savedShippingAddress.removeAt(index - 1);
                  });
                }
              },
              title: Text(widget.savedShippingAddress[index - 1]['fullName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(widget.savedShippingAddress[index - 1]['address 1'], style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}


