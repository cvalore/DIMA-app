import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/profile/orders/ordersMainPage.dart';
import 'package:flutter_firebase_auth/screens/profile/paymentInfo/savedPaymentMethod.dart';
import 'file:///C:/Users/cvalo/Documents/polimi/magistrale/II-anno/I%20semestre/DIMA/DIMA-app/Sources/flutter_firebase_auth/lib/utils/loading.dart';
import 'package:flutter_firebase_auth/utils/utils.dart';

class PaymentInfo extends StatefulWidget {

  double height;

  PaymentInfo({Key key, @required this.height}) : super(key: key);

  @override
  _PaymentInfoState createState() => _PaymentInfoState();
}

class _PaymentInfoState extends State<PaymentInfo> {
  @override
  Widget build(BuildContext context) {

    return Container(
        height: widget.height,
        child: InkWell(
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FutureBuilder(
                  future: Utils.databaseService.getPaymentInfo(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting)
                      return Loading();
                    else {
                      print(snapshot.data);
                      return SavedPaymentMethod(
                        savedPaymentMethods: snapshot.data['paymentCardInfo'],
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
                              Icons.monetization_on_outlined,
                            ),
                          )
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("My payment methods",
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

