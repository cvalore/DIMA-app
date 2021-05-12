import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/models/user.dart';
import 'package:flutter_firebase_auth/screens/actions/buyBooks/addNewPaymentMethod.dart';
import 'package:flutter_firebase_auth/services/database.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/constants.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class SavedPaymentMethod extends StatefulWidget {

  List<dynamic> savedPaymentMethods;

  SavedPaymentMethod({Key key, @required this.savedPaymentMethods});

  @override
  _SavedPaymentMethodState createState() => _SavedPaymentMethodState();
}

class _SavedPaymentMethodState extends State<SavedPaymentMethod> {

  @override
  Widget build(BuildContext context) {

    bool _isTablet = MediaQuery.of(context).size.width > mobileMaxWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment cards'),
      ),
      body: ListView.builder(
        itemCount: widget.savedPaymentMethods.length + 1,
        itemBuilder: (BuildContext context, int index) {
          return index == 0 ? ListTileTheme(
            tileColor: Colors.white38,
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
          ) : Padding(
            padding: EdgeInsets.symmetric(horizontal: _isTablet ? 150.0 : 0.0),
            child: ListTile(
              onLongPress: () async {
                CustomUser user = CustomUser(Utils.mySelf.uid);
                await DatabaseService(user: user).removePaymentInfo(widget.savedPaymentMethods[index - 1]);
                setState(() {
                  widget.savedPaymentMethods.removeAt(index - 1);
                });
              },
              onTap: () async {
                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    AddNewPaymentMethod(paymentMethod: widget.savedPaymentMethods[index - 1], viewModeOn: true)));
                if (result != null) {
                  CustomUser user = CustomUser(Utils.mySelf.uid);
                  await DatabaseService(user: user).removePaymentInfo(widget.savedPaymentMethods[index - 1]);
                  setState(() {
                    widget.savedPaymentMethods.removeAt(index - 1);
                  });
                }
              },
              title: Text(widget.savedPaymentMethods[index - 1]['ownerName'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text('**** **** **** ${widget.savedPaymentMethods[index - 1]['cardNumber']
                    .substring(widget.savedPaymentMethods[index - 1]['cardNumber'].length - 4)}'
                    '\t   ${widget.savedPaymentMethods[index - 1]['expiringDate']}', style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}


