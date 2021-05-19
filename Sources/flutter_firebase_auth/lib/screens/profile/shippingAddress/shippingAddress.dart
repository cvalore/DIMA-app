import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/profile/shippingAddress/savedShippingAddress.dart';
import 'package:flutter_firebase_auth/utils/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';


class ShippingAddress extends StatefulWidget {

  double height;

  ShippingAddress({Key key, @required this.height}) : super(key: key);

  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  @override
  Widget build(BuildContext context) {

    return Container(
        height: widget.height,
        child: InkWell(
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FutureBuilder(
                  future: Utils.databaseService.getShippingAddressInfo(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting)
                      return Loading();
                    else {
                      print(snapshot.data);
                      return SavedShippingAddress(
                        savedShippingAddress: snapshot.data['shippingAddressInfo'],
                      );
                    }
                  }
              );
            }));
          },
          child: Row(
            children: [
              Expanded(
                  flex: 10,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.local_shipping_outlined,
                            ),
                          )
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("My shipping addresses",
                            style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              Expanded(
                flex: 1,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white),
              )
            ],
          ),
        )
    );
  }
}

